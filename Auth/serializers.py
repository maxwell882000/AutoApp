from .models import *
from rest_framework import serializers, status
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed


class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ("__all__")


class RecommendCardsSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecommendCards
        fields = ("__all__")


class ExpensesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Expenses
        fields = ("__all__")


class ExpenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Expense
        fields = ("__all__")


class CardsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cards
        fields = ('__all__')
        depth = 1


class ImagesForAttachedSerializer(serializers.ModelSerializer):
    class Meta:
        model = ImagesForAttached
        fields = ('__all__')


class AttachSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attach
        fields = ('__all__')


class CardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Card
        fields = ('__all__')
        depth = 1


class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ['id', 'emailOrPhone', 'provider']

    def create_account(self, emailOrPhone, provider):
        newAccount = UserTransport.objects.create(
            emailOrPhone=emailOrPhone,
            provider=provider,
        )
        newAccount.save()
        temp = Temporary.objects.create(user=newAccount)
        paynet = PaynetProPayment.objects.create(user=newAccount)
        paynet.save()
        temp.save()
        return newAccount

    def validate(self, attrs):
        emailOrPhone = attrs.get('emailOrPhone')
        provider = attrs.get('provider')
        accounts = UserTransport.objects.all()
        if accounts.filter(emailOrPhone=emailOrPhone).exists():
            prov = accounts.get(emailOrPhone=emailOrPhone)
            return ({
                        "emailOrPhone": prov.emailOrPhone,
                        "status": 1,
                        "user_id": prov.id,
                    }, status.HTTP_200_OK)
        else:
            if provider == 'phone' or provider == 'email':
                return ({
                            "error ": "Account not created"
                        }, status.HTTP_400_BAD_REQUEST)
            else:
                newAccount = self.create_account(emailOrPhone=emailOrPhone, provider=provider)
        return ({

                
                    "emailOrPhone": newAccount.emailOrPhone,
                    "status": 0,
                    "user_id": newAccount.id,
                }, status.HTTP_200_OK)

    def validate_register(self, attrs):
        emailOrPhone = attrs.get('emailOrPhone')
        provider = attrs.get('provider')
        accounts = UserTransport.objects.all()
        if accounts.filter(emailOrPhone=emailOrPhone).exists():
            return ({
                        "error": "Account created"
                    }, status.HTTP_404_NOT_FOUND)
        else:
            user = self.create_account(emailOrPhone=emailOrPhone, provider=provider)
            return ({
                        "emailOrPhone": user.emailOrPhone,
                        "user_id": user.id,
                    }, status.HTTP_200_OK)


class RegisterOrLoginSocial(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ['id', 'emailOrPhone', 'provider']

    def validate(self, attrs):
        return attrs


class AccountLogInSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ['id', 'emailOrPhone']

    def validate_id(self, attrs):
        emailOrPhone = attrs.get('emailOrPhone')
        accounts = UserTransport.objects.get(emailOrPhone=emailOrPhone)
        return attrs


class TransportDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = TransportDetail
        fields = ('__all__')
        depth = 1


class TransportUnitsSerializer(serializers.ModelSerializer):
    class Meta:
        model = SelectedUnits
        fields = ('id', 'speedUnit', 'distanseUnit', 'fuelConsumption', 'volume')


class MarkaSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarkaRegister
        fields = ('__all__')
        depth = 1


class SingleRecomendationSerializer(serializers.ModelSerializer):
    class Meta:
        model = SingleRecomendation
        fields = ('__all__')


class ChoiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = TransportDetail
        fields = ("id", 'nameOfTransport')


class AccountCardsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ('__all__')
        depth = 1
        # if new.exists():
        #     print("ssadsasd",new.id)
        #     return attrs
        # else :
        #     return({
        #         "message" : "account not exists",
        #     })       
        # def update(self, instance, validated_data):
        #     email = validated_data.get('email')
        #     if User.objects.filter(email= email).exists():

        #         user = User.objects.get(email = email)
        #         user.set_password(validated_data.get('new_password'))
        #         user.save()

# class LoginSerializer(serializers.ModelSerializer):

#     def get_tokens(self, obj):
#         user = User.objects.get(email=obj['email'])

#         return {
#             'refresh': user.tokens()['refresh'],
#             'access': user.tokens()['access']
#         }

#     class Meta:
#         model = User
#         fields = ['email', 'password', 'tokens']

#     def validate(self, attrs):
#         email = attrs.get('email')
#         password = attrs.get('password')
#         filtered_user_by_email = User.objects.filter(email=email)
#         user = auth.authenticate(email=email, password=password)

#         if filtered_user_by_email.exists() and filtered_user_by_email[0].auth_provider != 'email':
#             raise AuthenticationFailed(
#                 detail='Please continue your login using ' + filtered_user_by_email[0].auth_provider)

#         if not user:
#             raise AuthenticationFailed('Invalid credentials, try again')
#         if not user.is_active:
#             raise AuthenticationFailed('Account disabled, contact admin')
#         if not user.is_verified:
#             raise AuthenticationFailed('Email is not verified')

#         return {
#             'email': user.email,
#             'username': user.username,
#             'tokens': user.tokens
#         }

#         return super().validate(attrs)           

# class LogInAccountSerializer(serializers.ModelSerializer):
#     class Meta():
#         model = User
#         fields = ['id','email','password']

#     def validate_login(self, validated_data):
#         email = validated_data('email')
#         password = validated_data('password')
#         users = User.objects.all()
#         if users.filter(email = email).exists():
#             logUser = users.get(email = email)
#             if logUser.check_password(password):
#                 return {
#                     'message': 'you are authorized'
#                 }
#             else :
#                 return {
#                     'password' : 'invalid'
#                 }
#         else:
#             return {
#                 'account' : 'not exists'
#             }
