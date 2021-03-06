from channels.generic.websocket import AsyncWebsocketConsumer,WebsocketConsumer
import json
from django.views.decorators.csrf import csrf_exempt


class PaynetServer(WebsocketConsumer):

    def connect(self):
        self.accept()

    def disconnect(self, close_code):
        pass

    def receive(self, text_data):
        text_data_json = text_data
        message = text_data

        self.send(text_data=json.dumps({
            'message': message
        }))
