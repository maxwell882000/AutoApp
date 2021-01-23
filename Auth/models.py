from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.urls import reverse

class UserManager(BaseUserManager):

    def create_user(self, username, password=None, **kwargs):
        user = self.model(username=username, **kwargs)
        user.set_password(password)
        user.save()
        return user
    def create_superuser(self, username, password, **kwargs):
        user = self.model(username=username, is_staff=True, is_superuser=True, **kwargs)
        user.set_password(password)
        user.save()
        return user
class UserName(AbstractBaseUser):
    username =  models.CharField(
    unique = True,
    max_length=254)
    is_verified = models.BooleanField(default = False)
    is_active = models.BooleanField(default = True)
    is_admin  = models.BooleanField(default = False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def __str__(self):
        return self.email

class ModelRegister(models.Model):
    name_of_model = models.CharField(max_length = 50)

    def __str__(self):
        return self.name_of_model

class MarkaRegister(models.Model):
    name_of_marka = models.CharField(max_length= 50, default = 0)
    model = models.ManyToManyField(ModelRegister)
    
    def get_absolute_url(self):
        """Returns the url to access a particular author instance."""
        return reverse('author-detail', args=[str(self.id)])
    
    def __str__(self):
        return self.name_of_marka

class SelectedUnits(models.Model):
    speedUnit       = models.CharField(max_length= 50,default=0)
    distanseUnit    = models.CharField(max_length = 50,default= 0)
    fuelConsumption = models.CharField(max_length = 50,default=0)
    volume          = models.CharField(max_length = 50)  
    
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
    volume          = models.IntegerField(default=0)

class UserTransport(models.Model):
    emailOrPhone = models.CharField(max_length = 200 , unique = True)
    provider     = models.CharField(max_length = 30)
    cards        = models.ForeignKey(TransportDetail, related_name = 'cards' ,on_delete =models.CASCADE, blank= True, null= True)
    units        = models.ForeignKey(SelectedUnits, related_name = 'units' ,on_delete =models.CASCADE, blank= True, null= True)
    def __str__(self):
        return self.emailOrPhone
# Create your models here.


