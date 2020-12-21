from django.urls import path
from django.conf.urls import url
from .views import (RegisterAccountUsersViews,AccountLogin ,
                    AccountGetCards,TransportViews,
                    loginFacebook , loginGoogle,
                    authFacebook, authGoogle)
from rest_framework_simplejwt import views as jwt_views

urlpatterns = [
    path('register/', RegisterAccountUsersViews.as_view()),
    path('login/', AccountLogin.as_view()),
    url('cards/', AccountGetCards.as_view()),
    path('transport/', TransportViews.as_view()),
    path('transport/<pk>/', TransportViews.as_view()),
    path('loginFacebook/', loginFacebook),
    path('loginGoogle/', loginGoogle),
    path('authfacebook/',authFacebook, name = 'authfacebook'),
    path('authgoogle/', authGoogle , name ='authgoogle'),

]
