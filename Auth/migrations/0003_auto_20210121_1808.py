# Generated by Django 3.1.5 on 2021-01-21 13:08

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0002_auto_20210121_1431'),
    ]

    operations = [
        migrations.CreateModel(
            name='MarkaRegister',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name_of_marka', models.CharField(default=0, max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='ModelRegister',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name_of_model', models.CharField(max_length=50)),
            ],
        ),
        migrations.DeleteModel(
            name='InformationAutoRegister',
        ),
        migrations.AddField(
            model_name='markaregister',
            name='model',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='model', to='Auth.modelregister'),
        ),
    ]