from .Exception import PaynetException
from django.conf import settings
from Auth.models import AmountProAccount, PaynetProPayment, Transaction
from Auth.Format import Format


class Validation:

    def __init__(self, dictionary):
        self.dictionary = dictionary

    def validate_perform_transaction(self):
        method = self.dictionary['method']
        try:
            self.__validate(method)
            self.__validate_sum(method)
            self.__validate_transaction_perform(method)
            self.__validate_customerId(method)
            self.__validate_transactionTime(method)
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)
        return self.dictionary

    def validate_check_transaction(self):
        method = self.dictionary['method']
        try:
            self.__validate(method)
            self.__validate_transaction_check(method)
            self.__validate_transactionTime(method)
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)

    def validate_cancel_transaction(self):
        method = self.dictionary['method']
        try:
            self.__validate(method)
            self.__validate_transaction_check(method)
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)

    def validate_get_statement(self):
        method = self.dictionary['method']
        try:
            self.__validate(method)
            self.__validate_customerId(method)
            self.dictionary['onlyTransactionId'] = True if self.dictionary['onlyTransactionId'] == 'true' else False
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)

    def validate_get_information(self):
        method = self.dictionary['method']
        try:
            self.__validate(method)
            self.__validate_from_to_date(method)
            self.dictionary['onlyTransactionId'] = True if self.dictionary['onlyTransactionId'] == 'true' else False
        except KeyError:
            raise PaynetException(PaynetException.ERROR_REQUIRED_PARAM_NOT_SET,
                                  PaynetException.dict[PaynetException.ERROR_REQUIRED_PARAM_NOT_SET], method)
    def __validate_from_to_date(self, method):

        try:
            from_date = self.dictionary['dateFrom']
            to_date = self.dictionary['dateTo']
            self.dictionary['dateFrom'] = Format.str2datetime(from_date)
            self.dictionary['dateTo'] = Format.str2datetime(to_date)
        except ValueError:
            raise PaynetException(PaynetException.ERROR_WRONG_DATE,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_DATE], method)

    def __validate_transaction_perform(self, method):

        self.dictionary['transactionId'] = int(self.dictionary['transactionId'])
        if Transaction.objects.filter(transactionId=self.dictionary['transactionId']).exists():
            raise PaynetException(PaynetException.ERROR_TRANS_ALREADY_EXISTS,
                                  PaynetException.dict[PaynetException.ERROR_TRANS_ALREADY_EXISTS], method)

    def __validate_transaction_check(self, method):
        self.dictionary['transactionId'] = int(self.dictionary['transactionId'])
        if not Transaction.objects.filter(transactionId=self.dictionary['transactionId']).exists():
            raise PaynetException(PaynetException.ERROR_CLIENT_NOT_FOUND,
                                  PaynetException.dict[PaynetException.ERROR_CLIENT_NOT_FOUND], method)

    def __validate_sum(self, method):
        try:
            self.dictionary['amount'] = int(self.dictionary['amount']) / 100
        except ValueError:
            raise PaynetException(PaynetException.ERROR_WRONG_SUM,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_SUM], method)

    def __validate_customerId(self, method):
        customer_query = PaynetProPayment.objects.filter(customerId=self.dictionary['customerId'])
        if not customer_query.exists():
            raise PaynetException(PaynetException.ERROR_CLIENT_NOT_FOUND,
                                  PaynetException.dict[PaynetException.ERROR_CLIENT_NOT_FOUND], method)
        else:
            self.dictionary['customerId'] = customer_query.first()

    def __validate_transactionTime(self, method):
        try:
            self.dictionary['transactionTime'] = Format.str2datetime(self.dictionary['transactionTime'])
        except ValueError:
            raise PaynetException(PaynetException.ERROR_WRONG_DATE,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_DATE], method)

    def __validate(self, method):
        username = self.dictionary['username']
        password = self.dictionary['password']
        PAYNET = settings.PAYNET
        if password != PAYNET['password'] or username != PAYNET['username']:
            raise PaynetException(PaynetException.ERROR_WRONG_LOGIN,
                                  PaynetException.dict[PaynetException.ERROR_WRONG_LOGIN], method)

        if self.dictionary['serviceId'] != PAYNET['serviceId']:
            raise PaynetException(PaynetException.ERROR_SERVICE_NOT_FOUND,
                                  PaynetException.dict[PaynetException.ERROR_SERVICE_NOT_FOUND], method)
