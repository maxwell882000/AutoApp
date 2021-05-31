from .Exception import PayMeException
from Auth.models import UserTransport, PaymeProPayment, AmountProAccount


class Validation:
    def __init__(self, response, payer):
        self._response = response
        self._id = response['id']
        self._hashed_id = response['result']['receipt']['_id']
        self._payer = payer

    def validate_create_check(self):
        self.__validate(error_code=PayMeException.ERROR_CREATE_CHECK)
        if self._id == self._payer.id:
            result = {
                'id': self._id,
                'id_params': self._hashed_id,
            }
            return result
        raise PayMeException(request_id=self._payer.id, code=PayMeException.ERROR_CREATE_CHECK,
                             message=PayMeException.error_message['incorrect_id'])

    def validate_pay(self):
        self.__validate(error_code=PayMeException.ERROR_PAY_CHECK)
        if self._hashed_id == self._response['result']['receipt']['_id']:
            return True
        raise PayMeException(request_id=self._payer.id, code=PayMeException.ERROR_PAY_CHECK,
                             message=PayMeException.error_message['incorrect_id'])

    def set_response(self, response):
        self._response = response

    def __validate(self, error_code):
        error = {
            'error': self._response['result']['receipt']['error'],
            'description': self._response['result']['receipt']['description'],
        }
        if error is not None:
            raise PayMeException(request_id=self._payer.id, code=error_code,
                                 message=error['description'])

    @staticmethod
    def validate_amount(id_amount, id_user):
        amount = AmountProAccount.objects.filter(id=id_amount).first()
        if amount is None:
            raise PayMeException(request_id=id_user, code=PayMeException.ERROR_INCORRECT_TYPE_OF_AMOUNT,
                                 message =PayMeException.error_message['incorrect_service'] )
        return amount
