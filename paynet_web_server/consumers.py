from channels.generic.websocket import AsyncWebsocketConsumer
import json
from django.views.decorators.csrf import csrf_exempt


class PaynetServer(AsyncWebsocketConsumer):

    def connect(self):
        self.accept()

    def disconnect(self, close_code):
        pass

    def receive(self, text_data, bytes_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']

        self.send(text_data=json.dumps({
            'message': message
        }))
