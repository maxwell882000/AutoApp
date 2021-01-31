from django.shortcuts import render, redirect
from rest_framework import status
from .models import UserTransport, TransportDetail, SelectedUnits ,MarkaRegister
from .serializers import(AccountSerializer,
                         AccountLogInSerializer,
                         AccountCardsSerializer,
                         TransportDetailSerializer,
                         TransportUnitsSerializer,
                         MarkaSerializer)
from rest_framework.views import APIView
from rest_framework.response import Response
from authlib.integrations.django_client import OAuth, DjangoRemoteApp
from django.urls import reverse
from ._core import map_profile_fields

USERINFO_FIELDS = ['id', 'name', 'first_name', 'middle_name',
                   'last_name', 'email', 'website', 'gender', 'locale']

token_name = '_loginpass_{}_token'.format('facebook')

USERINFO_ENDPOINT = 'me?fields=' + ','.join(USERINFO_FIELDS)


def normalize_userinfo(client, data):
    return map_profile_fields(data, {
        'sub': lambda o: str(o['id']),
        'name': 'name',
        'given_name': 'first_name',
        'family_name': 'last_name',
        'middle_name': 'middle_name',
        'email': 'email',
        'website': 'website',
        'gender': 'gender',
        'locale': 'locale'
    })


OAUTH_CONFIG = {
    'api_base_url': 'https://graph.facebook.com/v7.0/',
    'access_token_url': 'https://graph.facebook.com/v7.0/oauth/access_token',
    'authorize_url': 'https://www.facebook.com/v7.0/dialog/oauth',
    'client_kwargs': {'scope': 'email public_profile'},
    'userinfo_endpoint': USERINFO_ENDPOINT,
    'userinfo_compliance_fix': normalize_userinfo,
}


class RemoteApp(DjangoRemoteApp):
    OAUTH_APP_CONFIG = OAUTH_CONFIG
# facebook_oauth = OAuth()
# facebook_oauth.register(
#     name='facebook',
#     fetch_token = lambda request: getattr(request, token_name,None),
#     client_cls = RemoteApp,
# )


CONF_URL = 'https://accounts.google.com/.well-known/openid-configuration'
oauth = OAuth()
oauth.register(
    name='google',
    server_metadata_url=CONF_URL,
    client_kwargs={
        'scope': 'openid email profile'
    }
)

oauth.register(
    name='facebook',
    overwrite=True,
    fetch_token=lambda request: getattr(request, token_name, None),
    client_cls=RemoteApp,
)


def loginFacebook(request):
    facebook = oauth.create_client('facebook')
    redirect_uri = request.build_absolute_uri(reverse('authfacebook'))
    return facebook.authorize_redirect(request, redirect_uri)


def authFacebook(request):
    facebook = oauth.create_client('facebook')
    token = facebook.authorize_access_token(request)
    resp = facebook.get('account/verify_credentials.json')
    profile = resp.json()
    print(profile)
    return redirect("http://127.0.0.1:8000/")


def loginGoogle(request):
    redirect_uri = request.build_absolute_uri(reverse('authgoogle'))
    return oauth.google.authorize_redirect(request, redirect_uri)


def authGoogle(request):
    token = oauth.google.authorize_access_token(request)
    user = oauth.google.parse_id_token(request, token)
    request.session['user'] = user
    account = {
        'emailOrPhone': user['email'],
        'provider': 'google',
    }
    account_user = AccountSerializer(account)
    validation = account_user.validate(account_user.data)
    direction = "/select_unit"
    if validation[0]['status'] == 1:
        direction = "/authorized"
    print("{} + {}".format(validation,direction))
    redirection = "https://autoapp.page.link/?link=https://autoapp.page.link{}?emailOrPhone={}&apn=com.autoapp.application&amv=0&afl=google.com".format(direction,validation[0]['emailOrPhone'])
    return redirect(redirection)


def logout(request):
    request.session.pop('user', None)
    return redirect('/')


class RegisterOrLoginUsersViews(APIView):

    def get(self, request, *args, **kwargs):
        user = UserTransport.objects.all()
        serializer = AccountSerializer(user, many=True)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        user = request.data
        user = AccountSerializer(user)
        valid = user.validate(user.data)
        return Response(valid)


class AccountRegister(APIView):
    def post(self, request, *args, **kwargs):
        user = request.data
        user = AccountSerializer(user)
        valid = user.validate_register(user.data)
        return Response(valid)


class TransportUnits(APIView):
    def put(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        data = request.data

        serializer = TransportUnitsSerializer(data=data)
        serializer.is_valid()
        data = serializer.validated_data
        units = SelectedUnits.objects.create(
            speedUnit=data['speedUnit'],
            distanseUnit=data['distanseUnit'],
            fuelConsumption=data['fuelConsumption'],
            volume=data['volume'],
        )
        user.units = units
        user.save()
        return Response(data)

class MarkaRegisterViews(APIView):
    def get(self,request,*args,**kwargs):
        data = MarkaRegister.objects.all()
        serialized = MarkaSerializer(data , many =True)
        return Response(serialized.data)

class TransportViews(APIView):
    def get(self, request, *args, **kwargs):
        if not kwargs:
            user = UserTransport.objects.all()
            serializer = AccountCardsSerializer(user, many=True)
        else:
            print(kwargs)
            user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
            print(user)
            serializer = AccountCardsSerializer(user)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        data = request.data
        serializer = TransportDetailSerializer(data=data)
        serializer.is_valid()
        data = serializer.validated_data
        detail = TransportDetail.objects.create(
            nameOfTransport=data['nameOfTransport'],
            marka=data['marka'],
            model=data['model'],
            yearOfMade=data['yearOfMade'],
            yearOfPurchase=data['yearOfPurchase'],
            number = data['number'],
            numberOfTank=data['numberOfTank'],
            firstTankType=data['firstTankType'],
            firstTankVolume=data['firstTankVolume'],
            secondTankType=data['secondTankType'],
            secondTankVolume = data['secondTankVolume']
        )

        user.cards.add(detail)
        print(user)
        user.save()
        return Response(data)
