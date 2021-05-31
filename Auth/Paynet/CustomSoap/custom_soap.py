from rest_framework import status
from spyne.protocol.soap import Soap11
from spyne.protocol.xml import XmlDocument


class MySoap11(Soap11):

  def decompose_incoming_envelope(self, ctx, message=XmlDocument.REQUEST):
      res = super(MySoap11, self).decompose_incoming_envelope(ctx, message)
      method = ctx.transport.req['HTTP_SOAPACTION']
      method = method.replace('"', '')
      ctx.method_request_string = method
      return res
