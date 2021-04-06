from lxml import etree

from io import  BytesIO


class Request:

    def __init__(self, request):
        self.content = request

    def parse(self):
        get = BytesIO(self.content.encode('utf-8'))
        context = etree.iterparse(get, events=('end',))
        dictionary = {}
        key_param = ""
        for a, e in context:
            if e.tag == 'paramKey':
                key_param = e.text
            elif e.tag == 'paramValue':
                dictionary[key_param] = e.text
            else:
                dictionary[e.tag] = e.text
            if e.tag[0:26] == '{http://uws.provider.com/}':
                dictionary["method"] = e.tag[26:-9] + "Result"
        return dictionary


print(Request("""
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
 <soapenv:Body>
 <ns1:ChangePasswordArguments xmlns:ns1="http://uws.provider.com/"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns1:
ChangePasswordArguments">
 <password>pwd</password>
 <username>user</username>
 <newPassword>newpassword</newPassword>
 </ns1:ChangePasswordArguments>
 </soapenv:Body>
</soapenv:Envelope>
""").parse())
