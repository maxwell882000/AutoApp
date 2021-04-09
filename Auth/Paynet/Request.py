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



