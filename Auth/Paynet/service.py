from spyne.decorator import rpc

from spyne.model import primitive
from spyne.model.complex import ComplexModel
from spyne.model.primitive.string import Unicode
from spyne.service import Service, ServiceBase
from spyne.util.django import DjangoService
from .Validation import Validation
from Auth.models import Transaction, PaynetProPayment
from django.conf import settings
from .Response import Response
from .Exception import PaynetException
from django.db.models import Q
from Auth.Format import Format

class GenericArguments(Service):
    pass
class ProviderWebService(DjangoService):

    @rpc(_in_message_name='GetInformationRequest',_soap_body_style= "bare"  )
    def GetInformation(ctx):
        pass

    # @rpc(_in_message_name='PerformTransactionRequest')
    # def PerformTransaction(request):
    #     pass
    # @rpc(_in_message_name='CheckTransactionRequest')
    # def CheckTransaction(request):
    #     pass
    # @rpc(_in_message_name='CancelTransactionRequest')
    # def CancelTransaction(request):
    #     pass
    # @rpc(_in_message_name='GetStatementRequest')
    # def GetStatement(request):
    #     pass
        

class Application(DjangoService):
    PERFORM_TRANSACTION = "PerformTransactionResult"
    CHECK_TRANSACTION = "CheckTransactionResult"
    CANCEL_TRANSACTION = "CancelTransactionResult"
    GET_STATEMENT = "GetStatementResult"
    GET_INFORMATION = "GetInformationResult"

    def __init__(self, request):
        self.request = request.data

    def run(self):

        try:
            switch = {
                Application.PERFORM_TRANSACTION: self.perform_transaction,
                Application.CHECK_TRANSACTION: self.check_transaction,
                Application.CANCEL_TRANSACTION: self.cancel_transaction,
                Application.GET_STATEMENT: self.get_statement,
            }

            method = self.request['method']
            print(method)
            response = switch[method]()
            return response
        except PaynetException as e:
            return e.send()

    def perform_transaction(self):
        print("IT IS HERE")
        validation = Validation(self.request)
        valid_data = validation.validate_perform_transaction()
        customer = valid_data['customerId']
        trans = Transaction.objects.create(
            amount=valid_data['amount'],
            transactionId=valid_data['transactionId'],
            paid_time=valid_data['transactionTime'],
            state=1,
            customer=customer
        )
        trans.save()
        customer.user.balans = customer.user.balans + trans.amount
        customer.user.save()
        response = Response(valid_data['method'], 'ok', 0)
        response.add_body(key="providerTrnId", value=settings.PAYNET['providerId'])
        response.add_parameters(key="balance", value=customer.user.balans * 100)

        return response.send()

    def check_transaction(self):
        print("IS NOT HERE")
        validation = Validation(self.request)
        valid_data = validation.validate_check_transaction()
        print(valid_data)
        transaction = Transaction.objects.get(
            Q(transactionId=valid_data['transactionId']) & Q(paid_time=valid_data['transactionTime']))
        response = Response(valid_data['method'], 'ok', 10)
        response.add_body(key="providerTrnId", value=transaction.id)
        response.add_body(key="transactionState", value=transaction.state)
        response.add_body(key="transactionStateErrorStatus", value=0)
        response.add_body(key="transactionStateErrorMsg", value="Success")
        return response.send()

    def cancel_transaction(self):
        validation = Validation(self.request)
        valid_data = validation.validate_cancel_transaction()
        transaction = valid_data['transaction']
        transaction.customer.user.save()
        transaction.state = 2
        transaction.save()
        response = Response(valid_data['method'], 'ok', 0)
        response.add_body(key="transactionState", value=transaction.state)
        return response.send()

    @rpc(primitive.String,_args=['arguments'],_in_variable_names={'parameters': 'Log'},_returns=primitive.String)
    def GetInformation(self, request):
        ss = open("super.txt")
        ss.write(request)
        ss.close()
        validation = Validation(self.request)
        valid_data = validation.validate_get_information()
        customer = valid_data['customerId']
        response = Response(valid_data['method'], 'ok', 0)
        response.add_parameters(key="balance", value=customer.user.balans * 100)
        return response.send()

    def get_statement(self):
        validation = Validation(self.request)
        valid_data = validation.validate_get_statement()
        transaction = Transaction.objects.filter(
            Q(paid_time__gt=valid_data['dateFrom']) & Q(paid_time__lte=valid_data['dateTo']) & Q(state=1))
        response = Response(valid_data['method'], 'ok', 0)
        for trans in transaction:
            response.add_statements({
                "amount": trans.amount * 100,
                "providerTrnId": trans.id,
                "transactionId": trans.transactionId,
                "transactionTime": Format.datetime2str(trans.paid_time)
            })

        return response.send()
