# Generated by Django 3.1.7 on 2021-06-17 06:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='selectedunits',
            name='distanseUnit',
            field=models.CharField(default='км', max_length=20),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='fuelConsumption',
            field=models.CharField(default='км/л', max_length=20),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='speedUnit',
            field=models.CharField(default='км/д', max_length=20),
        ),
        migrations.AlterField(
            model_name='selectedunits',
            name='volume',
            field=models.CharField(default='UZS', max_length=20),
        ),
    ]
