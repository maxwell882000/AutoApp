# Generated by Django 3.1.7 on 2021-08-10 08:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0011_message_type_car'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recommendcards',
            name='type_car',
            field=models.IntegerField(choices=[(0, 'Все'), (1, 'Механика'), (2, 'Автомат')], verbose_name='Тип машины'),
        ),
    ]
