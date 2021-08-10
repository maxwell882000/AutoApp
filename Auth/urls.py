from Auth.Paynet.CustomSoap.custom_soap import MySoap11
from django.urls import path

from Auth.views import *

from django.conf import settings
from django.conf.urls.static import static
from spyne.application import Application
from spyne.protocol.soap import Soap11
from spyne.server.django import DjangoView as RPCView

from .Paynet.service import ProviderWebService as pp

api = Application(services=[pp], tns='http://uws.provider.com/', name="ProviderWebService",
                  in_protocol=Soap11(validator='soft'), out_protocol=Soap11(), )
urlpatterns = [
                  path('login/', RegisterOrLoginUsersViews.as_view()),

                  path('register/', AccountRegister.as_view()),
                  path('transport/', TransportViews.as_view()),
                  path('transport/<pk>/', TransportViews.as_view()),
                  path('shareChoice/<pk>/', ChooseShareDetail.as_view()),
                  path('units/<pk>/', TransportUnits.as_view()),
                  path('loginFacebook/', loginFacebook),
                  path('loginGoogle/', loginGoogle),
                  path('authfacebook/', authFacebook, name='authfacebook'),
                  path('authgoogle/', authGoogle, name='authgoogle'),
                  path('marka/', MarkaRegisterViews.as_view()),
                  path('cards/', CardsViews.as_view()),
                  path('cards/<pk>/', CardsViews.as_view()),
                  path('cards/store/<pk>', CardsStoreView.as_view()),
                  path('download/<pk>/', DownloadImage.as_view()),
                  path('cards/images_upload', AttachedImageViews.as_view()),
                  path('cards/images_upload/<pk>/', AttachedImageViews.as_view()),
                  path('get_image/<pk>/', GetImage.as_view()),
                  path('expense/', ExpenseViews.as_view()),
                  path('expense/<pk>/', ExpenseViews.as_view()),
                  path('recomendations/', RecomendationViews.as_view()),
                  path('recomendations/<pk>/', RecomendationViews.as_view()),
                  path('recommendation_card/', RecomendationCardsView.as_view()),
                  path('updateExpenses/<pk>/', ExpensesViews.as_view()),
                  path('pay/payme', PaymeView.as_view()),
                  path('pay/click', ClickView.as_view()),
                  path('subscribe_pay/', SubscribeAPI.as_view()),
                  path('location/<pk>/', LocationGetViews.as_view()),
                  path('adds/<pk>/', AddsView.as_view()),
                  path('adds/', AddsView.as_view()),
                  path('paynet_pay/', PaynetView.as_view(), name='api'),
                  path("balance-data/", ProAccountView.as_view()),
                  path('clean/temp/<int:pk>', clean),
                  path('service/', AmountProAccountView.as_view()),
                  path('notification/', PushNotifications.as_view()),
                  path('term/', term)
                  # path('send_push/message',)
                  # path('get_phases/', get_phases)
                  # path ('aboverecomedation/')
              ] + static(settings.STATIC_URL, document_root=settings.STATIC_URL) + static(settings.MEDIA_URL,
                                                                                          document_root=settings.MEDIA_URL)
