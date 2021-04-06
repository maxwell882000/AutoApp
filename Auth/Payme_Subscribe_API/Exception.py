from rest_framework.response import Response
from rest_framework import status


class PayMeException(Exception):
    ERROR_INCORRECT_TYPE_OF_AMOUNT = -11111
    ERROR_CREATE_CHECK = -22222
    ERROR_PAY_CHECK = -33333

    def __init__(self, request_id, code, message):
        self.code = code
        self.request_id = request_id
        self.message = message

    def send(self):
        response = {
            'id': self.request_id,
            'error': self.code,
            'message': self.message,
            'success': False
        }
        return Response(response, status=status.HTTP_400_BAD_REQUEST)
