import random

from django.core.files.storage import default_storage


def create_new_ref_number():
    return random.randint(1000000000, 372036854775807)


ChoicesForSubscribe = (
    (0, 'Одноразовая оплата'),
    (1, 'Подписка')
)
ChoiceCarType = (
    (0, "Все"),
    (1, 'Механика'),
    (2, 'Автомат')
)

ChoiceRun = (
    (0, "Все"),
    (1, 'пробег в километрах 0 - 100000'),
    (2, 'пробег в километрах 100000 - 200000'),
    (3, 'пробег в километрах 200000 и больше')
)


def delete_obj(o):
    try:
        default_storage.delete(o.path)
    except:
        pass
