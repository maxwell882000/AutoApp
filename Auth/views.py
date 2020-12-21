from django.shortcuts import render,redirect
from rest_framework import status
from .models import UserTransport ,TransportDetail
from .serializers import(AccountSerializer ,
                         AccountLogInSerializer,
                        AccountCardsSerializer,
                         TransportDetailSerializer)
from rest_framework.views import APIView
from rest_framework.response import Response 
from authlib.integrations.django_client import OAuth, DjangoRemoteApp
from django.urls import reverse
from ._core import map_profile_fields

USERINFO_FIELDS = [ 'id', 'name', 'first_name', 'middle_name', 'last_name', 'email', 'website', 'gender', 'locale']

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
    overwrite= True,
    fetch_token = lambda request: getattr(request, token_name,None),
    client_cls = RemoteApp,
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
    print (profile)
    return redirect("http://127.0.0.1:8000/")

def loginGoogle(request):
    redirect_uri = request.build_absolute_uri(reverse('authgoogle'))
    return oauth.google.authorize_redirect(request, redirect_uri)


def authGoogle(request):
    token = oauth.google.authorize_access_token(request)
    user = oauth.google.parse_id_token(request, token)
    request.session['user'] = user
    print (user.email)
    return redirect("http://127.0.0.1:8000/social_auth/google")

def logout(request):
    request.session.pop('user', None)
    return redirect('/')

class RegisterAccountUsersViews(APIView):

    def get(self, request, *args, **kwargs):
        user = UserTransport.objects.all()
        serializer = AccountSerializer(user, many = True)
        return Response(serializer.data)
        

    def post(self, request, *args, **kwargs ):
        user = request.data
        user = AccountSerializer(data = user)
        user.is_valid(raise_exception = True)
        return Response(user.validated_data)

class AccountLogin(APIView):
   
    
    def post(self, request, *args , **kwargs):
        user = request.data
        obj = UserTransport.objects.get(emailOrPhone= user['emailOrPhone'])
        return Response({"id":obj.id})
    
    def put(self,request,pk=None):
        # user = UserTransport.objects.get(id = request.data['id'])
        # data = request.data
        # print(user.phone)
        # print(data['marka'])
        # detail = TransportDetail.objects.create(
        #     nameOfTransport = data['nameOfTransport'],
        #     marka           = data['marka'],
        #     model           = data['model'],
        #     yearOfMade      = data['yearOfMade'],
        #     yearOfPurchase  = data['yearOfPurchase'], 
        #     kilometerPetrol = data['kilometerPetrol'],
        #     numberPetrol    = data['numberPetrol'],
        #     kilometerGas    = data['kilometerGas'],
        #     numberGas       = data['numberGas'],   
        #     )
        # user.cards = detail
        # user.save()
        # print(user.cards.marka)
        # serializer = TransportDetailSerializer(user.cards)
        # print(serializer.data)
        # # serializerTransport = TransportDetailSerializer(data = data)
        # # print(serializerTransport.data)
        # # if serializerTransport.is_valid()
        # #     serializerTransport.save()
        #     # return Response(serializerTransport.data)
        return Response({"sadsad":"Sadsads"})

class AccountGetCards(APIView):
    def get(self,request, *args, **kwargs):
        obj = UserTransport.objects.filter(provider = "phone")
        print (obj)
        serializer = AccountCardsSerializer(obj, many =True)

        return Response(serializer.data)
    def post (self, request , *args,**kwargs):
        obj = request.data
        print(obj)
        serializer = AccountSerializer(obj)
        print(serializer.data)
        here=serializer.validate(serializer.data)
        # serializer.is_valid(raise_exception=True)
        # here=serializer.validate(serializer.data)
        # print (here)
        return Response(here)

class TransportViews(APIView):
    def get (self, request,*args,**kwargs):
        if not kwargs:
            user = UserTransport.objects.all()
            serializer = AccountCardsSerializer(user , many =True)
        else:
            user = UserTransport.objects.get(emailOrPhone = kwargs['pk'])
            serializer = AccountCardsSerializer(user)
        return Response(serializer.data)

    def put(self,request,pk,format = None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        data = request.data
        serializer = TransportDetailSerializer(data = data)
        serializer.is_valid()
        print(serializer.validated_data)
        data = serializer.validated_data
        detail = TransportDetail.objects.create(
            nameOfTransport = data['nameOfTransport'],
            marka           = data['marka'],
            model           = data['model'],
            yearOfMade      = data['yearOfMade'],
            yearOfPurchase  = data['yearOfPurchase'], 
            kilometerPetrol = data['kilometerPetrol'],
            numberPetrol    = data['numberPetrol'],
            kilometerGas    = data['kilometerGas'],
            numberGas       = data['numberGas'],   
            )
        user.cards = detail
        print (user)
        user.save()
        userSerializer = AccountCardsSerializer(user)
        return Response(userSerializer.data)
