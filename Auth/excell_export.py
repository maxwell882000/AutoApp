# from import_export import resources, fields
# from Auth.models import UserTransport, TransportDetail
# from import_export.widgets import ManyToManyWidget
#
#
# def card(name: str):
#     relation = "cards__" + name
#     return relation
#
#
# def card_user(name: str):
#     return card("cards_user__card__" + name)
#
#
# def cards_user_expenses(name: str):
#     return card_user("expense__" + name)
#
#
# def cards_all():
#     return ("emailOrPhone", card('model'), card('marka'),
#             card('yearOfMade'), card('number'),
#             card('yearOfPurchase'), card('numberOfTank'),
#             card('firstTankType'), card('firstTankVolume'),
#             card('secondTankType'), card('secondTankVolume'),
#             card('run'), card('initial_run'), card('tech_passport'),
#             card_user("name_of_card"), card_user('date'), card_user('comments'),
#             cards_user_expenses('name'), cards_user_expenses('sum'),
#             cards_user_expenses('amount')
#             )
#
#
# class UserResource(resources.ModelResource):
#     class Meta:
#         model = UserTransport
