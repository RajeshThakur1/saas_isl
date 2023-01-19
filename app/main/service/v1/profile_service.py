import datetime
from multiprocessing import Process
from flask.helpers import url_for

from flask.templating import render_template

from app.main.model.admin import Admin
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.notification import NotificationTemplates
from app.main.model.superAdmin import SuperAdmin
from app.main.model.merchant import Merchant
from app.main.model.user import User
from app.main.service.v1.sms import generateOTPsms
from app.main.util.v1.database import save_db
from app.main.model.supervisor import Supervisor
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
import string
import random # define the random module
from app.main.service.v1.notification_service import CreateNotification
from app.main.service.v1 import mailgun
from app.main.config import profile_pic_dir, master_pass

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/profile_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def change_password(data):
    """
    Changes user account password based on login token and given arguments
    
    Parameters: json data
    Return type: __dict__, Integer"""
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'supervisor':
            user = Supervisor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'merchant':
            user = Merchant.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'super_admin':
            user = SuperAdmin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'admin':
            user = Admin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()

        elif user['role'] =='customer':
            user = User.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'distributor':
            user = Distributor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'delivery_associate':
            user = DeliveryAssociate.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user:
            if user.check_password(data['old_password']):

                user.password = data['new_password']
                save_db(user, "User")
                
                #EmailNotification
                reset_link= url_for("api.auth_forget_passowrd_api")
                html=render_template("changePassword.html", user_role=resp['data']['role'], user_name=user.name, reset_link=reset_link)
                send_mail =mailgun.send_mail(email=user.email,html=html, subject=f"24x7 | Changed password for {resp['data']['role']} {user.name}")

                if send_mail.status_code == 200:

                    apiResponce = ApiResponse(True, 'Password Changed Successfully'
                                    , None, None)

                    return (apiResponce.__dict__), 200

                else:

                    #TODO ROLLBACK DB
                    error = ApiResponse(False, 'Mail Server Returned Error', None, f"Status Code: {send_mail.status_code}")
                    return (error.__dict__), send_mail.status_code

            else:
                error = ApiResponse(False, 'Old Password Does not Matched', None,
                            None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'User Not Found', None,
                            None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

def get_profile():
    """
    Get User profile based on login token

    Return type: __dict__, Integer
    """
    # result=[]
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'merchant':
            userdata = Merchant.query.filter_by(email=user['email']).first()
        
        elif user['role'] == 'super_admin':
            userdata = SuperAdmin.query.filter_by(email=user['email']).first()
        
        elif user['role'] == 'supervisor':
            userdata = Supervisor.query.filter_by(email=user['email']).first()
        
        elif user['role'] == 'admin':
            userdata = Admin.query.filter_by(email=user['email']).first()
        
        elif user['role'] == 'distributor':
            userdata = Distributor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        elif user['role'] == 'delivery_associate':
            userdata = DeliveryAssociate.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if userdata:
            response_object={
            'name':userdata.name,
            'email':userdata.email,
            'image':userdata.image,
            'role':userdata.role,
            'active':userdata.active,
            'phone':userdata.phone
            }

            # result.append(response_object)
            apiResponce = ApiResponse(True,
                                        'Profile successfully fetched',
                                        response_object,None)
            return  (apiResponce.__dict__), 200
        
        else:
            apiResponce = ApiResponse(False,
                                        'Profile Not Found',
                                       None,None)
            return  (apiResponce.__dict__), 200
    
    except Exception as e :
        # response_object = {
        #     # 'status': 'fail',
        #     'message': 'Some error occurred. Please try again.'
        # }
        apiResponce=ApiResponse(False,
                                    'Some Error Occured! Please try again',
                                    None,str(e))
        return (apiResponce.__dict__), 400

def update_profile(data):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'supervisor':
            user = Supervisor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'merchant':
            user = Merchant.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'super_admin':
            user = SuperAdmin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'admin':
            user = Admin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user:
            if user.check_password(data['password']):

                changes = []
                if not user.name == data['name']:
                    user.name = data['name']
                    changes.append('name')
                    notification_data_1={
                        'template_name': 'change_profile_details',
                        'role': str.capitalize(user['role']),
                        'property': 'Name',
                        'value': data['name']
                    }
                    CreateNotification.gen_notification_v2(user_obj=user, data=notification_data_1)
                if not user.email == data['email']:
                    user.email = data['email']
                    changes.append("email")
                    notification_data_2={
                        'template_name': 'change_profile_details',
                        'role': str.capitalize(user['role']),
                        'property': 'Email',
                        'value': data['email']
                    }
                    CreateNotification.gen_notification_v2(user_obj=user, data=notification_data_2)

                save_db(user)
                    
                apiResponce = ApiResponse(True, 'Profile Details Updated Successfully'
                                  , None, None)

                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Password Does not Matched', None,
                            None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'User Not Found', None,
                            None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500



def update_profile_email(data,verified=False):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'supervisor':
            user = Supervisor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'merchant':
            user = Merchant.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'super_admin':
            user = SuperAdmin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user['role'] == 'admin':
            user = Admin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        if user:
            if user.check_password(data['password']):

                changes = []
                if verified==False:
                    otp_sms_data = {
                        'role': user.role,
                        'phone': user.phone,
                        'email': user.email,
                    }
                    status, sms_otp, email_otp = generateOTPsms(data=otp_sms_data, template_type=['email'])

                    if status:
                        notification_data = {
                            'template_name': 'enter_otp_to',
                            'role': str.capitalize(user.role),
                            'otp_email': email_otp,
                            'action': f'update your {user.role} proile email'
                        }
                        notification = Process(
                            target=CreateNotification.gen_notification_v2(user_obj=user,data=notification_data, template_type=['email']),
                            daemon=True
                        )

                        notification.start()
                        

                    apiResponce = ApiResponse(True, 'Verify Email Otp to update profile changes'
                                    , None, None)

                    return (apiResponce.__dict__), 200
                else:       
                    if not user.email == data['email']:
                        user.email = data['email']
                        changes.append("email")
                        notification_data_2={
                            'template_name': 'change_profile_email',
                            'role': str.capitalize(user.role),
                            'property': 'Email',
                            'value': data['email']
                        }
                        notification = Process(
                            target=CreateNotification.gen_notification_v2(user_obj=user, data=notification_data_2),
                            daemon=True
                        )

                        notification.start()

                    save_db(user)
                    
                    apiResponce = ApiResponse(True, 'Profile Details Updated Successfully'
                                    , None, None)

                    return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Password Does not Matched', None,
                            None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'User Not Found', None,
                            None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

def update_name(data):
    """
    Updates the name of the user account based on login token and function parameters
    
    Parameters: json data
    Return type: __dict__, int
    """
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'supervisor':
            user = Supervisor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'merchant':
            user = Merchant.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'super_admin':
            user = SuperAdmin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'admin':
            user = Admin.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'distributor':
            user = Distributor.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()

        elif user['role'] == 'delivery_associate':
            user = DeliveryAssociate.query.filter_by(id = user['id']).filter_by(deleted_at = None).first()

        if user:
            if user.check_password(data['password']):

                if not user.name == data['name']:

                    user.name = data['name']

                    notification_data_1={
                        'template_name': 'change_profile_details',
                        'role': str.capitalize(user.role),
                        'property': 'Name',
                        'value': data['name']
                    }
                    CreateNotification.gen_notification_v2(user_obj=user, data=notification_data_1)

                save_db(user)
                
                apiResponce = ApiResponse(True, 'Profile Details Updated Successfully'
                                  , None, None)

                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Password Does not Matched', None,
                            None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'User Not Found', None,
                            None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

def create_super_admin(data):
    try:
        if data['master_password'] != master_pass:
            apiresponse =  ApiResponse(False, "Master Pasworder Not Matched")
            return apiresponse.__dict__, 400
            
        user = SuperAdmin.query.filter_by(email=data['email']).first()
        user_phone = SuperAdmin.query.filter_by(phone=data['phone']).first()
        if not user_phone:

            if not user:
                new_user = SuperAdmin(email=data['email'],
                                name=data['name'],
                                password=data['password'],
                                image = profile_pic_dir+"default.png",
                                phone=data['phone'],
                                created_at=datetime.datetime.utcnow())
                
                save_db(new_user)   
                
                apiresponse = ApiResponse(True, "SuperAdmin Created")
                return apiresponse.__dict__ , 200        

            else:
                response_object = {
                    'success': False,
                    'message': 'User already exists. Please Log in.',
                    'data': None,
                    'error': 'mail id already registered',
                }
                return response_object, 409
        else:
            response_object = {
                'success': False,
                'message': 'phone number already exists.',
                'data': None,
                'error': 'phone number should be unique',
            }
            return response_object, 406
    
    except Exception as e:
        response_object = {
            'success': False,
            'message': 'Internal Server Error',
            'data': None,
            'error': str(e),
        }
        return response_object, 500
    
    
def create_template(data):
    try:

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        if user['role'] == 'super_admin':
            ran = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))
            temp_id = str(ran)
            if data['t_type'] not in ['sms','email']:
                error = ApiResponse(False, "template name should be in [email,sms]", None,
                                    None)
                return (error.__dict__), 400
            notification_temp = NotificationTemplates.query.filter_by(name=data['name']).filter_by(deleted_at = None).first()
            if notification_temp:
                error = ApiResponse(False, f"template name {data['name']} already exist", None,
                                    None)
                return (error.__dict__), 400


            notification_template = NotificationTemplates(
                dlt_template_id= temp_id,
                template = data['template'],
                name = data['name'],
                t_type = data['t_type'],
                created_at= datetime.datetime.utcnow()
            )
            save_db(notification_template,"NotificationTemplates")
            
            apiResponce = ApiResponse(True, 'template created Successfully'
                                      , None, None)
            return (apiResponce.__dict__), 200
        else:
            error = ApiResponse(False, 'you need super admin access', None,
                                None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500