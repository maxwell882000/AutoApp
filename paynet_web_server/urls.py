from django.urls import path, include
from paynet_web_server.consumers import PaynetServer

urlpatterns = [
    path('payner_web_server/', PaynetServer.as_asgi()),
    # path('social_auth/', include('social_auth.urls')),
]
