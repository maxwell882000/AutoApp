from django.shortcuts import render, redirect
from rest_framework import status
from django.http import HttpResponse
from django.core.files import File
from datetime import datetime,timezone
from rest_framework.decorators import api_view
from .models import (UserTransport, TransportDetail, 
                    SelectedUnits ,MarkaRegister, Attach,
                    ImagesForAttached,Card,
                    Cards,ModelRegister,
                    RecommendedChange,Expense,Expenses,ClickModel)
from .serializers import(AccountSerializer,SingleRecomendationSerializer,
                         AccountLogInSerializer,
                         AccountCardsSerializer,
                         TransportDetailSerializer,
                         TransportUnitsSerializer,
                         MarkaSerializer,CardSerializer,
                         AttachSerializer,ImagesForAttachedSerializer,
                         CardsSerializer,ExpenseSerializer,ChoiceSerializer)
from rest_framework.views import APIView
from rest_framework.response import Response
from authlib.integrations.django_client import OAuth, DjangoRemoteApp
from django.urls import reverse
from ._core import map_profile_fields
from rest_framework.parsers import MultiPartParser, FormParser ,FileUploadParser , JSONParser
from .renderers import JPEGRenderer,PNGRenderer
from django.conf import settings 
import time 
from django.http import JsonResponse
import base64
from .Payme.Application import Application
import time

from django.http import JsonResponse


# def api(request):
#     a = False
#     b = 1
#     while not a:
#         b+=1
#         if(b==10):
#             a =True
#         time.sleep(1)
#     payload = {"message": "Hello World!"}
#     if "task_id" in request.GET:
#         payload["task_id"] = request.GET["task_id"]
#     return JsonResponse(payload)


# def get_api_urls(num=10):
#     base_url = "http://127.0.0.1:8000/api/"
#     return [f"{base_url}?task_id={task_id}" for task_id in range(num)]


# async def api_aggregated(request):
#     s = time.perf_counter()
#     responses = []
#     urls = get_api_urls(num=1)
#     async with httpx.AsyncClient() as client:
#         responses = await asyncio.gather(*[client.get(url) for url in urls])
#         responses = [r.json() for r in responses]
#     elapsed = time.perf_counter() - s
#     result = {
#         "message": "Hello Async World!",
#         "responses": responses,
#         "debug_message": f"fetch executed in {elapsed:0.2f} seconds.",
#     }
#     return JsonResponse(result)


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
# import asyncio
# async def set_after(fut, delay, value):
#     # Sleep for *delay* seconds.
#     await asyncio.sleep(delay)

#     # Set *value* as a result of *fut* Future.
#     fut.set_result(value)

# async def main():
#     # Get the current event loop.
#     loop = asyncio.get_running_loop()

#     # Create a new Future object.
#     fut = loop.create_future()

#     # Run "set_after()" coroutine in a parallel Task.
#     # We are using the low-level "loop.create_task()" API here because
#     # we already have a reference to the event loop at hand.
#     # Otherwise we could have just used "asyncio.create_task()".
#     loop.create_task(
#         set_after(fut, 1, '... world'))

#     print('hello ...')

#     # Wait until *fut* has a result (1 second) and print it.
#     print(await fut)


class TransportUnits(APIView):
    
    def get(self, request ,*args, **kwargs):
        l = []
        l.append({
            'sss':'sss',
            'dss':'asdsad'
        })        
        return Response(l)
        
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
        
    def delete(self, request, pk , formate = None):
        user = UserTransport.objects.get(emailOrPhone = pk)
        try:
            user.units.delete()
            for cards in user.cards.all().cards_user.card.all():
                for card in cards.cards_user.card.all():
                    for instance in card.attach.image.all():
                        instance.delete()
                    for expense in card.expense.all():
                        expense.delete()
                    card.delete()
                cards.cards_user.delete()
            ser = CardsSerializer(user.cards.cards_user)
            user.cards.clear()
            user.cards.delete()
        except AttributeError:
            print("GOES SOMETHIN WRONG")
        user.delete()
        return Response({"status":200})

