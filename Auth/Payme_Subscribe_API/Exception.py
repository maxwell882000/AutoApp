from re import M, U
from rest_framework.response import Response
from rest_framework import status
from Auth.models import PaymeProPayment


class PayMeException(Exception):
    ERROR_INCORRECT_TYPE_OF_AMOUNT = -11111
    ERROR_CREATE_CHECK = -22222
    ERROR_PAY_CHECK = -33333
    ERROR_INVALID_USER = -44444
    ERROR_REQUIRED_PARAMS = -66666

    error_message = {
        "incorrect_id": "Не правильный ID вернулся!",
        "incorrect_service": "Не правильный вид услуги был выбран!",
        "incorrect_user": "Нету разрешения для этого пользователя!",
        "required": "Необходимое поле пропущенно!",
    }

    def __init__(self, request_id, code, message):
        self.code = code
        self.request_id = request_id
        self.message = message

    def handleError(error, user=None, payer: PaymeProPayment = None):
        if user is not None:
            user.pro_account = False
            user.save()
        if payer is not None:
            payer.token = ""
            payer.save()
        return error.send()

    def send(self):
        response = {
            'id': self.request_id,
            'error': self.code,
            'message': self.message,
            'success': False
        }
        return Response(response, status=status.HTTP_400_BAD_REQUEST)
