import requests
from django.conf import settings


class Requests:
    def __init__(self, payer):
        self.url = settings.PAYME.get('url')
        self.headers = settings.PAYME.get('headers')
        self.token = payer.token
        self.payer = payer

    def receipts_create(self, amount):
        body = {
            "id": self.payer.id,
            "method": "receipts.create",
            "params": {
                "amount": amount.price * 100,
            }
        }

        result = requests.post(self.url, json=body, headers=self.headers)

        return result

    def receipts_pay(self, request):
        body = {
            "id": request['id'],
            "method": "receipts.pay",
            "params": {
                "id": request['id_params'],
                "token": self.token,
            }
        }

        result = requests.post(self.url, json=body, headers=self.headers)

        return result

    def cards_remove(self, identifier):
        body = {
            "id": identifier,
            "method": "cards.remove",
            'params': {
                "token": self.token,
            }
        }
        result = requests.post(self.url, json=body, headers=self.headers)
        self.payer.delete()
        return result
