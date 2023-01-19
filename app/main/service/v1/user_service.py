from flask.templating import render_template
from app.main.config import ENDPOINT_PREFIX, profile_pic_dir
from flask.helpers import url_for
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.service.v1.sms import send_confirmation_otp
from app.main.util.v1.database import save_db
from app.main.model.superAdmin import SuperAdmin
from flask import request
import uuid
import datetime
from app.main.service.v1.email import confirm_token, send_confirmation_email, send_email
from app.main import db
from app.main.service.v1.fileupload_ import *
from app.main.model.user import User
from app.main.model.admin import Admin
from app.main.model.supervisor import Supervisor
from app.main.model.userCities import UserCities
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import or_, func
from app.main.util.v1.decorator import *
from smtplib import SMTPAuthenticationError

# import logging
# import os
#
# logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
# log_dir = "logs"
# os.makedirs(log_dir, exist_ok=True)
# logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
#                     filemode="a")

def save_new_user(data):
    try:
        user = User.query.filter_by(email=data['email']).first()
        user_phone = User.query.filter_by(phone=data['phone']).first()
        if not user_phone:

            if not user:
                new_user = User(email=data['email'],
                                name=data['name'],
                                password=data['password'],
                                image = profile_pic_dir+"default.png",
                                phone=data['phone'],
                                created_at=datetime.datetime.utcnow())
                
                
                if save_changes(new_user):
                    if send_confirmation_otp(new_user.phone, new_user.role):
                        return generate_token(new_user)
                        

                                           
                    else:
                        response_object = {
                        'success': False,
                        'message': 'User Account Creation Failed',
                        'data': None,
                        'error': "OTP Generation Error",
                        }
                        return response_object, 500

                else:
                    response_object = {
                        'success': False,
                        'message': 'User Account Creation Failed',
                        'data': None,
                        'error': 'Database Error',
                        }
                    return response_object, 500
                

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
    except SMTPAuthenticationError as e:
        response_object = {
            'success': False,
            'message': 'Mail Server did not respond',
            'data': None,
            'error': str(e),
        }
        return response_object, 401
    except Exception as e:
        response_object = {
            'success': False,
            'message': 'Internal Server Error',
            'data': None,
            'error': str(e),
        }
        return response_object, 500


def get_profile():
    # result=[]
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = resp['data']['role']
        portal_role_map = {
         'customer': User,
         'merchant': Merchant,
         'supervisor': Supervisor,
         'distributor': Distributor,
         'delivery_associate': DeliveryAssociate,
         'admin': Admin,
         'super_admin': SuperAdmin
      }
        get_user = portal_role_map[role].query.filter_by(email=user['email']).first()
        if get_user:
            response_object = {
                'name': get_user.name,
                'email': get_user.email,
                'image': get_user.image,
                'role': get_user.role,
                'active': get_user.active,
                'phone': get_user.phone
            }
        # result.append(response_object)
            apiResponce = ApiResponse(True, f'Get {str.capitalize(role)} Profile successfully',
                                      response_object, None)
            return (apiResponce.__dict__), 200
        else:
            apiResponce = ApiResponse(
                False, f'{str.capitalize(role)} not Found', None, f'User{str.capitalize(role)} is not present in {str.capitalize(role)} table')
            return (apiResponce.__dict__), 404
    except Exception as e:
        # response_object = {
        #     'success': 'fail',
        #     'message': 'Some error occurred. Please try again.'
        # }
        apiResponce = ApiResponse(
            False, 'Some error occurred. Please try again.', None, str(e))
        return (apiResponce.__dict__), 500

# token_required()


