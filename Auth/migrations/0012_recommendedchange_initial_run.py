# Generated by Django 3.1.5 on 2021-02-06 10:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0011_auto_20210203_1838'),
    ]

    operations = [
        migrations.AddField(
            model_name='recommendedchange',
            name='initial_run',
            field=models.FloatField(blank=True, null=True),
        ),
    ]
