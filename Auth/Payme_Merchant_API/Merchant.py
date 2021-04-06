import base64
import re
from django.conf import settings
from .Exception import PayMeException
class Merchant:
    def __init__(self):
        self.config = settings.PAYME


    def Authorize(self,request,request_id):

        headers = request.headers
        print("Headers {}".format(headers))
                         #possible errors
        if(not headers or not 'Authorization' in headers):
            matches = re.search('/^\s*Basic\s+(\S+)\s*$/i', headers['Authorization'])
            if(not matches or base64.b64decode(matches[1]) != "{login}:{key}".format(login = self.config['login'], key = self.config['password'])):

                raise PayMeException(
                    request_id,
                    'Insufficient privilege to perform this method.',
                    PayMeException.ERROR_INSUFFICIENT_PRIVILEGE
                )
        

        return True
