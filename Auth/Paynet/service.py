from spyne.decorator import rpc
from .Application import Application
from spyne.model import primitive
from spyne.util.django import DjangoService


class PaynetService(DjangoService):
    """Todo list RPC service."""

    @rpc(primitive.String, _returns=primitive.String)
    def paynet_view(ctx, request):
        print("sdasdsadadad")
        print(request)
        application = Application(request)

        return application.run()
