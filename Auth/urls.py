from django.urls import path
from django.conf.urls import url
from .views import (RegisterOrLoginUsersViews,
                    TransportViews,AccountRegister,
                    loginFacebook, loginGoogle,
                    authFacebook, authGoogle, TransportUnits)
from rest_framework_simplejwt import views as jwt_views

urlpatterns = [
    path('login/', RegisterOrLoginUsersViews.as_view()),
    path('register/', AccountRegister.as_view()),
    path('transport/', TransportViews.as_view()),
    path('transport/<pk>/', TransportViews.as_view()),
    path('units/<pk>/', TransportUnits.as_view()),
    path('loginFacebook/', loginFacebook),
    path('loginGoogle/', loginGoogle),
    path('authfacebook/', authFacebook, name='authfacebook'),
    path('authgoogle/', authGoogle, name='authgoogle'),

]
