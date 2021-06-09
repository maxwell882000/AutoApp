import random


def create_new_ref_number():
    return random.randint(1000000000, 372036854775807)


ChoicesForSubscribe = (
    (1, 'Одноразовая'),
    (2, 'Подписка')
)
