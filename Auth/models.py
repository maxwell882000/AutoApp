from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.core.files.storage import default_storage
import uuid

from .utils import *


# from payments.models import BasePayment



class ClickModel(models.Model):
    pay = models.IntegerField(default=0)


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
    username = models.CharField(
        unique=True,
        max_length=254)
    is_verified = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def __str__(self):
        return self.username


class ImagesForAttached(models.Model):
    image = models.ImageField(upload_to='images/')

    def delete(self, *args, **kwargs):
        delete_obj(self.image)
        super(ImagesForAttached, self).delete(*args, **kwargs)


class Location(models.Model):
    latitude = models.FloatField(default=0)
    longitude = models.FloatField(default=0)
    comment = models.CharField(max_length=70, blank=True, null=True)


class Attach(models.Model):
    image = models.ManyToManyField(ImagesForAttached)
    location = models.ForeignKey(Location, related_name='location', on_delete=models.CASCADE, blank=True, null=True)

    def delete(self, *args, **kwargs):
        for image in self.image.all():
            image.delete()
        self.location.delete()
        super(Attach, self).delete(*args, **kwargs)


class Expenses(models.Model):
    all_time = models.IntegerField(default=0)
    in_this_month = models.IntegerField(default=0)
    update_month = models.IntegerField(default=30)


class RecommendedChange(models.Model):
    initial_run = models.FloatField(blank=True, null=True, default=0)
    run = models.FloatField(blank=True, null=True, default=0)
    time = models.IntegerField(blank=True, null=True, default=0)  # days


class Expense(models.Model):
    name = models.CharField(max_length=70)
    sum = models.IntegerField(default=0)
    amount = models.IntegerField(default=1)


class Card(models.Model):
    name_of_card = models.CharField(max_length=70)
    date = models.DateTimeField(verbose_name="дата", auto_now_add=True)
    date_of_change = models.DateTimeField(blank=True, null=True)
    comments = models.CharField(max_length=100, default="")
    attach = models.ForeignKey(Attach, related_name='attach', on_delete=models.CASCADE, blank=True, null=True)
    expense = models.ManyToManyField(Expense, blank=True, null=True)
    change = models.ForeignKey(RecommendedChange, related_name='attach', on_delete=models.CASCADE, blank=True,
                               null=True)

    def __str__(self):
        return self.name_of_card

    def delete(self, *args, **kwargs):
        try:
            for e in self.expense.all():
                e.delete()
            self.change.delete()
            self.attach.delete()
        except AttributeError:
            pass
        super(Card, self).delete(*args, **kwargs)


class Cards(models.Model):
    card = models.ManyToManyField(Card, related_name='card')
    storeCard = models.ManyToManyField(Card, related_name='store_card')

    def delete(self, *args, **kwargs):
        try:
            for c in self.card.all():
                c.delete()
            for s in self.storeCard.all():
                s.delete()
        except AttributeError:
            pass
        super(Cards, self).delete(*args, **kwargs)


class RecommendCards(models.Model):
    name = models.CharField(default="", max_length=70, verbose_name="Название карточки(Русский)")
    name_uzb = models.CharField(default="", max_length=70, verbose_name="Название карточки(Узбекский)")
    name_eng = models.CharField(default="", max_length=70, verbose_name="Название карточки(Английский)")
    recommend_run = models.FloatField(default=0, verbose_name="пробег в километрах 0 - 100000")
    recommend_run_avarage = models.FloatField(default=0, verbose_name="пробег в километрах 100000 - 200000")
    recommend_run_old = models.FloatField(default=0, verbose_name="пробег в километрах 200000 и больше")
    type_car = models.IntegerField(choices=ChoiceCarType , verbose_name="Тип машины")

    def name_lang(self, lang):
        if lang == 2:
            return self.name
        elif lang == 3:
            return self.name_eng
        else:
            return self.name_uzb

    def select_recommend_run(self, run):
        if run < 100000:
            return run + self.recommend_run
        elif 100000 <= run < 200000:
            return run + self.recommend_run_avarage
        else:
            return run + self.recommend_run_old

    class Meta:
        verbose_name_plural = "Рекоммендованые карточки"

    def __str__(self):
        return self.name


