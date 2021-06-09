from .Response import Response
from lxml import etree
from Auth.Format import Format



class PaynetException(Exception):



    SUCCESS = 0
    ERROR_INSUFFICIENT_FUNDS = 77
    ERROR_TEMPORARLY_INACCESSABLE = 100
    ERROR_QUOTA_EXHAUSTED = 101
    ERROR_SYSTEM = 102
    ERROR_UNKNOWN = 103
    ERROR_TRANS_ALREADY_EXISTS = 201
    ERROR_TRANS_ALREADY_CANCELED = 202
    ERROR_NUMBER_NOT_FOUND = 301
    ERROR_CLIENT_NOT_FOUND = 302
    ERROR_SERVICE_NOT_FOUND = 305
    ERROR_REQUIRED_PARAM_NOT_SET = 411
    ERROR_WRONG_LOGIN = 412
    ERROR_WRONG_SUM = 413
    ERROR_WRONG_DATE = 414
    ERROR_TRANS_PROHIBIT = 501
    ERROR = 601
    ERROR_WRONG_COMMAND = 603
    dict = {
        0: "Ок",
        77: "Недостаточно средств на счету клиента для отмены платежа ",
        100: "Услуга временно не поддерживается",
        101: "Квота исчерпана",
        102: "Системная ошибка",
        103: "Неизвестная ошибка",
        201: "Транзакция уже существует",
        202: "Транзакция уже отменена",
        301: "Номер не существует",
        302: "Клиент не найден",
        305: "Услуга не найдена",
        411: "Не задан один или несколько обязтельных параметров",
        412: "Неверный логин",
        413: "Неверная сумма",
        414: "Неверный формат даты и времени",
        501: "Транзакции запрещены для данного плательщика",
        601: "Доступ запрещен",
        603: "Неправильный код команды"
    }

    def __init__(self, code, message, method):
        self.code = code
        self.message = message
        self.method = method

    def send(self):
        return Response(method=self.method,
                            message=self.message,
                            code=self.code)
        # return response.send()
