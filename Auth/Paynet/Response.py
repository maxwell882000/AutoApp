from Auth.Format import Format
from rest_framework.response import Response as _response
from django.http.response import HttpResponse


class Response:

    def __init__(self, method, response, message="Ok", code=0):
        self.method = method
        self.code = code
        self.message = message
        self.response = response
        self.dictionary = {'method': self.method,
                           "body": {'errorMsg': self.message,
                                    'status': self.code,
                                    'timeStamp': Format.current_time(),
                                    'transactionTime': Format.current_time(),
                                    },
                           }
        self.parameters = []
        self.statements = []

    def add_body(self, key, value):
        self.dictionary['body']['key'] = value

    def add_parameters(self, key, value):
        self.parameters.append([key, value])

    def add_statements(self, dictionary):
        self.statements.append(dictionary)

    def send(self):
        self.dictionary['parameters'] = self.parameters
        self.dictionary['statements'] = self.statements
        return _response(self.dictionary, content_type="text/soap+xml")
        # response = """
        #                     <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
        #                                <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        #                                        xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        #                                    <uws:{method} xmlns:uws="http://uws.provider.com/">
        #                                            <errorMsg>{message}</errorMsg>
        #                                            <status>{code}</status>
        #                                            <timeStamp>{timeStamp}</timeStamp>
        #                                            {response}
        #                                    </uws:{method}>
        #                                </s:Body>
        #                            </s:Envelope>
        #                        """.format(method="GetStatementResponse",
        #                                   code="0",
        #                                   message="Asdsa",
        #                                   timeStamp="ASdasd",
        #                                   response="ASDa").replace("\n", "")
