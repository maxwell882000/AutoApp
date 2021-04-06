from .Exception import PayMeException
from .Transactions import Transactions
from .Order import Order
from Auth.Format import Format
from .Request import Request
from .Response import Response
from .Merchant import Merchant


class Application():


    
    def __init__(self,request):
    
        self.request  =  Request(request)
        self.response = Response(self.request)
        self.merchant = Merchant()
    

  
    def run(self):
    
        try:
            self.merchant.Authorize(self.request.id)
            switch = {
                'CheckPerformTransaction' : self.CheckPerformTransaction(),
                'CheckTransaction' :  self.CheckTransaction(),
                'CreateTransaction' :  self.CreateTransaction(),
                'PerformTransaction' : self.PerformTransaction(),
                'CancelTransaction' : self.CancelTransaction(),
                'ChangePassword' : self.ChangePassword(),
                'GetStatement' : self.GetStatement(),
            }
            if self.request['method'] in switch:
                response = switch[self.request['method']]
                return response
            else :
                 self.response.error(
                        PayMeException.ERROR_METHOD_NOT_FOUND,
                        'Method not found.',
                        self.request.method
                    )   
        except PayMeException as e:
           return e.send()
        

    def CheckPerformTransaction(self):
    
        order = Order(self.request.id)
        order.find(self.request.params['account'])

        order.validate(self.request.params)
        transaction = Transactions()
        found       = transaction.find(self.request.params)
        if (found and (found.state == Transactions.STATE_CREATED or found.state == Transactions.STATE_COMPLETED)):
            self.response.error(
                PayMeException.ERROR_COULD_NOT_PERFORM,
                'There is other active/completed transaction for this order.'
            );
        
        return self.response.send({'allow' : True});
    

    def CheckTransaction(self):
    
        transaction =  Transactions()
        found       = transaction.find(self.request.params)
        if (not found):
            self.response.error(
                PayMeException.ERROR_TRANSACTION_NOT_FOUND,
                'Transaction not found.'
            );
        

        # // todo: Prepare and send found transaction
        return self.response.send({
            'create_time'  : Format.datetime2timestamp(found.create_time),
            'perform_time' : Format.datetime2timestamp(found.perform_time),
            'cancel_time'  : Format.datetime2timestamp(found.cancel_time),
            'transaction'  : found._id,
            'state'        : found.state,
            'reason'       : found.reason
        })
    

    def CreateTransaction(self):

        order =  Order(self.request.id)
        order.find(self.request.params['account'])

        order.validate(self.request.params)

        # // todo: Check, is there any other transaction for this order/service
        transaction = Transactions();
        found       = transaction.find({'account' : self.request.params['account']})
        if found:
            if ((found.state == Transactions.STATE_CREATED or found.state == Transactions.STATE_COMPLETED)
                and found.paycom_transaction_id != self.request.params['id']):
                self.response.error(
                    PayMeException.ERROR_INVALID_ACCOUNT,
                    'There is other active/completed transaction for this order.'
                )
            

        # // todo: Find transaction by id
        transaction =  Transactions();
        found       = transaction.find(self.request.params)

        if found:
            if found.state != Transactions.STATE_CREATED:
                self.response.error(
                    PayMeException.ERROR_COULD_NOT_PERFORM,
                    'Transaction found, but is not active.'
                )
            elif found.isExpired():
                found.cancel(Transactions.REASON_CANCELLED_BY_TIMEOUT);
                self.response.error(
                    PayMeException.ERROR_COULD_NOT_PERFORM,
                    'Transaction is expired.'
                )
            else: 
              return  self.response.send({
                    'create_time' : Format.datetime2timestamp(found.create_time),
                    'transaction' : found._id,
                    'state'       : found.state,
                    'receivers'   : found.receivers,
                });
            
        else:
            if (Format.timestamp2milliseconds(1 * self.request.params['time']) - Format.timestamp(True)) >= Transactions.TIMEOUT:
                self.response.error(
                    PayMeException.ERROR_INVALID_ACCOUNT,
                    PayMeException.message(
                        'С даты создания транзакции прошло {}мс'.format(Transactions.TIMEOUT),
                        'Tranzaksiya yaratilgan sanadan {}ms o`tgan'.format(Transactions.TIMEOUT),
                        'Since create time of the transaction passed {}ms'.format(Transactions.TIMEOUT)
                    ),
                    'time'
                )
            

            # // create new transaction
            # // keep create_time as timestamp, it is necessary in response
            create_time                        = Format.timestamp(True)
            transaction.paycom_transaction_id = self.request.params['id']
            transaction.paycom_time           = self.request.params['time']
            transaction.paycom_time_datetime  = Format.timestamp2datetime(self.request.params['time'])
            transaction.create_time           = Format.timestamp2datetime(create_time)
            transaction.state                 = Transactions.STATE_CREATED
            transaction.amount                = self.request.amount
            transaction.order_id              = self.request.account('order_id')
            transaction.save()

            
            return self.response.send({
                'create_time' : create_time,
                'transaction' : transaction.id,
                'state'       : transaction.state,
                'receivers'   : None,
            });
        
    
    def state_create(self,found):
        if found.isExpired(): 
            found.cancel(Transactions.REASON_CANCELLED_BY_TIMEOUT) 
            self.response.error(
                PayMeException.ERROR_COULD_NOT_PERFORM,
                'Transaction is expired.')
        else:
            params = {'order_id': found.order_id}
            order  = Order(self.request.id)
            order.find(params)
            order.changeState(Order.STATE_PAY_ACCEPTED)

            # // todo: Mark transaction as completed
            perform_time        = Format.timestamp(True)
            found.state        = Transactions.STATE_COMPLETED
            found.perform_time = Format.timestamp2datetime(perform_time)
            found.save();

            return self.response.send({
                'transaction'  : found._id,
                'perform_time' : perform_time,
                'state'       : found.state,
            });

    def state_completed(self, found):
        return self.response.send({
                    'transaction'  : found._id,
                    'perform_time' : Format.datetime2timestamp(found.perform_time),
                    'state'        : found.state,
                });
    def performTransaction(self):

        transaction = Transactions();
        
        found = transaction.find(self.request.params)

        if (found):
            self.response.error(PayMeException.ERROR_TRANSACTION_NOT_FOUND, 'Transaction not found.')
        if found.state == Transactions.STATE_CREATED or found.state ==  Transactions.STATE_COMPLETED :
            switcher = {
                Transactions.STATE_CREATED : self.state_create(found),
                Transactions.STATE_COMPLETED : self.state_completed(found),
            }
            return switcher[found.sate]
        else:
            self.response.error(
                    PayMeException.ERROR_COULD_NOT_PERFORM,
                    'Could not perform this operation.'
                )
    
    def cancel(self, found):
        self.response.send({
                    'transaction' : self.found._id,
                    'cancel_time' : Format.datetime2timestamp(found.cancel_time),
                    'state'       :found.state,
        });
    def create_to_cancel(self, found):
        found.cancel(1 * self.request.params['reason'])
        order = Order(self.request.id)
        order.find(self.request.params)
        order.changeState(Order.STATE_CANCELLED)

        return self.response.send({
            'transaction' : found._id,
            'cancel_time' : Format.datetime2timestamp(found.cancel_time),
            'state'       : found.state,
        });
    def complete_to_cancel(self, found):
        # order = Order(self.request.id)
        # order.find(self.request.params);
        # if (order.allowCancel()):
        #     // cancel and change state to cancelled
        #     $found->cancel(1 * $this->request->params['reason']);
        #     // after $found->cancel(), cancel_time and state properties populated with data

        #     $order->changeState(Order::STATE_CANCELLED);

        #     // send response
        #     $this->response->send([
        #         'transaction' => $found->id,
        #         'cancel_time' => Format::datetime2timestamp($found->cancel_time),
        #         'state'       => $found->state,
        #     ]);
        # } else {
            # // todo: If cancelling after performing transaction is not possible, then return error -31007
        self.response.error(
                PayMeException.ERROR_COULD_NOT_CANCEL,
                'Could not cancel transaction. Order is delivered/Service is completed.'
            );
        
    def CancelTransaction(self):
    
        transaction = Transactions()

        found = transaction.find(self.request.params)
        if not found:
            self.response.error(PayMeException.ERROR_TRANSACTION_NOT_FOUND, 'Transaction not found.');
        
        switcher = {
            Transactions.STATE_CANCELLED: self.cancel(found),
            Transactions.STATE_CANCELLED_AFTER_COMPLETE: self.cancel(found),
            Transactions.STATE_CREATED : self.create_to_cancel(self,found),
            Transactions.STATE_COMPLETED : self.complete_to_cancel()
        }
        return switcher[found.state]
    

    def ChangePassword(self):
    
        # # // validate, password is specified, otherwise send error
        # if (!isset($this->request->params['password']) || !trim($this->request->params['password'])):
        #     $this->response->error(PaycomException::ERROR_INVALID_ACCOUNT, 'New password not specified.', 'password');
        
        # if ($this->merchant->config['password'] == $this->request->params['password']):

        self.response.error(PayMeException.ERROR_INSUFFICIENT_PRIVILEGE, 'Insufficient privilege. Incorrect new password.');
        

        # // todo: Implement saving password into data store or file
        # // example implementation, that saves new password into file specified in the configuration
        # if (!file_put_contents($this->config['keyFile'], $this->request->params['password'])) {
        #     $this->response->error(PaycomException::ERROR_INTERNAL_SYSTEM, 'Internal System Error.');
        # }

        # self.response.send({'success' :True});
    

    def GetStatement(self):
    
        if not 'from' in self.request.params:
            self.response.error(PayMeException.ERROR_INVALID_ACCOUNT, 'Incorrect period.', 'from');
        
        if not 'to' in self.request.params:
            self.response.error(PayMeException.ERROR_INVALID_ACCOUNT, 'Incorrect period.', 'to');
        

        if (1 * self.request.params['from'] >= 1 * self.request.params['to']):
            self.response.error(PayMeException.ERROR_INVALID_ACCOUNT, 'Incorrect period. (from >= to)', 'from');
        

        transaction  = Transactions();
        transactions = transaction.report(self.request.params['from'], self.request.params['to'])

        return self.response.send({'transactions' : transactions})
    
