from django.http import JsonResponse
class PayMeException(Exception):
    ERROR_INTERNAL_SYSTEM         = -32400
    ERROR_INSUFFICIENT_PRIVILEGE  = -32504
    ERROR_INVALID_JSON_RPC_OBJECT = -32600
    ERROR_METHOD_NOT_FOUND        = -32601
    ERROR_INVALID_AMOUNT          = -31001
    ERROR_TRANSACTION_NOT_FOUND   = -31003
    ERROR_INVALID_ACCOUNT         = -31050
    ERROR_COULD_NOT_CANCEL        = -31007
    ERROR_COULD_NOT_PERFORM       = -31008
    
    request_id = 0
    error = ""
    data = ""

    def __init__(self,request_id, message, code, data = None):
        self.request_id = request_id
        self.message    = message
        self.code       = code
        self.data       = data

        self.error = {'code':self.code}

        if (self.message):
            self.error['message'] = self.message

        if self.data:
            self.error['data'] = self.data
        
    

    def  send(self):
        response = {}
        response['id']     = self.request_id
        response['result'] = None
        response['error']  = self.error
        resp = JsonResponse(response)
        resp['header'] = 'Content-Type: application/json; charset=UTF-8'
        return resp
    

    def message(self, ru, uz = '', en = ''):
    
        return {'ru' : ru, 'uz': uz, 'en': en}
    