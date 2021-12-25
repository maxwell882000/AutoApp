# Generated by Django 3.1.7 on 2021-08-10 07:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0010_remove_message_type_car'),
    ]

    operations = [
        migrations.AddField(
            model_name='message',
            name='type_car',
            field=models.IntegerField(choices=[(0, 'Все'), (1, 'Механика'), (2, 'Автомат')], default=1, verbose_name='Тип машины'),
        ),
    ]