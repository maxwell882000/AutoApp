from django.urls import re_path

from . import consumers

websocket_urlpatterns = [
    re_path(r'paynet/server/$', consumers.PaynetServer.as_asgi()),
]
