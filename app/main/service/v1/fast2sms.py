import logging
import requests
from app.main.config import FAST2SMS_AUTH_HEADER,FAST2SMS_ROUTE,FAST2SMS_SENDER_ID,FAST2SMS_URL

class Fast2SMS:

    def send_sms(phone,message,language='english',flash=0,):

        try:
            request_headers = {

                "authorization":FAST2SMS_AUTH_HEADER,
                "Content-Type":"application/json"
            }

            request_body = {
                'route': FAST2SMS_ROUTE,
                'sender_id': FAST2SMS_SENDER_ID,
                'message': message,
                'language': language,
                'flash': flash,
                'numbers': str(phone)
            }

            sms = requests.request("POST", url=FAST2SMS_URL, headers=request_headers, params=request_body)

            return sms
        except:
            return None