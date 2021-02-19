import time
from datetime import datetime
class Format():
   
    def toSom(self,coins):
    
        return 1 * coins / 100
    

    
    def toCoins(self, amount):
    
        return round(1 * amount * 100)
    

    def timestamp(self,milliseconds = False):
    
        if milliseconds: 
            return int(round(time.time() * 1000))

        return time(); 
    
    def timestamp2seconds(self, timestamp):
        date = datetime.fromtimestamp(timestamp)
        return date.timestamp()
    
    def timestamp2milliseconds(self,timestamp):
        
        date = datetime.fromtimestamp(timestamp)
        return date.timestamp()* 1000;


    def timestamp2datetime(self,timestamp):
        
        dt_obj = datetime.fromtimestamp(timestamp).strftime("%m/%d/%Y, %H:%M:%S")

        return dt_obj
    

    def datetime2timestamp(self,datetime):
        format = '%Y-%m-%d %H:%M:%S'
        
        if (datetime):
            date  = datetime.strptime(datetime, format)
            return 1000 * date
        

        return datetime


