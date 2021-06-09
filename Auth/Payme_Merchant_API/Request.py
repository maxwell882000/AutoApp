from .Exception import PayMeException


class Request():

    def __init__(self, request):
        self.payload = request.body

        if not self.payload:
            raise PayMeException(
                None,
                'Invalid JSON-RPC object.',
                PayMeException.ERROR_INVALID_JSON_RPC_OBJECT
            );

        self.id = 'id' in self.payload if 1 * self.payload['id'] else None
        self.method = 'method' in self.payload if self.payload['method'].strip() else None
        self.params = 'params' in self.payload if self.payload['params'] else []
        self.amount = 'amount' in self.payload['params'] if 1 * self.payload['params']['amount'] else None

        self.params['request_id'] = self.id;

    def account(self, param):
        return 'account' in self.params and param in self.params['account'] if self.params['account'][param] else None
