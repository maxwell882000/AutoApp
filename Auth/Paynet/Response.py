from Auth.Format import Format
from rest_framework.response import Response as Res


class Response:

    def __init__(self, method, message, code, response):
        self.method = method
        self.code = code
        self.message = message
        self.response = response

    def send(self):
        response = """
                   <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
                       <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                               xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                           <uws:{method} xmlns:uws="http://uws.provider.com/">
                                   <errorMsg>{message}</errorMsg>
                                   <status>{code}</status>
                                   <timeStamp>{timeStamp}</timeStamp>
                                   {response}    
                           </uws:{method}>
                       </s:Body>
                   </s:Envelope>
               """.format(method=self.method,
                          code=self.code,
                          message=self.message,
                          timeStamp=Format.current_time(),
                          response=self.response)

        return Res("asd", content_type="application/soap+xml")
