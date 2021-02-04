# Generated by Django 3.1.5 on 2021-02-02 08:25

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('Auth', '0009_auto_20210202_1121'),
    ]

    operations = [
        migrations.RenameField(
            model_name='transportdetail',
            old_name='averageRun',
            new_name='initial_run',
        ),
        migrations.RenameField(
            model_name='transportdetail',
            old_name='techPassport',
            new_name='tech_passport',
        ),
        migrations.RemoveField(
            model_name='cards',
            name='expenses',
        ),
        migrations.AddField(
            model_name='transportdetail',
            name='expenses',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='expenses', to='Auth.expenses'),
        ),
    ]