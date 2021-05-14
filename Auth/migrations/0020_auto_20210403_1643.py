# Generated by Django 3.1.4 on 2021-04-03 11:43

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0019_auto_20210319_1617'),
    ]

    operations = [
        migrations.CreateModel(
            name='AmountProAccount',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name_subscribe', models.CharField(max_length=50, verbose_name='Название подписки')),
                ('price', models.IntegerField(default=0, verbose_name='Цена подписки в суммах')),
                ('duration', models.IntegerField(default=0, verbose_name='Длительность подписки в днях')),
            ],
            options={
                'verbose_name_plural': 'Подписка',
            },
        ),
        migrations.RemoveField(
            model_name='usertransport',
            name='ballans',
        ),
        migrations.AlterField(
            model_name='markaregister',
            name='model',
            field=models.ManyToManyField(to='Auth.ModelRegister', verbose_name='Модель'),
        ),
        migrations.CreateModel(
            name='PaymeProPayment',
            fields=[
                ('token', models.CharField(max_length=100)),
                ('id', models.IntegerField(default=0, primary_key=True, serialize=False)),
                ('duration', models.IntegerField(default=0)),
                ('amount', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='amount', to='Auth.amountproaccount')),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='client', to='Auth.usertransport')),
            ],
        ),
    ]