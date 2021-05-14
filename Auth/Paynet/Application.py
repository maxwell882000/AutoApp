from .Request import Request
from .Validation import Validation
from Auth.models import Transaction, PaynetProPayment
from django.conf import settings
from .Response import Response
from .Exception import PaynetException
from django.db.models import Q
from Auth.Format import Format


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
        try:
            response = switch[self.request['method']]
            return response
        except PaynetException as e:
            return e.send()

    def perform_transaction(self):
        validation = Validation(self.request)
        valid_data = validation.validate_perform_transaction()
        customer = valid_data['customerId']
        trans = Transaction.objects.create(
            amount=valid_data['amount']*100,
            transactionId=valid_data['transactionId'],
            paid_time=valid_data['transactionTime'],
            state=1
        )
        trans.customer = customer
        trans.save()
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
            balance=customer.user.balans*100
        )
        response = Response(valid_data['method'], 'ok', 0, provider_id)
        return response.send()

    def check_transaction(self):
        validation = Validation(self.request)
        valid_data = validation.validate_check_transaction()
        transaction = Transaction.objects.get(
            Q(transactionId=valid_data['transactionId']) & Q(paid_time=valid_data['transactionTime']))
        transaction_response = """
               <providerTrnId>{id}</providerTrnId>
               <transactionState>{state}</transactionState>
               <transactionStateErrorStatus>0</transactionStateErrorStatus>
               <transactionStateErrorMsg>Success</transactionStateErrorMsg>
               """.format(
            id=transaction.id,
            state=transaction.state
        )
        response = Response(valid_data['method'], 'ok', 10, transaction_response)
        return response.send()

    def cancel_transaction(self):
        validation = Validation(self.request)
        valid_data = validation.validate_cancel_transaction()
        transaction = Transaction.objects.get(transactionId=valid_data['transactionId'])
        transaction.customer.user.balans -= transaction.amount
        transaction.customer.user.save()
        transaction.state = 2
        transaction.save()
        cancel_response = "<transactionState>{state}</transactionState>".format(state=transaction.state)
        response = Response(valid_data['method'], 'ok', 0, cancel_response)
        return response.send()

    def get_information(self):
        file1 = open("myfile.txt", "w")
        file1.write('response gotted')
        file1.close()
        validation = Validation(self.request)
        valid_data = validation.validate_get_information()
        customer = valid_data['customerId']
        response_information = """
                <parameters>
                     <paramKey>balance</paramKey>
                     <paramValue>{balance}</paramValue>
                </parameters>
        """.format(balance=customer.user.balans*100)
        response = Response(valid_data['method'], 'ok', 0, response_information)
        return response.send()

    def get_statement(self):
        validation = Validation(self.request)
        valid_data = validation.validate_get_statement()
        transaction = Transaction.objects.filter(
            Q(paid_time__gt=valid_data['dateFrom']) & Q(paid_time__lte=valid_data['dateTo']))
        statement = ""
        for trans in transaction:
            statement += """
            
                    <statements>
                        <amount>{amount}</amount>
                        <providerTrnId>{id}</providerTrnId>
                        <transactionId>{transactionId}</transactionId>
                        <transactionTime>{paidTime}</transactionTime>
                    </statements>
                    
            """.format(
                id=trans.id,
                amount=trans.amount*100,
                transactionId=trans.transactionId,
                paidTime=Format.datetime2str(trans.paid_time)
            )
        response = Response(valid_data['method'], 'ok', 0, statement)
        return response.send()
