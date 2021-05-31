from .Requests import Requests
from Auth.models import UserTransport, PaymeProPayment, AmountProAccount
from .Validation import Validation
from .Exception import PayMeException
from rest_framework.response import Response
from rest_framework import status
from django.utils.datastructures import MultiValueDictKeyError

class Application:

    def __init__(self, request):
        self.request = request.data

    def run(self):
        id_user= 0
        user = None
        payer = None
        try:
            id_user = self.request['id_user']
            user = UserTransport.objects.get(id=id_user)
            payer = PaymeProPayment.objects.create(
                id=id(self),
                token=self.request['token'],
                user=user,
            )
            payer.save()
            data = Requests(payer=payer)
            validated_amount = Validation. \
                validate_amount(id_amount=self.request['id_amount'],
                                id_user=user.id)
            payer.amount = validated_amount
            payer.save()
            self.__pay(data=data, payer=payer)
            message = Response({
                'success': True,
                'id': user.id,
                'error': 0,
                'message': ""
            },
                status=status.HTTP_200_OK
            )
        except PayMeException as e_payme:        
            message = PayMeException.handleError(e_payme, user, payer)
        except UserTransport.DoesNotExist:
            e_payme = PayMeException(request_id=id_user,code=PayMeException.ERROR_INVALID_USER,message=PayMeException.error_message['incorrect_user'])
            message =  PayMeException.handleError(e_payme)
        except (IndexError, 	MultiValueDictKeyError):
            e_payme = PayMeException(request_id=id_user, code=PayMeException.ERROR_REQUIRED_PARAMS,message=PayMeException.error_message['required'])
            message = PayMeException.handleError(e_payme, user, payer)
        return message

    def __pay(self, data, payer):
        created = data.receipts_create(amount=payer.amount)
        validation = Validation(response=created, payer=payer)
        validated_create = validation.validate_create_check()
        pay = data.receipts_pay(validated_create)
        validation.set_response(pay)
        if validation.validate_pay():
            payer.user.pro_account = True
            payer.user.duration += payer.amount.duration
            payer.save()
            payer.user.save()

    def background_run(self):
        payers = PaymeProPayment.objects.filter(user__duration=1).all()
        for payer in payers:
            data = Requests(payer=payer)
            try:
                self.__pay(data=data, payer=payer)
            except PayMeException as e_payme:
                payer.user.pro_account = False
                payer.delete()