class SingleRecomendation(models.Model):
    main_name_ru = models.CharField(max_length=70, verbose_name="Название для рекомендации(Русский)")
    main_name_uzb = models.CharField(max_length=70, verbose_name="Название для рекомендации(Узбекский)")
    main_name_eng = models.CharField(max_length=70, verbose_name="Название для рекомендации(Английский)")
    description = models.TextField(verbose_name="Описание рекомендации(Русский)")
    description_uzb = models.TextField(verbose_name="Описание рекомендации(Узбекский)")
    description_eng = models.TextField(verbose_name="Описание рекомендации(Английский)")
    recomended_probeg = models.FloatField(default=0, verbose_name="Рекомендованный пробег в километрах")

    class Meta:
        verbose_name_plural = 'Рекоммендации'

    def __str__(self):
        return self.main_name_ru


class ModelRegister(models.Model):
    name_of_model = models.CharField(max_length=70, verbose_name="Название модели", unique=True)
    recomendations = models.ManyToManyField(SingleRecomendation, verbose_name="Рекомендации для модели")
    recommend_card = models.ManyToManyField(RecommendCards, verbose_name="Рекомендованные карточки")
    image_above = models.ImageField(upload_to='admin/', verbose_name="Фото для модели")
    text_above = models.TextField(verbose_name="Описание модели(Русский)")
    text_above_eng = models.TextField(verbose_name="Описание модели(Английский)")
    text_above_uzb = models.TextField(verbose_name="Описание модели(Узбекский)")

    class Meta:
        verbose_name_plural = 'Модель'

    def text_above_lang(self, lang: int):
        if lang == 2:
            return self.text_above
        elif lang == 3:
            return self.text_above_eng
        else:
            return self.text_above_uzb

    def delete(self, *args, **kwargs):
        for recommendation in self.recomendations.all():
            recommendation.delete()
        delete_obj(self.image_above)
        super(ModelRegister, self).delete(*args, **kwargs)

    def __str__(self):
        return self.name_of_model


class MarkaRegister(models.Model):
    name_of_marka = models.CharField(max_length=70, default=0, verbose_name="Название марки", unique=True)
    model = models.ManyToManyField(ModelRegister, verbose_name="Модель")

    def delete(self, *args, **kwargs):
        for obj in self.model.all():
            obj.delete()
        super(MarkaRegister, self).delete(*args, **kwargs)

    class Meta:
        verbose_name_plural = 'Марка'

    def __str__(self):
        return self.name_of_marka


class SelectedUnits(models.Model):
    speedUnit = models.CharField(max_length=70, default="км/д")
    distanseUnit = models.CharField(max_length=70, default="км")
    fuelConsumption = models.CharField(max_length=70, default="км/л")
    volume = models.CharField(max_length=70, default="UZS")


class TransportDetail(models.Model):
    nameOfTransport = models.CharField(max_length=70)
    marka = models.CharField(max_length=70)
    model = models.CharField(max_length=70)
    yearOfMade = models.CharField(max_length=4)
    yearOfPurchase = models.CharField(max_length=4)
    number = models.CharField(max_length=70)
    numberOfTank = models.IntegerField(default=0)
    firstTankType = models.CharField(max_length=70)
    firstTankVolume = models.IntegerField(default=0)
    secondTankType = models.CharField(max_length=70, blank=True, null=True)
    secondTankVolume = models.IntegerField(default=0, blank=True, null=True)
    run = models.FloatField(default=0)
    initial_run = models.FloatField(default=0)
    tech_passport = models.CharField(max_length=70)
    cards_user = models.ForeignKey(Cards, related_name='cards_user', on_delete=models.CASCADE, blank=True, null=True)
    expenses = models.ForeignKey(Expenses, related_name='expenses', on_delete=models.CASCADE, blank=True, null=True)
    type_car = models.IntegerField(choices=ChoiceCarType, default=1)

    def delete(self, *args, **kwargs):
        try:
            self.cards_user.delete()
            self.expenses.delete()
        except AttributeError:
            pass
        super(TransportDetail, self).delete(*args, **kwargs)


class UserTransport(models.Model):
    emailOrPhone = models.CharField(max_length=200, unique=True)
    provider = models.CharField(max_length=70)
    cards = models.ManyToManyField(TransportDetail, null=True, blank=True)
    units = models.ForeignKey(SelectedUnits, related_name='units', on_delete=models.CASCADE, blank=True, null=True)
    date = models.DateTimeField(auto_now_add=True)
    pro_account = models.BooleanField(default=False)
    last_account = models.IntegerField(default=0)
    duration = models.IntegerField(default=0)
    balans = models.IntegerField(default=0)

    class Meta:
        verbose_name_plural = 'Аккаунты'

    def delete(self, *args, **kwargs):
        if self.cards is not None and self.cards.all() != []:
            for card in self.cards.all():
                card.delete()
        if self.units is not None:
            self.units.delete()
        super(UserTransport, self).delete(*args, **kwargs)

    def __str__(self):
        return self.emailOrPhone


