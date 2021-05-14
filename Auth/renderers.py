from rest_framework import renderers
from io import StringIO

from django.utils.encoding import force_str
from django.utils.xmlutils import SimplerXMLGenerator


class JPEGRenderer(renderers.BaseRenderer):
    media_type = 'image/jpeg'
    format = 'jpg'
    charset = None
    render_style = 'binary'

    def render(self, data, media_type=None, renderer_context=None):
        return data


class PNGRenderer(renderers.BaseRenderer):
    media_type = 'image/png'
    format = 'png'
    charset = None
    render_style = 'binary'

    def render(self, data, media_type=None, renderer_context=None):
        return data


class XmlRenderer(renderers.BaseRenderer):
    """
    Renderer which serializes to XML.
    """

    media_type = "application/soap+xml"
    format = "xml"
    charset = "utf-8"
    item_tag_name = "list-item"
    root_tag_name = "s:Envelope"
    second_tag_name = "s:Body"
    third_tag_name = "uws:{method}"

    def render(self, data, accepted_media_type=None, renderer_context=None):
        """
        Renders `data` into serialized XML.
        """
        if data is None:
            return ""

        stream = StringIO()

        xml = SimplerXMLGenerator(stream, self.charset)
        xml.startDocument()
        xml.startElement(self.root_tag_name, {"xmlns:s": "http://schemas.xmlsoap.org/soap/envelope/"})
        xml.startElement(self.second_tag_name, {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd": "http://www.w3.org/2001/XMLSchema"})
        xml.startElement(self.third_tag_name.format(method=data['method']), {"xmlns:uws": "http://uws.provider.com/"})
        self._to_xml(xml, data['body'])
        for params in data['parameters']:
            self._to_xml(xml, {
                "parameters": {
                    "paramKey": params[0],
                    "paramValue": params[1],
                },
            })
        for statements in data['statements']:
            self._to_xml(xml, {
                "statements": statements,
            })
        xml.endElement(self.third_tag_name.format(method=data['method']))
        xml.endElement(self.second_tag_name)
        xml.endElement(self.root_tag_name)
        xml.endDocument()
        return stream.getvalue()

    def _to_xml(self, xml, data):
        if isinstance(data, (list, tuple)):
            for item in data:
                xml.startElement(self.item_tag_name, {})
                self._to_xml(xml, item)
                xml.endElement(self.item_tag_name)

        elif isinstance(data, dict):
            for key, value in data.items():
                xml.startElement(key, {})
                self._to_xml(xml, value)
                xml.endElement(key)

        elif data is None:
            # Don't output any value
            pass

        else:
            xml.characters(force_str(data))
