from .Request import Request
from .Validation import Validation
from Auth.models import Transaction, PaynetProPayment
from django.conf import settings
from .Response import Response


class Application:
    PERFORM_TRANSACTION = "PerformTransactionResult"
    CHECK_TRANSACTION = "CheckTransactionResult"
    CANCEL_TRANSACTION = "CancelTransactionResult"
    GET_STATEMENT = "GetStatementResult"
    GET_INFORMATION = "GetInformationResult"

    def __init__(self, request):
        self.request = Request(request).parse()

    def run(self):
        switch = {
            Application.PERFORM_TRANSACTION: self.perform_transaction(),
            Application.CHECK_TRANSACTION: self.check_transaction(),
            Application.CANCEL_TRANSACTION: self.cancel_transaction(),
            Application.GET_INFORMATION: self.get_information(),
            Application.GET_STATEMENT: self.get_statement(),
        }
        return switch[self.request['method']]

    def perform_transaction(self):
        validation = Validation(self.request)
        valid_date = validation.validate_perform_transaction()
        customer = valid_date['customerId']
        trans = Transaction.objects.create(
            amount=valid_date['amount'],
            transactionId=valid_date['transactionId'],
            paid_time=valid_date['transactionTime']
        )
        trans.save()
        customer.check_get.add(trans)
        customer.save()
        customer.user.balans += trans.amount
        customer.user.save()
        provider_id = """
        <parameters>
             <paramKey>balance</paramKey>
             <paramValue>{balance}</paramValue>
        </parameters>
        <providerTrnId>{providerId}</providerTrnId>
        """.format(
            providerId=settings.PAYNET['providerId'],
            balance=customer.user.balans
        )
        response = Response(valid_date['method'], 'ok', 0, provider_id)
        return response.send()

        def check_transaction(self):
            validation = Validation(self.request)

        def cancel_transaction(self):
            validation = Validation(self.request)

        def get_information(self):
            validation = Validation(self.request)

        def get_statement(self):
            validation = Validation(self.request)
