import inspect
from flask_restx.api import Api
from app.main.model.admin import Admin
from app.main.model.supervisor import Supervisor
from app.main.model.superAdmin import SuperAdmin
from app.main.model.deliveryAgent import DeliveryAgent
from flask import request
import uuid
import datetime
from app.main.service.v1.email import confirm_token, send_confirmation_email, send_email
from app.main import db
from app.main.model.merchant import Merchant
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.config import profile_pic_dir
from app.main.service.v1.notification_service import CreateNotification, generate_data
from app.main.util.v1.database import save_db
import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/merchant_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")



def save_new_merchant(data):
    try:
        merchant = Merchant.query.filter_by(email=data['email']).first()
        merchant_phone=Merchant.query.filter_by(phone=data['phone']).first()
        if not merchant_phone:

            if not merchant:
                new_merchant = Merchant(
                    email=data['email'],
                    name=data['name'],
                    image = profile_pic_dir +"default.png",
                    password=data['password'],
                    phone=data['phone'],
                    created_at=datetime.datetime.utcnow()
                )
                save_changes(new_merchant)
                response_object = {
                    'status': True,
                    'message': 'Successfully registered.'
                }
                service = inspect.currentframe().f_code.co_name

                # CreateNotification.gen_notification_v2(new_merchant, generate_data(name=new_merchant.name, ), service='save_new_merchant')
                

                # send_confirmation_email(new_merchant.email)
                return generate_token(new_merchant)
                
            else:
                response_object = {
                    'status': False,
                    'message': 'User already exists. Please Log in.',
                    'data':None,
                    'error':'mail id already registered',

                }
                return response_object,409
        else:
            response_object = {
                'status': False,
                'message': 'phone number already exists.',
                'data':None,
                'error':'phone number should be unique',

            }
            return response_object,406
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return error-__dict__, 500



def update_profile(data):
    try:
        resp, status = Auth.get_logged_in_merchant(request)
        merchant = resp['data']
   
        update_merchant = Merchant.query.filter_by(email=merchant['email']).first()
        if update_merchant:
            update_merchant.name=data['name']
            update_merchant.password=data['password']
            update_merchant.phone=data['phone']
            update_merchant.updated_at = datetime.datetime.utcnow()
            save_db(update_merchant,"Merchant")
            #db.session.commit()
            # response_object = {
            #     'status': 'success',
            #     'message': 'Successfully Updated.',
            # }
            apiResponce=ApiResponse(True,
                                        'Successfully Updated',
                                        '',None)
            return (apiResponce.__dict__), 201
        else:
            error = ApiResponse(False, 'Merchant does not Exist', None, "")
            return (error.__dict__), 401
    
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None,
                                      str(e))
        return (apiResponce.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'Merchant is not Authorized', None, "Token error")
    #     return (error.__dict__), 500

        

def get_merchantby_email(email):
    return Merchant.query.filter_by(email=email).first()

 

def get_a_merchant():
    pass   
def save_changes(data):
    db.session.add(data)
    db.session.commit()


def generate_token(merchant):
    try:
        # generate the auth token
        auth_token = merchant.encode_auth_token(merchant.id,merchant.role)
        print("hello")
        response_object = {
            'Authorization': auth_token
        }
        apiResponce=ApiResponse(True,
                                    'Successfully registered',
                                    response_object,None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        response_object = {
            'status': False,
            'message': 'Error in token  generataion  Please try again.',
            'data':None,
            'error':str(e)
        }
        return response_object, 500


