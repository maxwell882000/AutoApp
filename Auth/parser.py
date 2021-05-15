"""
Provides XML parsing support.
"""
import datetime
import decimal

from django.conf import settings
from rest_framework.exceptions import ParseError
from rest_framework.parsers import BaseParser

from lxml import etree


class ParserXML(BaseParser):
    """
    XML parser.
    """

    media_type = "application/xml"

    def parse(self, stream, media_type=None, parser_context=None):
        """
        Parses the incoming bytestream as XML and returns the resulting data.
        """
        print("STREAM TYPE")
        print(type(stream))
        context = etree.iterparse(stream, events=('end',))
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

    def _xml_convert(self, element):
        """
        convert the xml `element` into the corresponding python object
        """

        children = list(element)

        if len(children) == 0:
            return self._type_convert(element.text)
        else:
            # if the fist child tag is list-item means all children are list-item
            if children[0].tag == "list-item":
                data = []
                for child in children:
                    data.append(self._xml_convert(child))
            else:
                data = {}
                for child in children:
                    data[child.tag] = self._xml_convert(child)

            return data

    def _type_convert(self, value):
        """
        Converts the value returned by the XMl parse into the equivalent
        Python type
        """
        if value is None:
            return value

        try:
            return datetime.datetime.strptime(value, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            pass

        try:
            return int(value)
        except ValueError:
            pass

        try:
            return decimal.Decimal(value)
        except decimal.InvalidOperation:
            pass

        return value
