# Generated by Django 3.1.5 on 2021-02-18 17:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0016_auto_20210217_1700'),
    ]

    operations = [
        migrations.AddField(
            model_name='usertransport',
            name='ballans',
            field=models.IntegerField(default=0),
        ),
    ]
