# Create your tasks here

from celery import shared_task
from .Payme_Subscribe_API.Application import Application
from .models import UserTransport


@shared_task
def payme_periodic():
    application = Application()
    application.background_run()


@shared_task
def pro_minus_one():
    users = UserTransport.objects.filter(duration__gt=0)
    for user in users:
        user.duration -= 1
        user.save()

@shared_task
def add(x, y):
    return x + y


@shared_task
def mul(x, y):
    return x * y


@shared_task
def xsum(numbers):
    return sum(numbers)
