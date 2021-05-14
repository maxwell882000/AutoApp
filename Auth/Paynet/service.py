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
        file1 = open("myfile.txt", "w")
        file1.write(request)
        file1.close()
        return application.run()
