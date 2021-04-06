from django.http import JsonResponse
from .Exception import PayMeException
class Response():

 
    def __init___(self,request):

        self.request = request
    
    def send(self, result, error = None):
    
        
        response = JsonResponse()
        response['jsonrpc'] = '2.0';
        response['id']      = self.request._id;
        response['result']  = result;
        response['error']   = error;
        return response;
 

    
    def error(self,code, message = None, data = None):
    
        raise  PayMeException(self.request._id, message, code, data);
    
