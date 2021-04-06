from .Exception import PaynetException
from django.conf import settings
from Auth.models import AmountProAccount, PaynetProPayment
from Auth.Format import Format


class Validation:

    def __init__(self, dictionary):
        self.dictionary = dictionary

    def validate_perform_transaction(self):
        method = self.dictionary['method']
        try:
            self.validate()
            try:
                self.dictionary['amount'] = int(self.dictionary['amount']) / 100
            except ValueError:
                raise PaynetException(PaynetException.ERROR_WRONG_SUM,
                                      PaynetException.dict[PaynetException.ERROR_WRONG_SUM], method)
            self.dictionary['transactionId'] = int(self.dictionary['transactionId'])
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)
        return self.dictionary

    def validate(self):
        username = self.dictionary['username']
        password = self.dictionary['password']
        method = self.dictionary['method']
        PAYNET = settings.PAYNET
        if password != PAYNET['password'] or username != PAYNET['username']:
            raise PaynetException(PaynetException.ERROR_WRONG_LOGIN,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_LOGIN], method)

        if self.dictionary['serviceId'] != PAYNET['serviceId']:
            raise PaynetException(PaynetException.ERROR_SERVICE_NOT_FOUND,
                                  PaynetException.dict[PaynetException.ERROR_SERVICE_NOT_FOUND], method)
        customer_query = PaynetProPayment.objects.filter(customerId=self.dictionary['customerId'])
        if not customer_query.exists():
            raise PaynetException(PaynetException.ERROR_CLIENT_NOT_FOUND,
                                  PaynetException.dict[PaynetException.ERROR_CLIENT_NOT_FOUND], method)
        else:
            self.dictionary['customerId'] = customer_query.first()
        try:
            self.dictionary['transactionTime'] = Format.str2datetime(self.dictionary['transactionTime'])
        except ValueError:
            raise PaynetException(PaynetException.ERROR_WRONG_DATE,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_DATE], method)
