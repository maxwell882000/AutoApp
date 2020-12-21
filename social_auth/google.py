from google.auth.transport import requests
from google.oauth2 import id_token

class Google:

    @staticmethod
    def validate(auth_token):

        try:
            print("NEWWW",auth_token)
            idinfo = id_token.verify_oauth2_token(
                auth_token, requests.Request()
            )
            print ('ASDASDAS', idinfo)

            if 'accounts.google.com' in idinfo['iss']:
                return idinfo
        except:
            return 'The token is either invalid or has expired'