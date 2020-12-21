from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager


# class UserManager(BaseUserManager):

#     def create_user(self,emailOrPhone , auth_provider):
#         user = self
#         user.emailOrPhone= emailOrPhone
#         password = "123Asd$@31"
#         user.set_password(password)
#         user.save(using =self._db)
#         return user

# AUTH_PROVIDERS = {'facebook': 'facebook', 'google': 'google',
#                    'email': 'email', 'phone' : 'phone'}
# class User(AbstractBaseUser):
#     emailOrPhone =  models.CharField(verbose_name = 'email or phone',
#     unique = True,
#     max_length=254)
#     is_verified = models.BooleanField(default = False)
#     is_active = models.BooleanField(default = True)
#     is_admin  = models.BooleanField(default = False)
#     auth_provider = models.CharField(
#         max_length=255, blank=False,
#         null=False, default=AUTH_PROVIDERS.get('email'))

#     USERNAME_FIELD = 'emailOrPhone'
#     REQUIRED_FIELDS = []

#     objects = UserManager()

#     def __str__(self):
#         return self.email
   
class TransportDetail(models.Model):
    nameOfTransport = models.CharField(max_length = 50)
    marka           = models.CharField(max_length = 20)
    model           = models.CharField(max_length = 30)
    yearOfMade      = models.CharField(max_length = 4)
    yearOfPurchase  = models.CharField(max_length = 4)
    firstTank       = models.BooleanField( default=True)
    kilometerPetrol = models.IntegerField(default = 0)
    numberPetrol    = models.IntegerField(default = 0)
    secondTank      = models.BooleanField(default=True)
    kilometerGas    = models.IntegerField(default = 0)
    numberGas       = models.IntegerField(default = 0)

class UserTransport(models.Model):
    emailOrPhone = models.CharField(max_length = 200 , unique = True)
    provider     = models.CharField(max_length = 30)
    cards        = models.ForeignKey(TransportDetail, related_name = 'cards' ,on_delete =models.CASCADE, blank= True, null= True)
    
    def __str__(self):
        return self.emailOrPhone
# Create your models here.


