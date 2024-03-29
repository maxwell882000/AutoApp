# Generated by Django 3.1.7 on 2021-08-09 12:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0004_auto_20210705_0513'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='modelregister',
            name='text_above',
        ),
        migrations.RemoveField(
            model_name='recommendcards',
            name='name',
        ),
        migrations.AddField(
            model_name='amountproaccount',
            name='name_subscribe_eng',
            field=models.CharField(default=2, max_length=50, verbose_name='Название подписки'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='amountproaccount',
            name='name_subscribe_uzb',
            field=models.CharField(default=2, max_length=50, verbose_name='Название подписки'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='modelregister',
            name='text_above_eng',
            field=models.TextField(default=2, verbose_name='Описание модели(Английский)'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='modelregister',
            name='text_above_uzb',
            field=models.TextField(default=2, verbose_name='Описание модели(Узбекский)'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='recommendcards',
            name='name_eng',
            field=models.CharField(default='', max_length=30, verbose_name='Название карточки(Английский)'),
        ),
        migrations.AddField(
            model_name='recommendcards',
            name='name_uzb',
            field=models.CharField(default='', max_length=30, verbose_name='Название карточки(Узбекский)'),
        ),
        migrations.AddField(
            model_name='singlerecomendation',
            name='description_eng',
            field=models.TextField(default=2, verbose_name='Описание рекомендации(Английский)'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='singlerecomendation',
            name='description_uzb',
            field=models.TextField(default=2, verbose_name='Описание рекомендации(Узбекский)'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='singlerecomendation',
            name='main_name_eng',
            field=models.CharField(default=2, max_length=70, verbose_name='Название для рекомендации(Английский)'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='singlerecomendation',
            name='main_name_uzb',
            field=models.CharField(default=42, max_length=70, verbose_name='Название для рекомендации(Узбекский)'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='singlerecomendation',
            name='description',
            field=models.TextField(verbose_name='Описание рекомендации(Русский)'),
        ),
        migrations.AlterField(
            model_name='singlerecomendation',
            name='main_name',
            field=models.CharField(max_length=70, verbose_name='Название для рекомендации(Русский)'),
        ),
    ]
