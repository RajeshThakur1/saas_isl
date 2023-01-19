from datetime import date,datetime,timedelta,time
from flask import request
from app.main import db
import pytz

#TIMEZONE SETTINGS
IST = pytz.timezone('Asia/Kolkata')



def date_to_str(date):
    if date:
        if date.day < 10 :
            day = "0" + str(date.day)
        else:
            day = str(date.day)
        if date.month <10 :
            month = "0" + str(date.month)
        else:
            month = str(date.month)
        return day + "-" + month + "-" + str(date.year)
    else:
        return ""

def str_to_date(data):
    if data != "":
        n_date = data.split("-")
        try:
            ndate = date(int(n_date[0]),int(n_date[1]),int(n_date[2]))
        except:
            ndate = date(int(n_date[2]),int(n_date[1]),int(n_date[0]))
        return ndate

def str_to_datetime(data):
    
    if ':' in data:
        date_time = data.split(" ")
        n_date = date_time[0].split("-")
        n_time = date_time[1].split(":")
        
    else:
        n_date = data.split("-")
        n_time = [0,0,0]
        
    try:
        date = datetime(int(n_date[0]),int(n_date[1]),int(n_date[2]), int(n_time[0]), int(n_time[1]), int(n_time[2]))
    except:
        date = datetime(int(n_date[2]),int(n_date[1]),int(n_date[0]), int(n_time[0]), int(n_time[1]), int(n_time[2]))
    return date
    
def time_to_str(time):
    if time:
        if time.hour < 10 :
            hour = "0" + str(time.hour)
        else:
            hour = str(time.hour)
        if time.minute <10 :
            minute = "0" + str(time.minute)
        else:
            minute = str(time.minute)
        return hour + ":" + minute
    else:
        return ""
    
def str_to_time(data):
    if data == "" or len(data) > 5 or ':' not in data:
        raise Exception(f'{data} is not in "HH:MM" format')
    
    n_time = data.split(":")

    try:
        hour  = int(n_time[0])
    except:
        raise Exception(f'Hour : {n_time[0]} in {data} should be an integer')

    try:
        minute = int(n_time[1])
    except:
        raise Exception(f'Minute : {n_time[1]} is {data} should be an integer')
    
    
    
    return_time = time(hour,minute)
    return return_time
    
def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days)):
        yield start_date + timedelta(n)

def if_date(data):
    if data:
        return date_to_str(data)
    else:
        return None

def if_time(time):
    if time:
        return time_to_str(time)
    else:
        return None

def if_date_time(date_time):
    if date_time:
        return str(date_time)
    else:
        return None  


def store_open_status(store):
    if store.delivery_start_time or store.delivery_end_time:
        current_datetime = datetime.utcnow()
        current_time = time(current_datetime.hour, current_datetime.minute)
        if store.delivery_start_time == None or store.delivery_end_time ==None:
            return 0

        if store.delivery_start_time <= current_time and current_time <= store.delivery_end_time:
            return 1
        else:
            return 0
    
    else:
        return 0