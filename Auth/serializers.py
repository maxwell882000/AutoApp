from .models import UserTransport,TransportDetail ,SelectedUnits
from rest_framework import serializers , status
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed

class AccountSerializer(serializers.ModelSerializer):
        class Meta():
            model = UserTransport
            fields = ['id','emailOrPhone', 'provider']
        
        def validate(self, attrs):
            emailOrPhone = attrs.get('emailOrPhone')
            provider     = attrs.get('provider')
            accounts     = UserTransport.objects.all()
            if accounts.filter(emailOrPhone = emailOrPhone).exists():
                prov = accounts.get(emailOrPhone = emailOrPhone)
                if prov.provider == provider:
                     return ({
                    "emailOrPhone":  prov.emailOrPhone    
                    }, status.HTTP_200_OK)
                else: 
                    return({
                    "Error" :  "Your registered through other provider"
                    }, status.HTTP_400_BAD_REQUEST)
            else:
                newAccount = UserTransport.objects.create(
                        emailOrPhone = emailOrPhone,
                        provider     = provider,
                )
                newAccount.save()
            return ({
                    "emailOrPhone":  newAccount.emailOrPhone    
                    }, status.HTTP_200_OK)
                    
        def validate_register(self,attrs):
            emailOrPhone = attrs.get('emailOrPhone')
            provider     = attrs.get('provider')
            accounts = UserTransport.objects.all()
            if accounts.filter(emailOrPhone = emailOrPhone).exists():
                return ({
                    "error" : "Аккаунт с такими данными уже существует"
                },status.HTTP_404_NOT_FOUND)
            else:
                user = UserTransport.objects.create(
                    emailOrPhone = emailOrPhone,
                    provider = provider,
                )
                user.save()
                return({
                    "emailOrPhone":  user.emailOrPhone    
                    }, status.HTTP_200_OK)



class RegisterOrLoginSocial(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ['id','emailOrPhone', 'provider']

    def validate(self, attrs):
        
        return attrs

class AccountLogInSerializer(serializers.ModelSerializer):
    class Meta:
         model = UserTransport
         fields = ['id','emailOrPhone']

    def validate_id(self, attrs):
        emailOrPhone = attrs.get('emailOrPhone')
        accounts     = UserTransport.objects.get(emailOrPhone = emailOrPhone)
        print(accounts)

        return attrs

class TransportDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = TransportDetail
        fields =('id','nameOfTransport','marka','model',
                'yearOfMade','yearOfPurchase','firstTank','kilometerPetrol',
                'numberPetrol','secondTank','kilometerGas','numberGas')
class TransportUnitsSerializer(serializers.ModelSerializer):
    class Meta:
        model = SelectedUnits
        fields = ('id','speedUnit','distanseUnit','fuelConsumption','volume')

class AccountCardsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTransport
        fields = ['id', 'emailOrPhone','provider','cards','units']
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
    
    
