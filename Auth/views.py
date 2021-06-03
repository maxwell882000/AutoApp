from re import S
from django.shortcuts import redirect
from rest_framework import status
from django.http import HttpResponse

from datetime import datetime, timezone

from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from authlib.integrations.django_client import OAuth, DjangoRemoteApp
from django.urls import reverse
from ._core import map_profile_fields
from rest_framework.parsers import MultiPartParser, FormParser
from .renderers import JPEGRenderer, XmlRenderer
from .Payme_Subscribe_API.Application import Application as Payme_Application
from .Paynet.Application import Application as PaynetApplication

from .parser import ParserXML
import base64
from .Payme_Merchant_API.Application import Application

from django.core.exceptions import ObjectDoesNotExist

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

    redirection = "https://autoapp.page.link/?link=https://autoapp.page.link{}/{user_id}?emailOrPhone={}&apn=com.autoapp.application&amv=0&afl=google.com".format(
        direction, validation[0]['emailOrPhone'], user_id=validation[0]['user_id'])
    return redirect(redirection)


def logout(request):
    request.session.pop('user', None)
    return redirect('/')


class AmountProAccountView(APIView):

    def get(self, request, *args, **kwargs):
        service = AmountProAccount.objects.all()
        serializer = AmountProAccountSerializer(service, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class RegisterOrLoginUsersViews(APIView):

    def get(self, request, *args, **kwargs):
        user = UserTransport.objects.all()
        serializer = AccountSerializer(user, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        user = request.data
        user = AccountSerializer(user)
        valid = user.validate(user.data)
        return Response(valid, status=status.HTTP_200_OK)


class AccountRegister(APIView):
    def post(self, request, *args, **kwargs):
        user = request.data
        user = AccountSerializer(user)
        valid = user.validate_register(user.data)
        return Response(valid, status=status.HTTP_200_OK)


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

    def delete(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        user.delete()
        return Response({"status": 200}, status=status.HTTP_200_OK)


class ChooseShareDetail(APIView):

    def post(self, request, *args, **kwargs):
        data = request.data

        try:
            user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
            shared = UserTransport.objects.get(emailOrPhone=data['emailOrPhone'])
            detail = user.cards.get(id=data['id'])
            if not shared.pro_account:
                shared.cards.clear()
            shared.cards.add(detail)
            shared.last_account = detail.id
            shared.save()
            user.cards.remove(detail)
            user.save()
            user.last_account = user.cards.first().id
            user.save()
            return Response(status=status.HTTP_200_OK)
        except AttributeError:
            user.last_account = 0
            user.save()
            return Response(status=status.HTTP_400_BAD_REQUEST)
        except UserTransport.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def get(self, request, *args, **kwargs):
        user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
        serializer = ChoiceSerializer(user.cards, many=True)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class AddsView(APIView):
    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            data = Adds.objects.get(id=kwargs['pk'])
            filename = data.file.name
            response = HttpResponse(data.file.read())
            response['Content-Disposition'] = "attachment; filename=%s" % filename
            return response
        else:
            try:
                data = Adds.objects.first()
                response = {
                    "id": data.id,
                    "links": data.links
                }
                return Response(response, status=status.HTTP_200_OK)
            except AttributeError:
                return Response({"error": "no adds"}, status=status.HTTP_404_NOT_FOUND)


class RecomendationViews(APIView):

    def get(self, request, *args, **kwargs):
        data = ModelRegister.objects.get(id=kwargs['pk'])
        f = open(data.image_above.path, 'rb')
        filename = data.image_above.name
        response = HttpResponse(f.read())
        response['Content-Disposition'] = "attachment; filename=%s" % filename
        return response

    def post(self, request, *args, **kwargs):
        data = request.data
        model = get_model(data)
        serializer = SingleRecomendationSerializer(model.recomendations, many=True)
        return Response({'id_model': model.id, 'recomendations': serializer.data, 'text_above': model.text_above,
                         'image_name': model.image_above.name})


def get_model(data):
    marka = MarkaRegister.objects.get(name_of_marka=data['name_of_marka'])
    return marka.model.get(name_of_model=data['name_of_model'])


class RecomendationCardsView(APIView):
    def get(self, request, *args, **kwargs):
        model = get_model(request.data)
        serializer = RecommendCardsSerializer(model.recommend_card, many=True)
        return Response(serializer, status=status.HTTP_200_OK)


class MarkaRegisterViews(APIView):

    def get(self, request, *args, **kwargs):
        data = MarkaRegister.objects.all()
        serialized = MarkaSerializer(data, many=True)
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
            user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
            units = TransportUnitsSerializer(user.units)
            print(user.pro_account)
            response = {
                "pro_account": user.pro_account,
                "date": user.date,
                "user_id": user.id,
                "units": units.data,
                "cards": None,
            }
            if user.cards.first() != None:
                if user.pro_account and 'id_cards' in request.query_params:
                    index = request.query_params.get('id_cards')
                    user.last_account = index
                    user.save()
                else:
                    if user.last_account == 0:
                        index = user.cards.first().illd
                    else:
                        index = user.last_account
                cards = user.cards.get(id=index)
                now = datetime.now(timezone.utc)
                delta = now - user.date
                if delta.days > cards.expenses.update_month:
                    cards.expenses.in_this_month = 0
                    cards.expenses.update_month += 30
                    cards.expenses.save()
                detail = TransportDetailSerializer(cards)
                response['cards'] = detail.data
            return Response(response)

    def post(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        data = request.data
        if user.pro_account or user.cards.first() == None:
            if user.cards.filter(nameOfTransport=data['nameOfTransport']).exists():
                return Response({"error": "Это название уже существует"}, status=status.HTTP_400_BAD_REQUEST)
            expenses = Expenses.objects.create()
            cards_user = Cards.objects.create()
            detail = TransportDetail.objects.create(
                nameOfTransport=data['nameOfTransport'],
                marka=data['marka'],
                model=data['model'],
                yearOfMade=data['yearOfMade'],
                yearOfPurchase=data['yearOfPurchase'],
                number=data['number'],
                numberOfTank=data['numberOfTank'],
                firstTankType=data['firstTankType'],
                firstTankVolume=data['firstTankVolume'],
                secondTankType=data['secondTankType'],
                secondTankVolume=data['secondTankVolume'],
                run=data['run'],
                initial_run=data['run'],
                expenses=expenses,
                cards_user=cards_user
            )
            if 'tech_passport' in data:
                detail.tech_passport = data['tech_passport']
                detail.save()
            user.cards.add(detail)
            user.last_account = detail.id
            user.save()
            return Response({"id": detail.id}, status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk, format=None):
        detail = TransportDetail.objects.get(id=pk)
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
    parser_classes = (MultiPartParser, FormParser)

    def get(self, request, pk, format=None):
        data = ImagesForAttached.objects.all()
        serializer = ImagesForAttachedSerializer(data, many=True)
        return Response(serializer.data)

    ###################################################################################################################################
    def post(self, request, format=None):
        data = request.data
        serializer = ImagesForAttachedSerializer(data=data)
        serializer.is_valid()
        obj = serializer.save()
        temp_storage = Temporary.objects.get(user_id=int(data['user_id']))
        temp_storage.image.add(obj)

        return Response({'id': serializer.data.get('id')})

    def delete(self, request, pk, format=None):
        image = ImagesForAttached.objects.get(id=pk)
        image.delete()
        return Response({"status": 200})


class ExpensesViews(APIView):
    def put(self, request, *args, **kwargs):
        data = request.data
        expenses = Expenses.objects.get(id=kwargs['pk'])
        expenses.all_time = data['all_time']
        expenses.in_this_month = data['in_this_month']
        expenses.save()
        return Response({"all": expenses.all_time, "month": expenses.in_this_month})


class ExpenseViews(APIView):
    def get(self, request, *args, **kwargs):
        expenses = Expense.objects.all()
        serializer = ExpenseSerializer(expenses, many=True)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        data = request.data
        serializer = ExpenseSerializer(data=data)
        serializer.is_valid()
        obj = serializer.save()
        temp_storage = Temporary.objects.get(user_id=data['user_id'])
        temp_storage.expenses.add(obj)
        return Response({'id': serializer.data.get('id')}, status=status.HTTP_200_OK)

    def put(self, request, *args, **kwargs):
        data = Expense.objects.get(id=kwargs['pk'])
        if 'name' in request.data:
            data.name = request.data['name']
        if 'sum' in request.data:
            data.sum = request.data['sum']
        if 'amount' in request.data:
            data.amount = request.data['amount']
        data.save()
        return Response({"data": "updated"}, status=status.HTTP_200_OK)

    def delete(self, reuqest, pk, format=None):
        expense = Expense.objects.get(id=pk)
        expense.delete()
        return Response({"status": 200}, status=status.HTTP_200_OK)


class LocationGetViews(APIView):
    def get(self, request, *args, **kwargs):
        location = Location.objects.get(id=kwargs['pk'])
        serializer = LocationSerializer(location)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CardsStoreView(APIView):
    def get(self, request, *args, **kwargs):
        data = Cards.objects.get(id=kwargs['pk'])
        serializers = CardSerializer(data.storeCard, many=True)
        return Response(serializers.data)


class CardsViews(APIView):

    def get(self, request, *args, **kwargs):
        if not kwargs:
            data = Cards.objects.all()
            serializer = CardsSerializer(data, many=True)
            return Response(serializer.data)

        data = Cards.objects.get(id=kwargs['pk'])
        serializer = CardSerializer(data.card, many=True)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        array = []
        data = request.data
        attach = Attach.objects.create()
        change = RecommendedChange.objects.create()
        location = Location.objects.create()

        if 'run' in data:
            change.run = data['run']
            change.initial_run = data['initial_run']
            change.time = 0
        else:
            change.run = 0
            change.time = data['time']
        change.save()
        temp = Temporary.objects.get(user_id=data['user_id'])
        attach.image.set(temp.image.all())
        temp.image.clear()
        temp.save()

        if 'location' in data:
            location.latitude = data['location']['latitude']
            location.longitude = data['location']['longitude']
            location.comment = data['location']['comment']
        location.save()
        attach.location = location
        attach.save()
        card = Card.objects.create(
            name_of_card=data['name_of_card'],
            comments=data['comments'],
            date=data['date'],
            attach=attach,
            change=change
        )
        if 'pk' in kwargs:
            detail = TransportDetail.objects.get(id=kwargs['pk'])
            cards = Cards.objects.create()
            cards.card.add(card)
            cards.save()
            detail.cards_user = cards
            detail.save()
            # serializer = TransportDetailSerializer(detail)
            return Response(
                {"id_cards": cards.id, "id_attach": attach.id, "id_change": change.id, "id_card": card.id,
                 "id_location": location.id}, status=status.HTTP_200_OK)
        card.save()
        cards = Cards.objects.get(id=data['id'])
        cards.card.add(card)
        cards.save()

        # serializer = CardsSerializer(cards)
        return Response(
            {"id_attach": attach.id, "id_change": change.id, "id_card": card.id, "id_location": location.id},
            status=status.HTTP_200_OK)

    def put(self, request, pk, format=None):
        data = request.data
        card = Card.objects.get(id=pk)
        temp = Temporary.objects.get(user_id=data['user_id'])
        if 'id_attach' in data:
            attach = Attach.objects.get(id=data['id_attach'])
            attach.image.set(temp.image.all())
            if 'location' in data:
                attach.location.latitude = data['location']['latitude']
                attach.location.longitude = data['location']['longitude']
                attach.location.comment = data['location']['comment']
                attach.location.save()
            attach.save()
        if 'name_of_card' in data:
            card.name_of_card = data['name_of_card']
        if 'comments' in data:
            card.comments = data['comments']
        if 'date' in data:
            card.date = data['date']
        if 'id_change' in data:
            change = RecommendedChange.objects.get(id=data['id_change'])
            if 'run' in data:
                change.initial_run = data['initial_run']
                change.run = data['run']
                change.time = 0
            else:
                change.run = 0
                change.time = data['time']
            change.save()
        card.expense.set(temp.expenses.all())
        card.save()
        temp.clean_operation()
        # serializer = CardSerializer(card)
        return Response({}, status=status.HTTP_200_OK)

    def delete(self, request, pk, format=None):
        id_cards = request.query_params.get('id_cards')
        card = Card.objects.get(id=pk)
        cards = Cards.objects.get(id=id_cards)
        detail = TransportDetail.objects.get(cards_user_id=cards.id)
        card.change.run = detail.run
        card.change.save()
        card.save()
        cards.storeCard.add(card)
        cards.card.remove(card)

        return Response({"status": 200}, status=status.HTTP_200_OK)


class DownloadImage(APIView):
    # download from link
    def get(self, request, *args, **kwargs):
        data = ImagesForAttached.objects.get(id=kwargs['pk'])
        f = open(data.image.path, 'rb')
        filename = data.image.name
        response = HttpResponse(f.read())
        response['Content-Disposition'] = "attachment; filename=%s" % filename
        return response


class GetImage(APIView):
    renderer_classes = [JPEGRenderer]

    def get(self, request, *args, **kwargs):
        data = ImagesForAttached.objects.get(id=kwargs['pk']).image
        return Response(data, content_type='image/jpg')


class ClickView(APIView):
    def get(self, request, *args, **kwargs):
        redirection = ""
        return redirect(redirection)

    def post(self, request, *args, **kwargs):
        return redirect("")  # redirect to complete


class PaymeView(APIView):
    def get(self, request, *args, **kwargs):
        encoded = base64.b64encode("m={};a={};ac={}".format())
        return redirect("https://checkout.paycom.uz/{}".format())


class SubscribeAPI(APIView):
    def post(self, request, *args, **kwargs):
        app = Payme_Application(request)
        return app.run()


from Auth.Paynet.Response import Response as response
import zeep
from AutoApp import settings

from django.http import FileResponse


class PaynetView(APIView):
    parser_classes = (ParserXML,)

    # renderer_classes = (XmlRenderer,)

    def post(self, request, *args, **kwargs):
        media = settings.MEDIA_ROOT
        response = FileResponse(open("{}\\ProviderWebService.wsdl".format(media), 'rb'), content_type="text/xml")
        # content = "attachment; filename=%s" % filename
        # response['Content-Disposition'] = content
        return response
        # application = PaynetApplication(request)
        # return application.run()

    def get(self, request, *args, **kwargs):
        media = settings.MEDIA_ROOT
        response = FileResponse(open("{}\\ProviderWebService.wsdl".format(media), 'rb'), content_type="text/xml")
        # content = "attachment; filename=%s" % filename
        # response['Content-Disposition'] = content
        return response

        # ss = open(,"r")
        # application = PaynetApplication(request)
        # return Response(ss.read(), content_type=)


from fcm_django.models import FCMDevice


def send_push(request):
    device = FCMDevice.objects.first()
    device.send_message()


def clean(request, pk=None):
    try:
        temp = Temporary.objects.get(user_id=pk)
        temp.delete_operation()
        return Response({}, status=status.HTTP_200_OK)
    except Temporary.DoesNotExist:
        return Response({}, status=status.HTTP_404_NOT_FOUND)
