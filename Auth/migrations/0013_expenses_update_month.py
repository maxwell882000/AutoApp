# Generated by Django 3.1.5 on 2021-02-06 14:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0012_recommendedchange_initial_run'),
    ]

    operations = [
        migrations.AddField(
            model_name='expenses',
            name='update_month',
            field=models.IntegerField(default=30),
        ),
    ]