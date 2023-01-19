import datetime
import hashlib
from flask import request
from sqlalchemy.engine.interfaces import ExceptionContext
from sqlalchemy.sql.functions import AnsiFunction
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.user import User
from app.main.model.superAdmin import SuperAdmin
from app.main.model.admin import Admin
from app.main.model.merchant import Merchant
from app.main.model.supervisor import Supervisor
from ... import flask_bcrypt
from ...model.session import Session
from .blacklist_service import save_token
from app.main.service.v1.email import confirm_token, send_confirmation_email, send_email,send_confirmation_email_forget_password
from typing import Dict, Tuple
# user.active==True and
from app.main.model.apiResponse import ApiResponse
from ...util.v1.database import save_db

import logging
import os

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/auth_helper/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")
class Auth:

    user_class = {
        'customer' : User,
        'merchant' : Merchant,
        'supervisor' : Supervisor,
        'super_admin' : SuperAdmin,
        'distributor' : Distributor,
        'delivery_associate' : DeliveryAssociate,
        'admin' : Admin
    }
    
    @staticmethod
    def get_user(id , role):
        user = Auth.user_class[role].query.filter_by(id = id).first()
        
        return user
    
    @staticmethod
    def login_user(data: Dict[str, str]) -> Tuple[Dict[str, str], int]:
        try:
            # fetch the user data
            user = User.query.filter_by(email=data.get('email')).first()
            # print(user.active,"kjefbjebf")
            # result=[]
            if user:
                if  user.check_password(data.get('password')):
                    auth_token = user.encode_auth_token(user.id)
                    # print(auth_token)
                    if auth_token:
                        response_object = {
                            'Authorization': auth_token,
                            'id':user.id,
                            'email':user.email,
                            'phone':user.phone,
                            'name':user.name,
                            'role':user.role,
                            # 'active':user.active
                        }
                        session = Session(user_id=user.id,session_start_time=datetime.datetime.utcnow(),auth_token=auth_token,os=str(request.headers.get("User-Agent")))
                        save_db(session,"session")
                        

                        apiResponce = ApiResponse(True,
                                        'User login successfully',
                                        response_object,None)
                        return  (apiResponce.__dict__), 200
                else:
                    apiResponce = ApiResponse(False,
                                        'user password does not match or account not active',None
                                ,'user password does not match')
                    return  (apiResponce.__dict__), 403
            else:
                apiResponce = ApiResponse(False,
                                        'user email  does not match',None
                                ,'user email does not match')
                return  (apiResponce.__dict__), 403

        except Exception as e:
            print(e,"<<=====")
            error = ApiResponse(
                False, 'Try again', None,
                str(e.with_traceback(None)) +  "---" + __file__
            )
            return (error.__dict__), 500

    @staticmethod
    def logout_user(data: str) -> Tuple[Dict[str, str], int]:
        logging.info("logging out")
        try:
            if data:

                auth_token = data
            else:
                auth_token = ''

            if auth_token:
                user, status = Auth.get_logged_in_user(request)


                resp = User.decode_auth_token(auth_token)

                if not isinstance(resp, str):
                    # mark the token as blacklisted
                    res,status = save_token(token=auth_token)
                    if res['success']== True and user['data']['role']=='customer':
                        hash_file_name = hashlib.sha256(bytes(auth_token,'utf-8'))
                        auth_token_hash = hash_file_name.hexdigest()
                        session = Session.query.filter_by(auth_token_hash=auth_token_hash).filter_by(user_id=user['data']['id']).first()
                        session.session_end_time=datetime.datetime.utcnow()
                        save_db(session,"session")
                        

                    return res,status
                else:
                    response_object = {
                        'success': False,
                        'message': resp,
                        'data':None,
                        'error':None
                    }
                    return response_object, 401
            else:
                response_object = {
                    'success': False,
                    'message': 'Provide a valid auth token.',
                    'data':None,
                    'error':'valid auth_token error'
                }
                return response_object, 401
        except Exception as e:
            response_object = {
                    'success': False,
                    'message': 'Internal Server Error',
                    'data':None,
                    'error':str(e)
                }
            return response_object, 500


    @staticmethod
    def get_logged_in_user(new_request):
        # get the auth token
        try:
            auth_token = new_request.headers.get('Authorization')
            if auth_token:
                # decoding the auth token 
                resp = User.decode_auth_token(auth_token)
                #print(resp)
                role='role'
                if not isinstance(resp, str):
                    if not role in resp:
                        # if the user is a end user 
                        user = User.query.filter_by(id=resp['sub']).first()
                        #return users
                    else:
                        # if the user is superadmin
                        if resp['role'] == 'super_admin':
                            user = SuperAdmin.query.filter_by(id=resp['sub']).first()
                            
                        elif resp['role'] == 'admin':
                            user = Admin.query.filter_by(id=resp['sub']).first()
                    
                        elif resp['role'] == 'merchant':
                            user = Merchant.query.filter_by(id=resp['sub']).first()
                            
                        elif resp['role'] == 'supervisor':
                            user = Supervisor.query.filter_by(id=resp['sub']).first()
                        
                        elif resp['role'] == 'distributor':
                            user = Distributor.query.filter_by(id=resp['sub']).first()
                        
                        elif resp['role'] == 'delivery_associate':
                            user = DeliveryAssociate.query.filter_by(id=resp['sub']).first()
                        
                        else:
                            response =  ApiResponse(True, f"User with role {resp['role']} not found",None,None)
                            return response.__dict__, 200
                
                    data = {
                        'id': user.id,
                        'name': user.name,
                        'email' : user.email,
                        'phone' : user.phone,
                        'role': user.role,
                        }
                        
                    response =  ApiResponse(True, 'Logged in User Found',data,None)
                    return response.__dict__, 200
                
                else:
                    print(resp)
                    response_object = {
                        'success': False,
                        'message': resp,
                        'data' : None,
                        'error' : resp
                    }
                    return response_object, 403
            
            else:
                response_object = {
                    'success': False,
                    'message': 'Unauthorized Request',
                    'data' : None,
                    'error' : 'Provide a valid authtoken'
                }
                return response_object, 401

        except Exception as e:
            error = ApiResponse(False, "Internal Server Error", None, str(e))
            return error.__dict__ , 500

    @staticmethod
    def get_logged_objects_response(new_request):
        try:
            # get the auth token
            auth_token = new_request.headers.get('Authorization')
            if auth_token:
                resp = User.decode_auth_token(auth_token)
                if not isinstance(resp, str):
                    user = User.query.filter_by(id=resp).first()
                    response_object = {
                        'success': 'success',
                        'data': {
                            'user_id': user.id,
                            # 'email': user.email,
                            # 'admin': user.admin,
                            # 'registered_on': str(user.registered_on)
                        }
                    }
                    return response_object, 200
                response_object = {
                    'success': 'fail',
                    'message': resp
                }
                return response_object, 401
            else:
                response_object = {
                    'success': 'fail',
                    'message': 'Provide a valid auth token.'
                }
                return response_object, 401
        except Exception as e:
            response_object = {
                    'success': False,
                    'message': 'Internal Server Error',
                    'data': None,
                    'error': str(e)
                }
            return response_object, 500


    @staticmethod
    def login_super_admin(data):
        print()
        try:
            # fetch the user data
            superAdmin = SuperAdmin.query.filter_by(email=data.get('email')).first()
            if superAdmin and superAdmin.check_password(data.get('password')):
                
                auth_token = superAdmin.encode_auth_token(superAdmin.id,superAdmin.role)
                
                # print(auth_token)
                
                if auth_token:
                    response_object = {
                        # 'success': 'success',
                        # 'message': 'Super Admin Successfully logged in.',
                        'Authorization': auth_token,
                        'id':superAdmin.id,
                        'email':superAdmin.email,
                        'image':superAdmin.image,
                        'phone':superAdmin.phone,
                        'role': superAdmin.role,
                        'name':superAdmin.name
                    }
                    print(response_object)
                    apiResponce = ApiResponse(True,
                                    'Super Admin login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                    
                    # return response_object, 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'superadmin email or password does not match',None
                            ,'superadmin email or password does not match')
                return  apiResponce.__dict__, 401

        except Exception as e:
            error = ApiResponse(
                False, 'Error Occurred', None,
                str(e)
            )
            return error.__dict__, 500
        
    @staticmethod
    def login_admin(data):
        
        try:
            #fetch the user data
            admin = Admin.query.filter_by(email=data.get('email')).first()
            print(admin)
            if admin and admin.check_password(data.get('password')):
                
                auth_token = admin.encode_auth_token(admin.id,admin.role)
                if auth_token:
                    response_object = {
                        'Authorization': auth_token,
                        'id':admin.id,
                        'image':admin.image,
                        'email':admin.email,
                        'phone':admin.phone,
                        'role': admin.role
                    }
                    
                    apiResponce = ApiResponse(True,
                                    ' Admin login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'admin email or password does not match',None
                            ,'admin email or password does not match')
                return  (apiResponce.__dict__), 401

        except Exception as e:
            error = ApiResponse(
                False, 'Try again', None,
                str(e)
            )
            return (error.__dict__), 500

    @staticmethod
    def login_supervisor(data):
        
        try:
            # fetch the user data
            supervisor = Supervisor.query.filter_by(email=data.get('email')).first()
            print(supervisor)
            if supervisor and supervisor.check_password(data.get('password')):
                
                auth_token = supervisor.encode_auth_token(supervisor.id,supervisor.role)
                if auth_token:
                    response_object = {
                        'Authorization': auth_token,
                        'name':supervisor.name,
                        'image':supervisor.image,
                        'id':supervisor.id,
                        'email':supervisor.email,
                        'phone':supervisor.phone,
                        'role': supervisor.role
                    }
                    
                    apiResponce = ApiResponse(True,
                                    ' Supervisor login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'supervisor email or password does not match',None
                            ,'supervisor email or password does not match')
                return  (apiResponce.__dict__), 401

        except Exception as e:
            error = ApiResponse(
                False, 'Try again', None,
                str(e)
            )
            return (error.__dict__), 500
    
    
    @staticmethod
    def login_merchant(data):
        
        try:
            # fetch the user data
            merchant = Merchant.query.filter_by(email=data.get('email')).first()
            
            if merchant and merchant.check_password(data.get('password')):
                
                auth_token = merchant.encode_auth_token(merchant.id,merchant.role)
                if auth_token:
                    response_object = {
                        # 'success': 'success',
                        # 'message': 'Merchant Successfully logged in.',
                        'Authorization': auth_token,
                        'id':merchant.id,
                        'image':merchant.image,
                        'email':merchant.email,
                        'phone':merchant.phone,
                        'role': merchant.role,
                        'name':merchant.name
                    }
                    apiResponce = ApiResponse(True,
                                    'Merchant login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                    
                    # return response_object, 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'merchant email or password does not match',None
                            ,'merchant email or password does not match')
                return  (apiResponce.__dict__), 401

        except Exception as e:
            error = ApiResponse(
                False, 'Try again', None,
                "Error in Authorization " + str(e)
            )
            return (error.__dict__), 500

    @staticmethod
    def login_distributor(data):
        
        try:
            # fetch the user data
            distributor = Distributor.query.filter_by(email=data.get('email')).first()
            
            if distributor and distributor.check_password(data.get('password')):
                
                auth_token = distributor.encode_auth_token(distributor.id,distributor.role)
                if auth_token:
                    response_object = {
                        # 'success': 'success',
                        # 'message': 'Merchant Successfully logged in.',
                        'Authorization': auth_token,
                        'id':distributor.id,
                        'image':distributor.image,
                        'email':distributor.email,
                        'phone':distributor.phone,
                        'role': distributor.role,
                        'name':distributor.name
                    }
                    apiResponce = ApiResponse(True,
                                    'Distributor login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                    
                    # return response_object, 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'Distributor email or password does not match',None
                            ,'Distributor email or password does not match')
                return  (apiResponce.__dict__), 401

        except Exception as e:
            error = ApiResponse(
                False, 'Try again', None,
                "Error in Authorization " + str(e)
            )
            return (error.__dict__), 500

    @staticmethod
    def login_delivery_associate(data):
        
        try:
            # fetch the user data
            delivery_associate = DeliveryAssociate.query.filter_by(email=data.get('email')).first()
            
            if delivery_associate and delivery_associate.check_password(data.get('password')):
                
                auth_token = delivery_associate.encode_auth_token(delivery_associate.id,delivery_associate.role)
                if auth_token:
                    response_object = {
                        # 'success': 'success',
                        # 'message': 'Merchant Successfully logged in.',
                        'Authorization': auth_token,
                        'id':delivery_associate.id,
                        'image':delivery_associate.image,
                        'email':delivery_associate.email,
                        'phone':delivery_associate.phone,
                        'role': delivery_associate.role,
                        'name':delivery_associate.name
                    }
                    apiResponce = ApiResponse(True,
                                    'Delivery Associate login successfully',
                                    response_object,None)
                    return  (apiResponce.__dict__), 200
                    
                    # return response_object, 200
                
            else:
                apiResponce = ApiResponse(False,
                                    'Delivery Associate email or password does not match',None
                            ,'Delivery Associate email or password does not match')
                return  (apiResponce.__dict__), 401

        except Exception as e:
            error = ApiResponse(
                False, 'Try again', None,
                "Error in Authorization " + str(e)
            )
            return (error.__dict__), 500

    @staticmethod
    def get_logged_in_merchant(new_request):
        try:
            # get the auth token
            auth_token = new_request.headers.get('Authorization')
            if auth_token:
                # decoding the auth token 
                resp = Merchant.decode_auth_token(auth_token)
                role='role'
                if not isinstance(resp['sub'], str):
                    if not role in resp:
                        # if the merchant is a end user 
                        merchant = Merchant.query.filter_by(id=resp['sub']).first()
                        return merchant
                    else:
                        # if the user is superadmin
                        if resp['role'] == 'super_admin':
                            user = SuperAdmin.query.filter_by(id=resp['sub']).first()
                            return user
                        if resp['role'] == 'admin':
                            user = Admin.query.filter_by(id=resp['sub']).first()
                            return user

                        if resp['role'] == 'merchant':
                            user = Merchant.query.filter_by(id=resp['sub']).first()
                            return user
                        
                response_object = {
                    'success': 'fail',
                    'message': resp
                }
                return response_object, 401
            else:
                response_object = {
                    'success': 'fail',
                    'message': 'Provide a valid auth token.'
                }
                return response_object, 401
        except Exception as  e:
            response_object = {
                    'success': False,
                    'message': 'Internal Server Error',
                    'data': None,
                    'error': str(e)
                }
            return response_object, 500

    @staticmethod
    def forgetPassword(data):
        print(data['user_email'],"<<<---")

        try:
            if data['login_request'].lower()=='user':
                user = User.query.filter_by(email=data['user_email']).first()
            elif data['login_request'].lower()=='merchant':
                user = Merchant.query.filter_by(email=data['user_email']).first()
            # elif data['login_request']=='Superadmin'
            #     user=Supervisor.query.filter_by(email=data['user_email'].first())
            elif data['login_request'].lower()=='supervisor':
                user=Supervisor.query.filter_by(email=data['user_email']).first()
            else:
                apiResponce = ApiResponse(False, 'User Does not Exist', None, None)
                return (apiResponce.__dict__), 400

            if user:
                send_confirmation_email_forget_password(user.email,data['login_request'])
            response_object = {
                'success': True,
                'message': 'Email Send',
                'data': None,
                'error': None
            }
            return response_object, 200

        except Exception as e:
            error = ApiResponse(False, 'Email Does Not Exist', None, str(e))
            return (error.__dict__), 400







          
