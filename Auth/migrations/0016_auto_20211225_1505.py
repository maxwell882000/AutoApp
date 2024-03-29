# Generated by Django 3.2.6 on 2021-12-25 10:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0015_auto_20211225_1502'),
    ]

    operations = [
        migrations.AlterField(
            model_name='amountproaccount',
            name='name_subscribe_eng',
            field=models.CharField(max_length=70, verbose_name='Название подписки(Английский)'),
        ),
        migrations.AlterField(
            model_name='amountproaccount',
            name='name_subscribe_ru',
            field=models.CharField(max_length=70, verbose_name='Название подписки(Русский)'),
        ),
        migrations.AlterField(
            model_name='amountproaccount',
            name='name_subscribe_uzb',
            field=models.CharField(max_length=70, verbose_name='Название подписки(Узбекский)'),
        ),
        migrations.AlterField(
            model_name='card',
            name='name_of_card',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='expense',
            name='name',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='location',
            name='comment',
            field=models.CharField(blank=True, max_length=70, null=True),
        ),
        migrations.AlterField(
            model_name='markaregister',
            name='name_of_marka',
            field=models.CharField(default=0, max_length=70, unique=True, verbose_name='Название марки'),
        ),
        migrations.AlterField(
            model_name='message',
            name='body',
            field=models.CharField(max_length=70, verbose_name='Содержание'),
        ),
        migrations.AlterField(
            model_name='message',
            name='title',
            field=models.CharField(max_length=70, verbose_name='Заглавние'),
        ),
        migrations.AlterField(
            model_name='modelregister',
            name='name_of_model',
            field=models.CharField(max_length=70, unique=True, verbose_name='Название модели'),
        ),
        migrations.AlterField(
            model_name='recommendcards',
            name='name',
            field=models.CharField(default='', max_length=70, verbose_name='Название карточки(Русский)'),
        ),
        migrations.AlterField(
            model_name='recommendcards',
            name='name_eng',
            field=models.CharField(default='', max_length=70, verbose_name='Название карточки(Английский)'),
        ),
        migrations.AlterField(
            model_name='recommendcards',
            name='name_uzb',
            field=models.CharField(default='', max_length=70, verbose_name='Название карточки(Узбекский)'),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='distanseUnit',
            field=models.CharField(default='км', max_length=70),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='fuelConsumption',
            field=models.CharField(default='км/л', max_length=70),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='speedUnit',
            field=models.CharField(default='км/д', max_length=70),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='volume',
            field=models.CharField(default='UZS', max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='firstTankType',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='marka',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='model',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='nameOfTransport',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='number',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='secondTankType',
            field=models.CharField(blank=True, max_length=70, null=True),
        ),
        migrations.AlterField(
            model_name='transportdetail',
            name='tech_passport',
            field=models.CharField(max_length=70),
        ),
        migrations.AlterField(
            model_name='usertransport',
            name='provider',
            field=models.CharField(max_length=70),
        ),
    ]