def update_profile(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        update_user = User.query.filter_by(email=user['email']).first()

        phone = data['phone']

        if not len(phone) == 10:
            apiResponce = ApiResponse(
                False, 'Profile Not Updated', None, 'Phone number must be 10 digits')
            return (apiResponce.__dict__), 400

        if update_user:
            update_user.update_to_db(data)

            # update_user.name=data['name']
            # update_user.password=data['password']
            # update_user.phone=data['phone']
            # update_user.updated_at = datetime.datetime.utcnow()
            db.session.commit()
            # response_object = {
            #     'success': 'success',
            #     'message': 'Successfully Updated.',
            # }
            apiResponce = ApiResponse(True, 'Successfully Updated', '', None)
            return (apiResponce.__dict__), 201
        else:
            error = ApiResponse(False, 'User does not Exist', None, "")
            return (error.__dict__), 401
        # else:
        #     error = ApiResponse(False, 'User is not Authorized', None,
        #                         "Token error")
        #     return (error.__dict__), 500
    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__, 500


def update_name(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        update_user = User.query.filter_by(id=user['id']).first()

        update_user.name = data['name']

        save_db(update_user, "User")
        

        apiResponce = ApiResponse(
            True, 'User Name Successfully Updated', '', None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__, 500


# @classmethod
# def put(self, id: int):

#     item = ItemModel.find_by_id(id)

#     if(item):
#         try:
#             item.update_to_db(
#                 request.get_json()
#             )
#         except ValidationError as err:
#             return err.messages, HTTPStatus.BAD_REQUEST

#         return {'message': item_schema.dump(item)}, HTTPStatus.OK

#     return {'message': gettext('item_not_found')}, HTTPStatus.NOT_FOUND


def get_userby_email(email):
    return User.query.filter_by(email=email).first()


def get_a_user():
    pass


def save_changes(data):
    db.session.add(data)
    db.session.commit()

    return True


def generate_token(user):
    try:
        # generate the auth token
        auth_token = user.encode_auth_token(user.id)
        response_object = {'Authorization': auth_token}
        apiResponce = ApiResponse(True, 'Successfully registered',
                                  response_object, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        response_object = {
            'success': False,
            'message': 'Error in token  generation  Please try again.',
            'data': None,
            'error': str(e)
        }
        return response_object, 401


def validate_email(email: str):
    try:
        address = email.split("@")[0]
        domain = email.split("@")[1]
        service = domain.split(".")[0]
        suffix = domain.split(".")[1]
        return True
    except Exception:
        return False


def create_user_by_super_admin(data):
    try:
        if not validate_email(data['email']):
            error = ApiResponse(False, 'User not created',
                                None, 'Email is not valid.')
            return error.__dict__, 400

        if (data['user_role'] == 'admin'):
            user = Admin.query.filter_by(email=data['email']).first()
            user_phone = Admin.query.filter_by(phone=data['phone']).first()
            if not user_phone:

                if not user:
                    try:
                        new_user = Admin(email=data['email'],
                                         name=data['name'],
                                         password='password_' + data['phone'],
                                         image = profile_pic_dir+"default.png",
                                         phone=data['phone'],
                                         role='admin',
                                         created_at=datetime.datetime.now())
                        save_changes(new_user)

                        user = Admin.query.filter_by(
                            email=data['email']).first()

                        response_object = {
                            'id': user.id,
                            'email': user.email,
                            'name': user.name,
                            'image' : user.image,
                            'phone': user.phone,
                            'role': user.role,
                            'created_at': str(user.created_at)
                        }
                        return ApiResponse(True, "User Successfully Created!", response_object, None).__dict__, 201
                    except Exception as e:
                        error = ApiResponse(False, 'User Not able to Create',
                                            None, str(e))
                        return (error.__dict__), 500

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

        # create supervisor user
        elif (data['user_role'] == 'supervisor'):
            user = Supervisor.query.filter_by(email=data['email']).first()
            user_phone = Supervisor.query.filter_by(
                phone=data['phone']).filter_by(deleted_at=None).first()
            if not user_phone:

                if not user:
                    try:
                        new_user = Supervisor(
                            email=data['email'],
                            name=data['name'],
                            password='password_' + data['phone'],
                            image = profile_pic_dir+"default.png",
                            phone=data['phone'],
                            role='supervisor',
                            created_at=datetime.datetime.utcnow())
                        db.session.add(new_user)
                        db.session.commit()

                        user = Supervisor.query.filter_by(
                            email=data['email']).first()

                        response_data = {
                            'id': user.id,
                            'email': user.email,
                            'name': user.name,
                            'image':user.image,
                            'phone': user.phone,
                            'role': user.role,
                            'created_at': str(user.created_at)
                        }

                        for record in data['city_id']:

                            user_city_map = UserCities(
                                city_id=record,
                                user_id=new_user.id,
                                role="supervisor",
                                created_at=datetime.datetime.utcnow())
                            db.session.add(user_city_map)
                            db.session.commit()

                        response_object = {
                            'success': True,
                            'message': 'Successfully registered.',
                            'data': response_data,
                            'error': None,
                        }
                        return response_object, 200
                    except Exception as e:
                        db.session.rollback()
                        error = ApiResponse(False, 'User Not able to Create',
                                            None, str(e))
                        return (error.__dict__), 500

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
        
        #create distributor
        elif data['user_role'] == 'distributor':
            user = Distributor.query.filter_by(email=data['email']).first()
            user_phone = Distributor.query.filter_by(
                phone=data['phone']).first()
            if not user_phone:

                if not user:
                    try:
                        if len(data['phone']) != 10:
                            response_object = {
                                'success': False,
                                'message': 'Phone number must be 10 digits',
                                'data': None,
                                'error': None,
                            }
                            return response_object, 409
                            
                        new_user = Distributor(
                            email=data['email'],
                            name=data['name'],
                            password='password_' + data['phone'],
                            image = profile_pic_dir+"default.png",
                            phone=data['phone'],
                            role='distributor',
                            created_at=datetime.datetime.utcnow())
                        
                        error =  save_db(new_user, "Distributor")
                        if error:
                            return error, 500

                        user = Distributor.query.filter_by(
                            email=data['email']).first()

                        response_data = {
                            'id': user.id,
                            'email': user.email,
                            'name': user.name,
                            'image':user.image,
                            'phone': user.phone,
                            'role': user.role,
                            'created_at': str(user.created_at)
                        }

                        response_object = {
                            'success': True,
                            'message': 'Successfully registered.',
                            'data': response_data,
                            'error': None,
                        }
                        return response_object, 200
                    except Exception as e:
                        db.session.rollback()
                        error = ApiResponse(False, 'User Not able to Create',
                                            None, str(e))
                        return (error.__dict__), 500

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
        # user not specified
        else:
            response_object = {
                'success': False,
                'message': 'User not specified',
                'data': None,
                'error': None,
            }
            return response_object, 409

    except Exception as e:
        response_object = {
            'success': False,
            'message': 'Internal Server Error',
            'data': None,
            'error': str(e),
        }
        return response_object, 500


def fetch_user_data_by_id(data):

    try:
        recordObject = []

        if (data['user_role'] == 'supervisor'):
            records = Supervisor.query.filter(
                Supervisor.deleted_at == None,
                Supervisor.id == data['user_id']).all()

        elif (data['user_role'] == 'admin'):
            records = Admin.query.filter(
                Admin.deleted_at == None,
                Admin.id == data['user_id']).all()

        elif (data['user_role'] == 'super_admin'):
            records = SuperAdmin.query.filter(
                SuperAdmin.deleted_at == None,
                SuperAdmin.id == data['user_id']).all()

        elif (data['user_role'] == 'merchant'):

            records = Merchant.query.filter(
                Merchant.deleted_at == None,
                Merchant.id == data['user_id']).all()


        elif (data['user_role'] == 'distributor'):

            records = Distributor.query.filter(
                Distributor.deleted_at == None,
                Distributor.id == data['user_id']).all()
            
        elif (data['user_role'] == 'delivery_associate'):

            records = DeliveryAssociate.query.filter(
                DeliveryAssociate.deleted_at == None,
                DeliveryAssociate.id == data['user_id']).all()

        if records:
            for record in records:
                response = {
                    'id': record.id,
                    'email': record.email,
                    'name': record.name,
                    'active': record.active,
                    'image': record.image,
                    'phone': record.phone,
                    'role': record.role,
                    'email_verified_at': str(record.email_verified_at),
                    'phone_verified_at': str(record.phone_verified_at),
                }
                recordObject.append(response)

            apiResponce = ApiResponse(True,
                                        'User Details Fetched Successfully',
                                        recordObject, None)
            return (apiResponce.__dict__), 200

        else:
            error = ApiResponse(False, 'User data is not Available', None,
                                None)
            return (error.__dict__), 500
        

    except Exception as e:
        db.session.rollback()
        error = ApiResponse(False, 'Users Not able to Fetch', None, str(e))
        return (error.__dict__), 500


def fetch_store_users(data):

    try:
        page = 1
        items_per_page = 10
        filter = data['filter']
        search = None
        try:
            page = int(data['page'])
        except Exception as e:
            pass

        try:
            items_per_page = int(data['items'])
        except Exception as e:
            pass

        try:
            search = f"%{data['search']}%"
            if len(search) < 2 :
                search = None
        except Exception as e:
            pass

        if filter not in ['super_admin', 'merchant', 'supervisor', 'admin', 'distributor']:
            apiresponse = ApiResponse(
                False, "Wrong User Code", None, None)
            return apiresponse.__dict__, 400

        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        recordObject = []

        if filter == "super_admin":
            if search:
                records = SuperAdmin.query.filter(func.lower(SuperAdmin.name).like(func.lower(search)) ).filter(
                    SuperAdmin.deleted_at == None).order_by(SuperAdmin.name).paginate(page, items_per_page, False)
            else:
                records = SuperAdmin.query.filter(
                    SuperAdmin.deleted_at == None).order_by(SuperAdmin.name).paginate(page, items_per_page, False)
        
        elif filter == "admin":
            if search:
                records = Admin.query.filter(func.lower(Admin.name).like(func.lower(search)) ).filter(
                    Admin.deleted_at == None).order_by(Admin.name).paginate(page, items_per_page, False)
            else:
                records = Admin.query.filter(
                    Admin.deleted_at == None).order_by(Admin.name).paginate(page, items_per_page, False)

        elif filter == "supervisor":
            if search:
                records = Supervisor.query.filter(func.lower(Supervisor.name).like(func.lower(search)) ).filter(
                    Supervisor.deleted_at == None).order_by(Supervisor.name).paginate(page, items_per_page, False)
            else:
                records = Supervisor.query.filter(
                    Supervisor.deleted_at == None).order_by(Supervisor.name).paginate(page, items_per_page, False)

        elif filter == "merchant":
            if search:
                records = Merchant.query.filter(func.lower(Merchant.name).like(func.lower(search)) ).filter(
                    Merchant.deleted_at == None).order_by(Merchant.name).paginate(page, items_per_page, False)
            else:
                records = Merchant.query.filter(
                    Merchant.deleted_at == None).order_by(Merchant.name).paginate(page, items_per_page, False)
        
        elif filter == "distributor":
            if search:
                records = Distributor.query.filter(func.lower(Distributor.name).like(func.lower(search)) ).filter(
                    Distributor.deleted_at == None).order_by(Distributor.name).paginate(page, items_per_page, False)
            else:
                records = Distributor.query.filter(
                    Distributor.deleted_at == None).order_by(Distributor.name).paginate(page, items_per_page, False)
                
        elif filter == "delivery_associate":
            if search:
                records = DeliveryAssociate.query.filter(func.lower(DeliveryAssociate.name).like(func.lower(search)) ).filter(
                    DeliveryAssociate.deleted_at == None).order_by(DeliveryAssociate.name).paginate(page, items_per_page, False)
            else:
                records = DeliveryAssociate.query.filter(
                    DeliveryAssociate.deleted_at == None).order_by(DeliveryAssociate.name).paginate(page, items_per_page, False)

        for record in records.items:
            response = {
                'id': record.id,
                'email': record.email,
                'name': record.name,
                'image': record.image,
                'active': record.active,
                'phone': record.phone,
                'role': record.role,
                'email_verified_at': str(record.email_verified_at),
                'phone_verified_at': str(record.phone_verified_at),
            }
            recordObject.append(response)
        
        return_obj = {
            'page': records.page,
            'total_pages': records.pages,
            'has_next_page': records.has_next,
            'has_prev_page': records.has_prev,
            'prev_page': records.prev_num,
            'next_page': records.next_num,
            'items_per_page': records.per_page,
            'items_current_page': len(records.items),
            'total_items': records.total,
            'items': recordObject
        }

        apiResponce = ApiResponse(True, 'List of All Users', return_obj,
                                    None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        db.session.rollback()
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500
