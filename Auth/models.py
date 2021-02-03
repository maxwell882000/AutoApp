from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.urls import reverse
from django.utils import timezone
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

class ImagesForAttached(models.Model):
    image = models.ImageField(upload_to = 'images/')

class Attach(models.Model):
    image = models.ManyToManyField(ImagesForAttached)
    location = models.CharField(max_length = 50, blank = True, null = True)


class Expenses(models.Model):
    all_time = models.IntegerField(default = 0)
    in_this_month = models.IntegerField(default = 0)
    
class RecommendedChange(models.Model):
    run = models.FloatField(blank = True, null = True)
    time = models.IntegerField(blank = True, null = True) #days

class Expense(models.Model):
    name = models.CharField(max_length = 50)
    sum = models.IntegerField(default=0)
    amount = models.IntegerField(default=1)
    
class Card(models.Model):
    name_of_card = models.CharField(max_length = 50)
    date         = models.DateTimeField(verbose_name="дата") 
    comments     = models.CharField(max_length = 100)
    attach       = models.ForeignKey(Attach, related_name = 'attach' ,on_delete =models.CASCADE, blank= True, null= True)
    expense      = models.ManyToManyField(Expense)
    change = models.ForeignKey(RecommendedChange, related_name = 'attach' ,on_delete =models.CASCADE, blank= True, null= True)

class Cards(models.Model):
    card        = models.ManyToManyField(Card)
    

class SingleRecomendation(models.Model):
    main_name   = models.CharField(max_length = 70,verbose_name="Название для рекомендации")
    description = models.TextField(verbose_name="Описание рекомендации")
    recomended_probeg = models.FloatField(default=0,verbose_name="Рекомендованный пробег в километрах")
    def __str__(self):
        return self.main_name


class ModelRegister(models.Model):
    name_of_model = models.CharField(max_length = 50,verbose_name="Название модели")
    recomendations = models.ManyToManyField(SingleRecomendation,verbose_name="Рекомендации для модели")
    image_above = models.ImageField(upload_to = 'admin/', verbose_name="Фото для модели")
    text_above  = models.TextField( verbose_name="Описание модели")
    def __str__(self):
        return self.name_of_model

class MarkaRegister(models.Model):
    name_of_marka = models.CharField(max_length= 50, default = 0, verbose_name="Название марки")
    model = models.ManyToManyField(ModelRegister)
    
    def get_absolute_url(self):
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
    number          = models.CharField(max_length = 30)
    numberOfTank    = models.IntegerField(default=0)
    firstTankType   = models.CharField(max_length = 30)
    firstTankVolume = models.IntegerField(default = 0)
    secondTankType  = models.CharField(max_length = 30,blank= True, null=True)
    secondTankVolume= models.IntegerField(default = 0, blank= True, null=True)
    run             = models.FloatField(default = 0)
    initial_run     = models.FloatField(default = 0)
    tech_passport    = models.CharField(max_length = 30) 
    cards_user      = models.ForeignKey(Cards,related_name = 'cards_user' ,on_delete =models.CASCADE, blank= True, null= True)
    expenses        = models.ForeignKey(Expenses, related_name = 'expenses' ,on_delete =models.CASCADE, blank= True, null= True )

class UserTransport(models.Model):
    emailOrPhone = models.CharField(max_length = 200 , unique = True)
    provider     = models.CharField(max_length = 30)
    cards        = models.ForeignKey(TransportDetail,related_name = 'cards' ,on_delete =models.CASCADE, blank= True, null= True)
    units        = models.ForeignKey(SelectedUnits, related_name = 'units' ,on_delete =models.CASCADE, blank= True, null= True)
    date         = models.DateTimeField(auto_now_add=True)


    def __str__(self):
        return self.emailOrPhone



# Create your models here.