class ChooseShareDetail(APIView):
    
    def post(self, request, *args,**kwargs):
        data =   request.data
        user =   UserTransport.objects.get(emailOrPhone = kwargs['pk'])
        shared = UserTransport.objects.get(emailOrPhone = data['emailOrPhone'])
        detail = user.cards.get(id= data['id'])
        if not shared.pro_account:
            shared.cards.clear()
        shared.cards.add(detail)
        shared.last_account = detail.id
        shared.save()
        user.cards.remove(detail)
        user.save()
        return Response({"status":200})   

    def get(self, request, *args, **kwargs):
        user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
        serializer =  ChoiceSerializer(user.cards, many =True)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class RecomendationViews(APIView):

    def get(self ,request,*args, **kwargs):
        data = ModelRegister.objects.get(id = kwargs['pk'])
        f = open(data.image_above.path, 'rb')
        filename = data.image_above.name
        response = HttpResponse(f.read())
        response['Content-Disposition'] = "attachment; filename=%s" % filename
        return response

    def post(self, request, *args, **kwargs):
        data = request.data
        marka = MarkaRegister.objects.get(name_of_marka = data['name_of_marka'])
        model = marka.model.get(name_of_model = data['name_of_model'])
        serializer = SingleRecomendationSerializer(model.recomendations,many = True)
        return Response({'id_model': model.id, 'recomendations': serializer.data, 'text_above': model.text_above, 'image_name': model.image_above.name})

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
            return Response(serializer.data)
        else:
            print(request.query_params.get('id_cards'))
            print(kwargs)
            user = UserTransport.objects.get(emailOrPhone = kwargs['pk'])
            units = TransportUnitsSerializer(user.units)
            print(user.pro_account)
            response = {
                "pro_account": user.pro_account,
                "date": user.date ,
                "units":units.data,
                "cards": None,
            }
            if user.cards.first() != None:
                
                if user.pro_account and 'id_cards' in request.query_params:
                    index = request.query_params.get('id_cards')
                    user.last_account = index
                    user.save()
                else:
                    index = user.last_account
                cards = user.cards.get(id = index)
                now = datetime.now(timezone.utc)
                delta = now - user.date
                if delta.days > cards.expenses.update_month:
                    cards.expenses.in_this_month = 0
                    cards.expenses.update_month +=30
                    cards.expenses.save()
                detail = TransportDetailSerializer(cards)
                response['cards'] = detail.data
            return Response(response)
            
    def post(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        data = request.data
        if user.pro_account or user.cards.first() == None:
            if user.cards.filter(nameOfTransport = data['nameOfTransport']).exists():
                return Response({"error":"Это название уже существует"},status=status.HTTP_400_BAD_REQUEST)
            expenses = Expenses.objects.create()
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
                secondTankVolume = data['secondTankVolume'],
                run             = data['run'],
                initial_run      = data['run'],
                expenses = expenses
            )
            if 'tech_passport' in data:
                detail.tech_passport = data['tech_passport']
            user.cards.add(detail)
            user.last_account = detail.id
            user.save()
            return Response({"id":detail.id}, status = status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def put (self, request, pk, format =None):
        detail =  TransportDetail.objects.get(id = pk)
        data = request.data
        if 'run' in data:
            detail.run = data['run']
        if 'tech_passport' in data:
            detail.tech_passport = data['tech_passport']
        if 'nameOfTransport' in data:
            detail.nameOfTransport = data['nameOfTransport']
        if 'number' in data:
            detail.number = data['number']
        detail.save()
        serializer = TransportDetailSerializer(detail)
        return Response(serializer.data)

class AttachedImageViews(APIView):
    parser_classes = (MultiPartParser,FormParser)
    def get(self,request,pk,format = None):
    
        data = ImagesForAttached.objects.all()
        serializer = ImagesForAttachedSerializer(data , many = True)
        return Response(serializer.data)
    
    def post(self,request, format = None):
        data = request.data
        serializer = ImagesForAttachedSerializer(data = data)
        serializer.is_valid()
        serializer.save()
        return Response({'id':serializer.data.get('id')})
        
    def delete(self,request,pk,format = None):
        image = ImagesForAttached.objects.get(id = pk)
        image.delete()
        return Response({"status":200})


class ExpensesViews(APIView):
    def put(self, request, *args,**kwargs):
        data = request.data
        expenses = Expenses.objects.get(id = kwargs['pk'])
        expenses.all_time = data['all_time']
        expenses.in_this_month = data['in_this_month']
        expenses.save()
        return Response({"all": expenses.all_time, "month":expenses.in_this_month})
        
class ExpenseViews(APIView):
    def get(self,request,*args,**kwargs):
        expenses = Expense.objects.all()
        serializer = ExpenseSerializer(expenses,many = True)
        return Response(serializer.data)
    def post(self,request,*args,**kwargs):
        data = request.data
        serializer = ExpenseSerializer(data = data)
        serializer.is_valid()
        serializer.save()
        return Response({'id':serializer.data.get('id')})

    def put(self,request, *args,**kwargs):
        data = Expense.objects.get(id = kwargs['pk'])
        if 'name' in request.data:
            data.name = request.data['name']
        if 'sum' in request.data:
            data.sum = request.data['sum']
        if 'amount' in request.data:
            data.amount = request.data['amount']
        data.save()
        return Response({"data":"updated"})
        
    def delete(self,reuqest,pk,format = None):
        expense = Expense.objects.get(id = pk)
        expense.delete()
        return Response({"status":200})

class CardsViews(APIView):

    def get(self,request , *args, **kwargs):
        if not kwargs:
            data = Cards.objects.all()
            serializer = CardsSerializer(data , many= True)
            return Response(serializer.data)

        data = Cards.objects.get(id = kwargs['pk'])
        serializer = CardSerializer(data.card, many = True)
        return Response(serializer.data)


    def post(self, request,*args, **kwargs):
        array = []
        data = request.data 
        attach = Attach.objects.create()
        change = RecommendedChange.objects.create()
        
        if 'run' in data:
            change.run = data['run']
            change.initial_run = data['initial_run']
        else:
            change.time = data['time']
        change.save()
        if 'images_list' in data:
            for i in data['images_list']:
                array.append(ImagesForAttached.objects.get(id = int(i)))
            
            attach.image.set(array)
        if 'location' in data:
            attach.location = data['location']
        attach.save()
        card = Card.objects.create(
            name_of_card = data['name_of_card'],
            comments = data['comments'],
            date = data['date'],
            attach = attach,
            change = change
        )
        if 'pk' in kwargs:
            detail = TransportDetail.objects.get(id = kwargs['pk'])
            cards = Cards.objects.create()
            cards.card.add(card)
            cards.save()
            detail.cards_user = cards
            detail.save()
            #serializer = TransportDetailSerializer(detail)
            return Response({"id_cards":cards.id,"id_attach":attach.id,"id_change":change.id,"id_card":card.id})
        card.save()
        cards = Cards.objects.get(id = data['id'])
        cards.card.add(card)
        cards.save()
        # serializer = CardsSerializer(cards)
        return Response({"id_attach":attach.id,"id_change":change.id,"id_card":card.id})

    def put(self, request , pk, format = None):
        data = request.data
        card = Card.objects.get(id = pk)
        if 'id_attach' in data:
            attach = Attach.objects.get(id = data['id_attach'])
            if 'images_list' in data:
                for i in data['images_list']:
                    attach.image.add(ImagesForAttached.objects.get(id = int(i)))
            if 'location' in data:
                attach.location = data['location']
            attach.save()
        if 'name_of_card' in data:
            card.name_of_card = data['name_of_card']
        if 'comments' in data:
            card.comments = data['comments']
        if 'date' in data:
            card.date = data['date']
        change = RecommendedChange.objects.get( id = data['id_change'])
        if 'run' in data:
            change.initial_run = data['initial_run']
            change.run = data['run']
            change.time = 0
        else:
            change.run = 0
            change.time = data['time']
        change.save()
        if 'expense_list' in data:
            for i in data['expense_list']:
                card.expense.add(Expense.objects.get(id = int(i)))
        card.save()
        #serializer = CardSerializer(card)
        return Response({'status':200})
        
    def delete(self,request, pk, format = None):
        card = Card.objects.get(id = pk)
        try:
            for instance in card.attach.image.all():
                instance.delete()
            card.attach.delete()
        except AttributeError:
            print("Error")
        if hasattr(card.expense):
            for expense in card.expense.all():
                expense.delete()
            card.expense.delete()
        card.delete()
        return Response({"status":200})




class DownloadImage(APIView):
  # download from link 
    def get(self ,request,*args, **kwargs):
        data = ImagesForAttached.objects.get(id = kwargs['pk'])
        f = open(data.image.path, 'rb')
        filename = data.image.name
        response = HttpResponse(f.read())
        response['Content-Disposition'] = "attachment; filename=%s" % filename
        return response

class GetImage(APIView):
    renderer_classes = [JPEGRenderer]
    def get(self, request, *args,**kwargs):
        data = ImagesForAttached.objects.get(id = kwargs['pk']).image
        return Response(data, content_type='image/jpg')

class ClickView(APIView):
    def get(self,request,*args,**kwargs):
        redirection = ""
        return redirect(redirection)
    def post(self, request,*args,**kwargs):
        return redirect("")# redirect to complete 
class PaymeView(APIView):
    def get(self,request,*args,**kwargs):
        encoded = base64.b64encode("m={};a={};ac={}".format())
        return redirect("https://checkout.paycom.uz/{}".format())
        
class MerchantView(APIView):
    def post(self,request,*args,**kwargs):
        app = Application(request)
        return app.run()
# def get_phases(request):
#     project = request.POST.get('project')
#     print("Project : %s" % project)
#     phases = {}
#     try:
#         if project:
#             model = MarkaRegister.objects.get(pk=int(project)).model
#             phases = {pp.name_of_model:pp.pk for pp in model}
#     except:
#         pass
#     return Response(phases)