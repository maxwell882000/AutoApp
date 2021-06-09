import time
from datetime import datetime


class Format():
    FORMAT = '%Y-%m-%dT%H:%M:%S.%f+05:00'
    # FORMAT = '%Y-%m.%d'
    @staticmethod
    def toSom(coins):

        return 1 * coins / 100

    @staticmethod
    def toCoins(amount):

        return round(1 * amount * 100)

    @staticmethod
    def timestamp(milliseconds=False):

        if milliseconds:
            return int(round(time.time() * 1000))

        return time.time()

    @staticmethod
    def timestamp2seconds(timestamp):
        date = datetime.fromtimestamp(timestamp)
        return date.timestamp()

    @staticmethod
    def timestamp2milliseconds(timestamp):

        date = datetime.fromtimestamp(timestamp)
        return date.timestamp() * 1000;

    @staticmethod
    def timestamp2datetime(timestamp):

        dt_obj = datetime.fromtimestamp(timestamp).strftime("%m/%d/%Y, %H:%M:%S")

        return dt_obj

    @staticmethod
    def str2datetime(date):
        if date and type(date) == str:
            print("TYPE DATE IS ")
            print(type(date))
            date = datetime.fromisoformat(date)
            print(date)
            return date
        raise ValueError("Throw")

    @staticmethod
    def datetime2timestamp(date):

        if date:
            date = datetime.fromisoformat(date)
            return 1000 * date.timestamp()
        raise ValueError("Throw")

    @staticmethod
    def datetime2str(date):
        return date.strftime(Format.FORMAT)

    @staticmethod
    def current_time():
        return datetime.now().strftime(Format.FORMAT)
