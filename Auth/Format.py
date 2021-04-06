import time
from datetime import datetime


class Format():

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
        if date:
            date = datetime.fromisoformat(date)
            return date
        raise ValueError("Throw")
    @staticmethod
    def datetime2timestamp(date):

        if date:
            date = datetime.fromisoformat(date)
            return 1000 * date.timestamp()
        raise ValueError("Throw")

    @staticmethod
    def datetime2str():
        return datetime.now().strftime('%Y-%m-%dT%H:%M:%S.%f+05:00')
