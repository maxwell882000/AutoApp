from re import S
from django.shortcuts import redirect
from rest_framework import status
from django.http import HttpResponse, FileResponse

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
from fcm_django.models import FCMDevice, AbstractFCMDevice
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
        service = AmountProAccount.objects.filter(type=request.query_params['type'])
        serializer = AmountProAccountSerializer(service, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        data = request.data
        account = UserTransport.objects.get(id=data['user_id'])
        amount = AmountProAccount.objects.get(id=data['amount_id'])
        if account.balans >= amount.price:
            account.pro_account = True
            account.duration += amount.duration
            account.balans -= amount.price
            account.save()
            return Response({}, status=status.HTTP_200_OK)
        else:
            return Response({}, status=status.HTTP_401_UNAUTHORIZED)


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
        print("SELECT DATA")
        print(data)
        units = SelectedUnits.objects.create(
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
            if not shared.pro_account and shared.cards.first() != None:
                return Response(status=status.HTTP_403_FORBIDDEN)
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
            user = UserTransport.objects.get(emailOrPhone=kwargs['pk'])
            if user.units is None:
                user.units = SelectedUnits.objects.create()
            units = TransportUnitsSerializer(user.units)
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

    def add_default_cards(self, detail: TransportDetail):
        model = ModelRegister.objects.get(name_of_model=detail.model)
        try:
            for card in model.recommend_card.all():
                print("TYPE CAR")
                print(card.type_car == 0 or detail.type_car == card.type_car)
                if card.type_car == 0 or detail.type_car == card.type_car:
                    attach = Attach.objects.create()
                    new_card = Card.objects.create(
                        name_of_card=card.name,
                        change=RecommendedChange.objects.create(
                            initial_run=detail.run,
                            run=card.select_recommend_run(detail.run)
                        ),
                        comments="",
                        attach=attach,
                        date=datetime.now()
                    )
                    detail.cards_user.card.add(new_card)
                    detail.cards_user.save()
                    detail.save()
        except AttributeError:
            pass

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
                type_car=data['type_car'],
                cards_user=cards_user
            )
            if 'tech_passport' in data:
                detail.tech_passport = data['tech_passport']
                detail.save()
            self.add_default_cards(detail)
            user.cards.add(detail)
            user.last_account = detail.id
            user.save()
            return Response({"id": detail.id, 'id_cards': detail.cards_user.id, 'id_expenses': expenses.id},
                            status=status.HTTP_200_OK)
        else:
            return Response({}, status=status.HTTP_403_FORBIDDEN)

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

    def delete(self, request, pk, format=None):
        user = UserTransport.objects.get(emailOrPhone=pk)
        detail = user.cards.get(id=request.query_params['id_transport'])
        user.cards.remove(detail)
        detail.delete()
        if user.cards.exists():
            return Response({}, status=status.HTTP_200_OK)
        else:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)


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
        try:
            data = Cards.objects.get(id=kwargs['pk'])
            serializers = CardSerializer(data.storeCard, many=True)
            return Response(serializers.data, status=status.HTTP_200_OK)
        except (ValueError, Cards.DoesNotExist):
            return Response({}, status=status.HTTP_404_NOT_FOUND)


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
        comments = ""
        if 'comments' in data:
            comments = data['comments']
        card = Card.objects.create(
            name_of_card=data['name_of_card'],
            comments=comments,
            date=data['date'],
            attach=attach,
            change=change
        )

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
            attach.image.add(*temp.image.all())
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
        card.expense.add(*temp.expenses.all())
        card.save()
        temp.clean_operation()
        return Response({}, status=status.HTTP_200_OK)

    def delete(self, request, pk, format=None):
        id_cards = request.query_params.get('id_cards')
        card = Card.objects.get(id=pk)
        cards = Cards.objects.get(id=id_cards)
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


class PaynetView(APIView):
    parser_classes = (ParserXML,)

    renderer_classes = (XmlRenderer,)

    def post(self, request, *args, **kwargs):
        result = PaynetApplication(request=request)
        return result.run()


class ProAccountView(APIView):
    def get(self, request, *args, **kwargs):
        data = PaynetProPayment.objects.get(user_id=request.query_params['user_id'])
        return Response({'balance': data.user.balans, 'customerId': data.customerId}, status=status.HTTP_200_OK)


class PushNotifications(APIView):
    def post(self, request, *args, **kwargs):
        data = request.data
        user = UserTransport.objects.get(id=data['id'])
        device_id = id(datetime.now().timestamp())
        FCMDevice.objects.create(
            name=user.emailOrPhone,
            user=user,
            device_id=device_id,
            registration_id=data['token'],
            type=AbstractFCMDevice.DEVICE_TYPES[0][0] if data['type'] == 0 else AbstractFCMDevice.DEVICE_TYPES[1][0]
        )
        return Response({
            'device_id': device_id,
        }, status=status.HTTP_200_OK)

    def delete(self, request, *args, **kwargs):
        data = FCMDevice.objects.filter(user_id=request.query_params['user_id'],
                                        device_id=request.query_params['device_id']).first()
        data.delete()
        return Response({}, status=status.HTTP_200_OK)


def clean(request, pk=None):
    try:
        temp = Temporary.objects.get(user_id=pk)
        temp.delete_operation()
        return Response({}, status=status.HTTP_200_OK)
    except Temporary.DoesNotExist:
        return Response({}, status=status.HTTP_404_NOT_FOUND)
