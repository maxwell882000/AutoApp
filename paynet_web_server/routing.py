from django.urls import re_path

from . import consumers

websocket_urlpatterns = [
    re_path(r'ws/paynet_pay/$', consumers.PaynetServer.as_asgi()),
]
