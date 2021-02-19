from ..models import Transactions
from .Exception import PayMeException
from .Format import Format
class Transaction():
    TIMEOUT = 43200000;

    STATE_CREATED                  = 1;
    STATE_COMPLETED                = 2;
    STATE_CANCELLED                = -1;
    STATE_CANCELLED_AFTER_COMPLETE = -2;

    REASON_RECEIVERS_NOT_FOUND         = 1;
    REASON_PROCESSING_EXECUTION_FAILED = 2;
    REASON_EXECUTION_FAILED            = 3;
    REASON_CANCELLED_BY_TIMEOUT        = 4;
    REASON_FUND_RETURNED               = 5;
    REASON_UNKNOWN                     = 10;
    def __init__(self):
        paycom_transaction_id = None
        paycom_time = None
        paycom_time_datetime = None
        id = None
        create_time = None
        perform_time = None
        cancel_time = None
        state = None
        reason = None
        amount = None
        receivers = None
        order_id = None
 

    def save(self):
        if not Transactions.objects.filter(id= self.id).exists():
            self.create_time = Format.timestamp2datetime(Format.timestamp());
            
            is_succes   =  Transactions.objects.create(
                                    paycom_transaction_id = self.paycom_transaction_id,
                                    paycom_time = self.paycom_time,
                                    paycom_time_datetime = self.paycom_time_datetime,
                                    create_time = self.create_time,
                                    amount = 1 * self.amount,
                                    state = self.state,
                                    receivers = self.receivers,
                                    order_id = 1 * self.order_id 
                                    )
            is_succes.save()
            self.id = is_succes.id
            return is_succes
        else:
            obj = Transactions.objects.get(id= self.id)
      
            if (self.amount):
                obj.amount = 1 *self.amount;

            obj.perform_time = self.perform_time if self.perform_time else None
            obj.cancel_time  = self.cancel_time if self.cancel_time else None
            obj.reason       = self.reason if 1 * self.reason else None
            obj.paycom_transaction_id  = self.paycom_transaction_id
            obj.state        = self.state
            obj.save()
 
    def cancel(self,reason):
    
        if self.state ==Transaction.STATE_COMPLETED:
            self.state = Transaction.STATE_CANCELLED_AFTER_COMPLETE
        else:
           
            self.state = Transaction.STATE_CANCELLED
        
        self.reason = reason

        self.save();

    
    def isExpired(self):
    
        # // todo: Implement transaction expiration check
        # // for example, if transaction is active and passed TIMEOUT milliseconds after its creation, then it is expired
        return self.state == Transaction.STATE_CREATED and abs(Format.datetime2timestamp(self.create_time) - Format.timestamp(True)) > Transaction.TIMEOUT;
    

  
    def find(self,params):
    
        if 'id' in params:
            is_success = Transactions.objects.filter(paycom_transaction_id = params['id'])
        elif 'account' in params and 'order_id' in params['account']:
            is_success = Transactions.objects.filter( order_id = params['account']['order_id'])
        else:
            raise  PayMeException(
                params['request_id'],
                'Parameter to find a transaction is not specified.',
                PayMeException.ERROR_INTERNAL_SYSTEM)
        
        

        if is_success:

            row = is_success

            if row:

                self.id                      =  row['id']
                self.paycom_transaction_id   =  row['paycom_transaction_id']
                self.paycom_time           = 1 * row['paycom_time']
                self.paycom_time_datetime  = row['paycom_time_datetime']
                self.create_time           = row['create_time']
                self.perform_time          = row['perform_time']
                self.cancel_time           = row['cancel_time']
                self.state                 = 1 *row['state']
                self.reason                = row['reason'] if 1 * row['reason'] else None
                self.amount                = 1 * row['amount']
                self.receivers             = row['receivers'] 
                self.order_id              = 1 * row['order_id']

                return self;

        return None;

    
    def report(self,from_date, to_date):
 
        from_date = Format.timestamp2datetime(from_date)
        to_date   = Format.timestamp2datetime(to_date)
        obj = Transactions.objects.filter(paycom_time_gt =from_date, paycom_time_lt =to_date).order_by('paycom_time_datetime')

        rows = []
        for row in obj:
            result = {
                'id'           : row['paycom_transaction_id'],
                'time'         : 1 * row['paycom_time'], 
                'amount'       : 1 * row['amount'],
                'account'      : {
                    'order_id' : 1 * row['order_id'], 
                    
                } ,
                'create_time'  : Format.datetime2timestamp(row['create_time']),
                'perform_time' : Format.datetime2timestamp(row['perform_time']),
                'cancel_time'  : Format.datetime2timestamp(row['cancel_time']),
                'transaction'  : 1 * row['id'],
                'state'        : 1 * row['state'],
                'reason'       : 'reason' in row if 1 * row['reason'] else None,
                'receivers'    : ['receivers'],
                }
            rows.append(result)
            
        

        return rows;

    
