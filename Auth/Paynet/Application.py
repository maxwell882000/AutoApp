from .Request import Request
from .Validation import Validation
from Auth.models import Transaction, PaynetProPayment
from django.conf import settings
from .Response import Response
from .Exception import PaynetException
from django.db.models import Q
from Auth.Format import Format


class Application:

    def __init__(self, request):
        request_process = Request(request.body)
        self.request = request_process.parse()
        print(self.request)

    def run(self):
        switch = {
            Request.PERFORM_TRANSACTION: self.perform_transaction,
            Request.CHECK_TRANSACTION: self.check_transaction,
            Request.CANCEL_TRANSACTION: self.cancel_transaction,
            Request.GET_INFORMATION: self.get_information,
            Request.GET_STATEMENT: self.get_statement,
        }

        method = self.request['method']
        print(method)
        response = switch[method]()
        return response

    def perform_transaction(self):
        try:
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
            response = Response(valid_data['method'], 'Success', 0)
            response.add_body(key="providerTrnId", value=trans.providerTrnId)
            # response.add_parameters(key="balance", value=customer.user.balans * 100)

        except PaynetException as e:
            response = e.send()
            response.add_body(key="providerTrnId", value=settings.PAYNET['providerId'])
        return response.send()

    def check_transaction(self):
        try:
            validation = Validation(self.request)
            valid_data = validation.validate_check_transaction()
            print(valid_data)
            transaction = Transaction.objects.get(
                Q(transactionId=valid_data['transactionId']) & Q(paid_time=valid_data['transactionTime']))
            response = Response(valid_data['method'], 'Success', 0)
            response.add_body(key="providerTrnId", value=transaction.providerTrnId)
            response.add_body(key="transactionState", value=transaction.state)
            response.add_body(key="transactionStateErrorStatus", value=0)
            response.add_body(key="transactionStateErrorMsg", value="Success")
        except PaynetException as e:
            response = e.send()
            response.add_body(key="providerTrnId", value=settings.PAYNET['providerId'])
            response.add_body(key="transactionState", value=settings.PAYNET['state'])
            response.add_body(key="transactionStateErrorStatus", value=1)
            response.add_body(key="transactionStateErrorMsg", value="ERROR")
        return response.send()

    def cancel_transaction(self):
        try:
            validation = Validation(self.request)
            valid_data = validation.validate_cancel_transaction()
            transaction = valid_data['transaction']
            transaction.customer.user.save()
            transaction.state = settings.PAYNET['state']
            transaction.save()
            response = Response(valid_data['method'], 'Success', 0)
            response.add_body(key="transactionState", value=transaction.state)
        except PaynetException as e:
            response = e.send()
            response.add_body(key="transactionState", value=-1)
        return response.send()

    def get_information(self):
        try:
            validation = Validation(self.request)
            valid_data = validation.validate_get_information()
            customer = valid_data['customerId']
            response = Response(valid_data['method'], 'ok', 0)
            response.add_parameters(key="balance", value=customer.user.balans * 100)
        except PaynetException as e:
            response = e.send()
        return response.send()

    def get_statement(self):
        try:
            validation = Validation(self.request)
            valid_data = validation.validate_get_statement()

            transaction = Transaction.objects.filter(
                Q(paid_time__gt=valid_data['dateFrom']) & Q(paid_time__lte=valid_data['dateTo']) & Q(state=1))
            response = Response(valid_data['method'], 'ok', 0)
            print(transaction.all())
            for trans in transaction.all():
                print("RETURN DATE")
                print(Format.datetime2str(trans.paid_time))
                response.add_statements({
                    "amount": trans.amount * 100,
                    "providerTrnId": trans.providerTrnId,
                    "transactionId": trans.transactionId,
                    "transactionTime": Format.datetime2str(trans.paid_time)
                })
        except PaynetException as e:
            response = e.send()

        return response.send()