class Temporary(models.Model):
    image = models.ManyToManyField(ImagesForAttached)
    expenses = models.ManyToManyField(Expense)
    user = models.ForeignKey(UserTransport, related_name='user_for_images', on_delete=models.CASCADE, blank=True,
                             null=True)

    def delete_operation(self):
        for image in self.image.all():
            delete_obj(image.image)
            image.delete()
        for expense in self.expenses.all():
            expense.delete()

    def clean_operation(self):
        self.image.clear()
        self.expenses.clear()
        self.save()


class Adds(models.Model):
    file = models.FileField(upload_to='admin/adds/', verbose_name="Реклама", max_length=100)
    links = models.CharField(max_length=200, verbose_name="Линк для перехода")

    def delete(self, *args, **kwargs):
        delete_obj(self.file)
        self.file.delete()
        super(Adds, self).delete(*args, **kwargs)

    class Meta:
        verbose_name_plural = 'Реклама'


class Transactions(models.Model):
    paycom_transaction_id = models.CharField(max_length=25)
    paycom_time = models.CharField(max_length=13)
    paycom_time_datetime = models.DateField()
    create_time = models.DateField()
    perform_time = models.DateField()
    cancel_time = models.DateField()
    amount = models.IntegerField()
    state = models.IntegerField()
    reason = models.IntegerField()
    receivers = models.CharField(max_length=500)
    order_id = models.IntegerField()


# Create your models here.

class Orders(models.Model):
    product_ids = models.CharField(max_length=255)
    amount = models.IntegerField()
    state = models.IntegerField()
    user_id = models.IntegerField()
    phoneOrMail = models.CharField(max_length=15)


class AmountProAccount(models.Model):
    name_subscribe_ru = models.CharField(max_length=70, verbose_name="Название подписки(Русский)")
    name_subscribe_uzb = models.CharField(max_length=70, verbose_name="Название подписки(Узбекский)")
    name_subscribe_eng = models.CharField(max_length=70, verbose_name="Название подписки(Английский)")
    price = models.IntegerField(verbose_name="Цена подписки в суммах", default=0)
    duration = models.IntegerField(verbose_name="Длительность подписки в днях", default=0)
    type = models.IntegerField(choices=ChoicesForSubscribe, default=0, verbose_name="Тип подписки")

    class Meta:
        verbose_name_plural = 'Подписка'

    def __str__(self):
        return self.name_subscribe_ru


class PaymeProPayment(models.Model):
    token = models.CharField(max_length=500, blank=True, null=True)
    id = models.BigIntegerField(default=create_new_ref_number, primary_key=True, unique=True)
    hashed_id = models.CharField(max_length=50)
    user = models.ForeignKey(UserTransport, related_name='client_payme', on_delete=models.CASCADE, blank=True,
                             null=True)
    amount = models.ForeignKey(AmountProAccount, related_name='amount', on_delete=models.CASCADE, blank=True, null=True)


class PaynetProPayment(models.Model):
    user = models.ForeignKey(UserTransport, related_name='client_paynet', on_delete=models.CASCADE)
    customerId = models.CharField(max_length=12, blank=True, unique=True)

    def save(self, *args, **kwargs):
        if not self.customerId:
            while True:
                id_unique = uuid.uuid4().hex[:12].upper()
                if not PaynetProPayment.objects.filter(customerId=id_unique).exists():
                    break
            self.customerId = id_unique
        super(PaynetProPayment, self).save(*args, **kwargs)


class Message(models.Model):
    title = models.CharField(max_length=70, verbose_name="Заглавние")
    body = models.CharField(max_length=70, verbose_name="Содержание")
    type_cards = models.ManyToManyField(RecommendCards, verbose_name="Для каких карточек")
    type_car = models.IntegerField(choices=ChoiceCarType, default=1, verbose_name="Тип машины")

    class Meta:
        verbose_name_plural = 'Push уведомления'

    def __str__(self):
        return self.title


class Transaction(models.Model):
    amount = models.BigIntegerField(default=0)
    paid_time = models.DateField()
    transactionId = models.BigIntegerField(default=0)
    state = models.IntegerField(default=0)
    customer = models.ForeignKey(PaynetProPayment, related_name='customer', on_delete=models.CASCADE)
    providerTrnId = models.BigIntegerField(default=create_new_ref_number, unique=True)


class Test(models.Model):
    user = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False)
