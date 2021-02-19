from .Exception import PayMeException
from ..models import Orders
class Order():
    
    STATE_AVAILABLE = 0


    STATE_WAITING_PAY = 1

    STATE_PAY_ACCEPTED = 2

    STATE_CANCELLED = 3

    
    def __init__(self, request_id):
    
        self.request_id = request_id
        self.params =None

        self.id = None
        self.product_ids = None

        self.amount = None

        self.state = None

        self.user_id = None

        self.phone = None

    

    def validate(self, params):
    
        if not params['amount'].isnumeric():
            raise  PayMeException(
                self.request_id,
                'Incorrect amount.',
                PayMeException.ERROR_INVALID_AMOUNT
            );
        

        if (not 'account' in params  or not params['account']['order_id']):
            raise  PayMeException(
                self.request_id,
                PayMeException.message(
                    'Неверный код заказа.',
                    'Harid kodida xatolik.',
                    'Incorrect order code.'
                ),
                PayMeException.ERROR_INVALID_ACCOUNT,
                'order_id'
            );
        

        # // todo: Check is order available

        # // assume, after find() $this will be populated with Order data
        order = self.find(params['account'])

      
        if not order or not order.id:
            raise  PayMeException(
                self.request_id,
                PayMeException.message(
                    'Неверный код заказа.',
                    'Harid kodida xatolik.',
                    'Incorrect order code.'
                ),
                PayMeException.ERROR_INVALID_ACCOUNT,
                'order_id'
            );
        

        if ((100 * self.amount) != (1 * params['amount'])):
            raise  PayMeException(
                self.request_id,
                'Incorrect amount.',
                PayMeException.ERROR_INVALID_AMOUNT
            );
        

       
        if (self.state != Order.STATE_WAITING_PAY):
            raise  PayMeException(
                self.request_id,
                'Order state is invalid.',
                PayMeException.ERROR_COULD_NOT_PERFORM
            );
        

        self.params = params;

        return True;
    

    def find(self,params):

        if 'order_id' in params:
            obj = Orders.objects.filter(id = params['order_id'])
            return obj
        return None;
    

   
    def changeState(self,state):
        self.state = 1 * state;
        self.save();
    


    def allowCancel(self):
    
        # // todo: Implement order cancelling allowance check

        # // Example implementation
        # return False; // do not allow cancellation
        return False

 
    def save(self):
    
        
        obj = Orders.objects.get(id = self.id)
        if not obj.exists():

            # // If new order, set its state to waiting
            self.state = Order.STATE_WAITING_PAY;
            # implement id
            
            obj = Orders.objects.create(
                 product_ids =self.product_ids,
                 amount = self.amount,
                 state = self.state,
                 user_id = self.user_id,
                 phoneOrEmail = self.phone
            )
            obj.save()
        else:

            obj.state = self.state
            obj.save()
            

    
    
