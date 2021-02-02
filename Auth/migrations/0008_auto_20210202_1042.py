# Generated by Django 3.1.5 on 2021-02-02 05:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0007_auto_20210202_1027'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recommendedchange',
            name='run',
            field=models.FloatField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='recommendedchange',
            name='time',
            field=models.IntegerField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='singlerecomendation',
            name='recomended_probeg',
            field=models.FloatField(default=0, verbose_name='Рекомендованный пробег'),
        ),
    ]
