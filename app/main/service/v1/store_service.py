from email import message
import threading
from uuid import uuid4

from werkzeug.utils import secure_filename
from app.main.model.deliveryAgent import DeliveryAgent
from app.main.model.storeMis import StoreMis
from app.main.model.store_bankdetails import StoreBankDetails
from app.main.model.superAdmin import SuperAdmin
from app.main.model.supervisor import Supervisor
from app.main.service.v1.notification_service import CreateNotification, generate_data, save_changes
from app.main.util.v1.dateutil import date_to_str, daterange, if_date_time, if_time, store_open_status, str_to_date, str_to_datetime, str_to_time, time_to_str
from flask import current_app,url_for
from sqlalchemy.ext.declarative import api
from app.main import config
from app.main.service.v1.image_service import image_save, image_upload
from app.main.service.v1.fileupload_ import check_file
from app.main.model.storeTaxes import StoreTaxes
from app.main.model import apiResponse
from app.main.model.city import City
from six import int2byte
from app.main.model import menuCategory
from app.main.util.v1.database import save_db
from operator import indexOf
from app.main.model.menuCategory import MenuCategory
from sqlalchemy.sql.expression import join
from app.main.model import merchant
from app.main.model import storeMerchant
from app.main.model import store
from app.main.model.merchant import Merchant
import datetime
import json
from app.main import db
from app.main.model.store import Store
from app.main.model.category import Category
from app.main.model.storeCategory import StoreCategory
from app.main.model.storeMenuCategory import StoreMenuCategory
from sqlalchemy import sql, text, func
from haversine import haversine, Unit
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.config import ENDPOINT_PREFIX, store_dir, profile_pic_dir
from sqlalchemy import func
from app.main.model.userAddress import UserAddress
from app.main.model.userCities import UserCities
from sqlalchemy import or_

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/store_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def approve_store(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        store_id = data['store_id']
        
        store = Store.query.filter_by(id=store_id).first()
        
        if not store:
            error = ApiResponse(False, 'Store not found!', None, 'The store is either approved or deleted')
            return error.__dict__, 400
        
        if user['role'] == 'supervisor':
            supervisor_city = UserCities.query.filter_by(user_id = user['id']).filter_by(city_id = store.city_id).filter_by(deleted_at = None).first()
        
            if not supervisor_city:
                error = ApiResponse(False, 'Supervisor has no access to approve this Store', None, None)
                return (error.__dict__), 400
        
        if store.approved_at != None and store.deleted_at == None:
            return ApiResponse(False, 'Store is Allready Approved').__dict__, 400
        
        if store.approved_at == None and store.deleted_at != None:
            return ApiResponse(False, 'Store is Allready Rejected').__dict__, 400
        
        if store.deleted_at != None:
            return ApiResponse(False, 'Store is Deleted Allready').__dict__, 400
        
        
        if data['approve'] == 0:
            store.approved_by_id = user['id']
            store.approved_by_role = user['role']
            store.deleted_at = datetime.datetime.utcnow()
            store.status = 0
            message = f"{store.name} Store Rejected Successfuly"
        
        elif data['approve'] == 1:
            if store.commission == None or store.walkin_order_commission == None:
                return ApiResponse(False, 'Enter Store Commission to Approve the Store').__dict__, 400
            store.approved_at = datetime.datetime.utcnow()
            store.approved_by_id = user['id']
            store.approved_by_role = user['role']
            store.status = 1
            message = f"{store.name} Store Approved Successfuly"
            
        else:
            return ApiResponse(False, 'Wrong Approve Status Provided').__dict__, 400

        save_changes(store)

        response = ApiResponse(True, message, None, None)

        return response.__dict__, 200
            
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong!', None, str(e))

        return error.__dict__, 500

def create_store_by_admin(data):
    resp, status = Auth.get_logged_in_user(request)
    user = resp['data']
    # if ((user.role == 'super_admin') or (user.role == 'admin')):
    try:

        # store creation_'name' cannot be blank or null
        city = City.query.filter(func.lower(City.name) == func.lower(data['city_name'])).filter_by(deleted_at = None).first()
        
        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')

            return_object = apiResponce.__dict__
            return return_object, 400

        store = Store.query.filter(func.lower(Store.name) == func.lower(data['name'])).filter((Store.city_id) == city.id).first()

        if store:
            apiResponce = ApiResponse(False,
                                      'Store already exists with same name.',
                                      None, None)
            return (apiResponce.__dict__), 409


        if data['image'] == "default":
            data['image'] = store_dir +  "default.png"
        
        if data['walk_in_order_tax'] not in [0,1]:
            apiResponce = ApiResponse(False,
                                      'Wrong Walkin Order Tax Status Code',
                                      None)
            return (apiResponce.__dict__), 400
        
        agents = DeliveryAgent.query.filter_by(
            status=1).filter_by(deleted_at=None).order_by(func.lower(DeliveryAgent.name)).all()

        response = []
        for agent in agents:
            response.append(agent.id)
        
        if data['da_id'] not in response:
            apiResponce = ApiResponse(False,
                                      'Wrong DA ID',
                                      None)
            return (apiResponce.__dict__), 400
        
        slug = data['name']+"-"+city.name
        slug = slug.lower().replace(" ","-") + str(uuid4())

        try:
            merchant_phone = data['merchant_phone']

            merchant = Merchant.query.filter_by(phone=merchant_phone).filter_by(deleted_at=None).first()
        
        except Exception as e:
            apiResponce = ApiResponse(False, 'Merchant phone number not provided', None, str(e))

            return apiResponce.__dict__, 400
        merchant = Merchant.query.filter_by(
            email=data['merchant_email']).first()
        merchant_phone = Merchant.query.filter_by(
            phone=data['merchant_phone']).first()

        if not merchant_phone:

            if not merchant:
                new_merchant = Merchant(email=data['merchant_email'],
                                        name=data['merchant_name'],
                                        image = profile_pic_dir + "default.png",
                                        password="1234567890",
                                        phone=data['merchant_phone'],
                                        created_at=datetime.datetime.utcnow())
            
                try:
                    db.session.add(new_merchant)
                    db.session.commit()
                except Exception as e:
                    db.session.rollback()
                    apiResponce = ApiResponse(False,'Error Occurred',None,f"Merchant Database Error: {str(e)}")
                    return (apiResponce.__dict__), 500

            else:
                error = ApiResponse(False, 'Merchant Phonenumber not matched', None,
                                    None)
                return (error.__dict__), 400
        
        elif merchant:
            if merchant.id == merchant_phone.id:
                new_merchant = merchant

            else:
                error = ApiResponse(False, 'Merchant Phonenumber not matched', None,
                                    None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'Merchant Email and Phonenumber not matched', None,
                                    None)
            return (error.__dict__), 400
        
        if data['da_id'] == 1:
            try:
                self_delivery_price = data['self_delivery_price']
                if self_delivery_price == None:
                    apiResponce = ApiResponse(False,
                                      'Self Delivery Price Cannot be null',
                                      None)
                    return (apiResponce.__dict__), 400

            except Exception as e:
                apiResponce = ApiResponse(False,
                                      'Self Delivery Price not provided',
                                      None)
                return (apiResponce.__dict__), 400

            
        
            new_store = Store(
                name=data['name'],
                slug=slug,
                owner_name=data['owner_name'],
                shopkeeper_name=data['shopkeeper_name'],
                image=data['image'],
                address_line_1=data['address_line_1'],
                address_line_2=data['address_line_2'],
                store_latitude=data['store_latitude'],
                store_longitude=data['store_longitude'],
                pay_later=data['pay_later'],
                delivery_mode=data['delivery_mode'],
                delivery_start_time=str_to_time(data['delivery_start_time']),
                delivery_end_time=str_to_time(data['delivery_end_time']),
                status=0,
                merchant_id = new_merchant.id,
                approved_at = datetime.datetime.utcnow(),
                approved_by_id = user['id'],
                approved_by_role = user['role'],
                radius=data['radius'],
                created_at=datetime.datetime.utcnow(),
                walkin_order_tax = data['walk_in_order_tax'],
                da_id = data['da_id'],
                city_id = city.id,
                self_delivery_price = self_delivery_price)
        else:
            new_store = Store(
                name=data['name'],
                slug=slug,
                owner_name=data['owner_name'],
                shopkeeper_name=data['shopkeeper_name'],
                image=data['image'],
                address_line_1=data['address_line_1'],
                address_line_2=data['address_line_2'],
                store_latitude=data['store_latitude'],
                store_longitude=data['store_longitude'],
                pay_later=data['pay_later'],
                delivery_mode=data['delivery_mode'],
                delivery_start_time=str_to_time(data['delivery_start_time']),
                delivery_end_time=str_to_time(data['delivery_end_time']),
                status=0,
                merchant_id = new_merchant.id,
                approved_at = datetime.datetime.utcnow(),
                approved_by_id = user['id'],
                approved_by_role = user['role'],
                radius=data['radius'],
                created_at=datetime.datetime.utcnow(),
                walkin_order_tax = data['walk_in_order_tax'],
                da_id = data['da_id'],
                city_id = city.id)


        # Merchant Creation
        


        try:
            db.session.add(new_store)
            db.session.commit()
        
        except Exception as e:
            db.session.rollback()
            apiResponce = ApiResponse(False,'Error Occurred',None,f"Store Database Error: {str(e)}")
            return (apiResponce.__dict__), 400        

        
        store_supervisors = UserCities.query.filter_by(city_id=new_store.city_id).filter_by(role='supervisor').filter_by(deleted_at=None).all()

        recipients = []
        for supervisor in store_supervisors:
            
            user  = Supervisor.query.filter_by(id=supervisor.user_id).filter_by(deleted_at=None).first()

            recipients.append(user)


        recipients.append(new_merchant)

        super_admin = SuperAdmin.query.filter_by(deleted_at=None).all()

        for admin in super_admin:
            recipients.append(admin)


        city = new_store.city
        notification_data = generate_data(store_name=new_store.name, city= city.name, role = 'Super Admin', service='store_create')
        
        th = threading.Thread(target=CreateNotification.gen_notification_v2, args=(recipients, notification_data,))
        th.start()
        # CreateNotification.gen_notification_v2(recipients, notification_data, service='store_create')
            
        apiResponce = ApiResponse(True,
                                      'New Store Successfully registered.',
                                      None, None)
        return (apiResponce.__dict__), 200
        
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None,
                                str(e))
        return (error.__dict__), 500

def create_store_by_merchant(data):
    try:
        # store creation_'name' cannot be blank or null
        
        city = City.query.filter(func.lower(City.name) == func.lower(data['city_name'])).filter_by(deleted_at = None).first()

        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')

            return_object = apiResponce.__dict__
            return return_object, 400

        store = Store.query.filter(func.lower(Store.name) == func.lower(data['name'])).filter((Store.city_id) == city.id).filter_by(deleted_at = None).first()

        if store:
            apiResponce = ApiResponse(False,
                                      'Store already exists with same name.',
                                      None, None)
            return (apiResponce.__dict__), 409

        if data['image'] == "default":
                data['image'] = store_dir + "default.png"
            
        else:
            image_file, status = image_upload(data['image'],store_dir,data['name'])
        
            if status == 400:
                return image_file, status

            data['image'] = image_file
        
        if data['walk_in_order_tax'] not in [0,1]:
            apiResponce = ApiResponse(False,
                                      'Wrong Walkin Order Tax Status Code',
                                      None)
            return (apiResponce.__dict__), 400
        
        agents = DeliveryAgent.query.filter_by(
            status=1).filter_by(deleted_at=None).order_by(func.lower(DeliveryAgent.name)).all()

        response = []
        for agent in agents:
            response.append(agent.id)
        
        if data['da_id'] not in response:
            apiResponce = ApiResponse(False,
                                      'Wrong DA ID',
                                      None)
            return (apiResponce.__dict__), 400
        
        slug = data['name']+"-"+city.name
        slug = slug.lower().replace(" ","-") + str(uuid4())
        
        resp, code = Auth.get_logged_in_user(request)
        merchant = resp['data']
        
        if data['da_id'] == 1:
            try:
                self_delivery_price = data['self_delivery_price']
                if self_delivery_price == None:
                    apiResponce = ApiResponse(False,
                                      'Self Delivery Price Cannot be null',
                                      None)
                    return (apiResponce.__dict__), 400

            except Exception as e:
                apiResponce = ApiResponse(False,
                                      'Self Delivery Price not provided',
                                      None)
                return (apiResponce.__dict__), 400

            
            new_store = Store(
                name=data['name'],
                slug=slug,
                owner_name=data['owner_name'],
                shopkeeper_name=data['shopkeeper_name'],
                image=data['image'],
                address_line_1=data['address_line_1'],
                address_line_2=data['address_line_2'],
                store_latitude=data['store_latitude'],
                store_longitude=data['store_longitude'],
                pay_later=data['pay_later'],
                delivery_mode=data['delivery_mode'],
                delivery_start_time=str_to_time(data['delivery_start_time']),
                delivery_end_time=str_to_time(data['delivery_end_time']),
                status=0,
                radius=data['radius'],
                created_at=datetime.datetime.utcnow(),
                walkin_order_tax = data['walk_in_order_tax'],
                merchant_id = merchant['id'],
                da_id = data['da_id'],
                city_id = city.id,
                self_delivery_price = self_delivery_price)
        else:
            new_store = Store(
                name=data['name'],
                slug=slug,
                owner_name=data['owner_name'],
                shopkeeper_name=data['shopkeeper_name'],
                image=data['image'],
                address_line_1=data['address_line_1'],
                address_line_2=data['address_line_2'],
                store_latitude=data['store_latitude'],
                store_longitude=data['store_longitude'],
                pay_later=data['pay_later'],
                delivery_mode=data['delivery_mode'],
                delivery_start_time=data['delivery_start_time'],
                delivery_end_time=data['delivery_end_time'],
                status=0,
                merchant_id = merchant['id'],
                radius=data['radius'],
                created_at=datetime.datetime.utcnow(),
                walkin_order_tax = data['walk_in_order_tax'],
                da_id = data['da_id'],
                city_id = city.id)
        
        try:
            save_db(new_store)
        except Exception as e:
            logging.error(f"Database error: {str(e)}")

        bank_details=StoreBankDetails.query.filter_by(store_id=new_store.id).filter_by(deleted_at = None).first()

        try:
            vpa = data['vpa']
        except:
            vpa = None

        confirmed = 1

        if not bank_details:
            new_bankdetail = StoreBankDetails(
                store_id=new_store.id,
                beneficiary_name = data['beneficiary_name'], 
                name_of_bank=data['name_of_bank'],
                ifsc_code=data['ifsc_code'],
                vpa=vpa,
                account_number=data['account_number'],
                confirmed = confirmed,
                created_at=datetime.datetime.utcnow())
            try:    
                save_db(new_bankdetail)
            except Exception as e:
                logging.error(f"Database error: {str(e)}")

        new_store.bank_details_id = new_bankdetail.id

        try:
            save_db(new_store)
        except Exception as e:
            logging.error(f"Database error: {str(e)}")


        apiResponce = ApiResponse(True,
                                    'Store Created Waiting for Admin to approve the store',
                                    None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'New Store Not able to Create', None,
                            str(e))
        return (error.__dict__), 500
    
def show_all_store():
    try:
        
        try:
            page_no  = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        try:
            query = request.args.get('query')
        except Exception:
            query = ""
        
        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, f"Only {config.item_per_page} item per page allowed", None , None)
            return apiresponse.__dict__ , 400
        
        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None , None)
            return apiresponse.__dict__ , 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        role = str(user['role']).capitalize().replace('_', '')
    
        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):

        
            if query:

                if len(query) > 2:

                    query = f'%{query}%'
                    records = Store.query.filter_by(deleted_at = None).filter(func.lower(Store.name).like(func.lower(query))).filter(Store.approved_at != None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Store.query.filter_by(deleted_at = None).filter(Store.approved_at != None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)

            else:
                    records = Store.query.filter_by(deleted_at = None).filter(Store.approved_at != None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)

            
            if records:
                recordObject = []
                for record in records.items:
                    cityname = ""
                    
                    if record.city:
                        cityname = record.city.name
                    
                    commission = 0
                    if record.commission != None:
                        commission = record.commission
                    response = {
                        'id': record.id,
                        'name': record.name,
                        'slug': record.slug,
                        'owner_name': record.owner_name,
                        'shopkeeper_name': record.shopkeeper_name,
                        'image': record.image,
                        'address_line_1': record.address_line_1,
                        'address_line_2': record.address_line_2,
                        'store_latitude': record.store_latitude,
                        'store_longitude': record.store_longitude,
                        'pay_later': record.pay_later,
                        'delivery_mode': record.delivery_mode,
                        'open_status': store_open_status(record),
                        'delivery_start_time': if_time(record.delivery_start_time),
                        'delivery_end_time': if_time(record.delivery_end_time),
                        'radius': record.radius,
                        'status': record.status,
                        'city_id': record.city_id,
                        'city_name': cityname,
                        'commission' : commission,

                    }
                    recordObject.append(response)

                return_obj= {
                    'page': records.page,
                    'total_pages': records.pages,
                    'has_next_page': records.has_next,
                    'has_prev_page': records.has_prev,
                    'prev_page': records.prev_num,
                    'next_page': records.next_num,
                    'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=records.prev_num) if records.has_prev else None,
                    'next_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=records.next_num) if records.has_next else None,
                    'current_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=page_no),
                    'items_per_page': records.per_page,
                    'items_current_page': len(records.items),
                    'total_items': records.total,
                    'items': recordObject
                }

                apiResponce = ApiResponse(True, 'List of All Stores', return_obj,
                                        None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Store Not able to fetch', None, 'No Data Found')
                return (error.__dict__), 404

        elif ((user['role'] == 'merchant')):
            
            #get merchant_id from auth token
            user_id = user['id']

            if query:
                
                if len(query) > 2:

                    query = f'%{query}%'
                    records = Store.query.filter_by(merchant_id=user['id']).filter_by(deleted_at = None).filter(Store.approved_at != None).filter(Store.merchant_id==user_id).filter(func.lower(Store.name).like(func.lower(query))).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Store.query.filter_by(merchant_id=user['id']).filter_by(deleted_at = None).filter(Store.approved_at != None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).filter(Store.merchant_id==user_id).paginate(page_no, item_per_page, False)

            else:
                    records = Store.query.filter_by(merchant_id=user['id']).filter_by(deleted_at = None).filter(Store.approved_at != None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).filter(Store.merchant_id==user_id).paginate(page_no, item_per_page, False)
            

            if records:
                recordObject = []
                for record in records.items:
                    cityname = ""
                    if record.city:
                        cityname = record.city.name
                    response = {
                        'id': record.id,
                        'name': record.name,
                        'slug': record.slug,
                        'owner_name': record.owner_name,
                        'shopkeeper_name': record.shopkeeper_name,
                        'image': record.image,
                        'address_line_1': record.address_line_1,
                        'address_line_2': record.address_line_2,
                        'store_latitude': record.store_latitude,
                        'store_longitude': record.store_longitude,
                        'pay_later': record.pay_later,
                        'delivery_mode': record.delivery_mode,
                        'open_status': store_open_status(record),
                        'delivery_start_time': if_time(record.delivery_start_time),
                        'delivery_end_time': if_time(record.delivery_end_time),
                        'radius': record.radius,
                        'status': record.status,
                        'city_id' : record.city_id, 
                        'city_name': cityname,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)

                return_obj= {
                        'page': records.page,
                        'total_pages': records.pages,
                        'has_next_page': records.has_next,
                        'has_prev_page': records.has_prev,
                        'prev_page': records.prev_num,
                        'next_page': records.next_num,
                        'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=records.prev_num) if records.has_prev else None,
                        'next_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=records.next_num) if records.has_next else None,
                        'current_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store_store_list', page=page_no),
                        'items_per_page': records.per_page,
                        'items_current_page': len(records.items),
                        'items': recordObject
                    }
                
                apiResponce = ApiResponse(True, 'List of Stores', return_obj,
                                        None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Store Not able to fetch', None, 'No Data Found')
                return (error.__dict__), 404
    
    except Exception as e:
            error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
            return (error.__dict__), 500

def show_store_by_slug(data):
    # records = Store.query.filter(Store.slug == data['store_slug'],
    #                                 Store.deleted_at == None).all()

    try:
        records = Store.query.filter(Store.slug == data['store_slug'],
                                     Store.deleted_at == None).filter_by(status=1).all()
        recordObject = []
        for record in records:
            cityname = ""
            if record.city:
                cityname = record.city.name
            
            commission = 0
            if record.commission != None:
                commission = record.commission
                

            response = {
                'id': record.id,
                'name': record.name,
                'slug': record.slug,
                'owner_name': record.owner_name,
                'shopkeeper_name': record.shopkeeper_name,
                'image': record.image,
                'address_line_1': record.address_line_1,
                'address_line_2': record.address_line_2,
                'store_latitude': record.store_latitude,
                'store_longitude': record.store_longitude,
                'pay_later': record.pay_later,
                'delivery_mode': record.delivery_mode,
                'open_status': store_open_status(record),
                'delivery_start_time': if_time(record.delivery_start_time),
                'delivery_end_time': if_time(record.delivery_end_time),
                'radius': record.radius,
                'status': record.status,
                'city_id': record.city_id,
                'city_name': cityname,
                # 'commission' : commission,
                # 'created_at': str(record.created_at),
                # 'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        if len(recordObject) == 0:
            error = ApiResponse(False, 'Store Not Found', None, 'No records found')
            return error.__dict__, 400

        apiResponce = ApiResponse(True, 'Store Details fetched',
                                    recordObject, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
        return (error.__dict__), 500

def show_store_by_id(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if ((user['role'] == 'super_admin' or user['role'] == 'admin')):
            record = Store.query.filter(Store.id == data['store_id'],
                                     Store.deleted_at == None).first()

            if record:
                # recordObject = []
                # for record in records:
                cityname = ""
                if record.city:
                    cityname = record.city.name
                commission = 0
                if record.commission != None:
                    commission = record.commission
                response = {
                    'id': record.id,
                    'name': record.name,
                    'slug': record.slug,
                    'owner_name': record.owner_name,
                    'shopkeeper_name': record.shopkeeper_name,
                    'image': record.image,
                    'address_line_1': record.address_line_1,
                    'address_line_2': record.address_line_2,
                    'store_latitude': record.store_latitude,
                    'store_longitude': record.store_longitude,
                    'pay_later': record.pay_later,
                    'delivery_mode': record.delivery_mode,
                    'open_status': store_open_status(record),
                    'delivery_start_time': if_time(record.delivery_start_time),
                    'delivery_end_time': if_time(record.delivery_end_time),
                    'radius': record.radius,
                    'status': record.status,
                    'city_id' : record.city_id,
                    'city_name': cityname,
                    'commission': commission,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                    #recordObject.append(response)


                apiResponce = ApiResponse(True, 'Store Details fetched',
                                        response, None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Store Not Found', None, 'Given Store id Wrong or Deleted')
                return (error.__dict__), 400

        elif ((user['role'] == 'merchant')):
            
            user_id = user['id']
            #Merchant can find only their stores otherwise data will be blank
            records = Store.query\
            .filter(Store.merchant_id==user_id)\
            .filter(Store.id == data['store_id'],Store.deleted_at == None
            ).all()
            
            if records:
                recordObject = []
                for record in records:
                    cityname = ""
                    if record.city:
                        cityname = record.city.name
                    commission = 0
                    if record.commission != None:
                        commission = record.commission
                    response = {
                        'id': record.id,
                        'name': record.name,
                        'slug': record.slug,
                        'owner_name': record.owner_name,
                        'shopkeeper_name': record.shopkeeper_name,
                        'image': record.image,
                        'address_line_1': record.address_line_1,
                        'address_line_2': record.address_line_2,
                        'store_latitude': record.store_latitude,
                        'store_longitude': record.store_longitude,
                        'pay_later': record.pay_later,
                        'delivery_mode': record.delivery_mode,
                        'open_status': store_open_status(record),
                        'delivery_start_time': if_time(record.delivery_start_time),
                        'delivery_end_time': if_time(record.delivery_end_time),
                        'radius': record.radius,
                        'status': record.status,
                        'city_id' : record.city_id,
                        'city_name': cityname,
                        'commission':commission,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)

                apiResponce = ApiResponse(True, 'Store Details fetched',
                                        recordObject, None)
                return (apiResponce.__dict__), 200
            
            else:
                error = ApiResponse(False, 'Store Not Found', None, 'Given Store id Worng or Deleted')
                return (error.__dict__), 404

        elif user['role'] == 'supervisor' :
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400

            cityname = ""
            if store.city:
                cityname = store.city.name
            commission = 0
            if store.commission != None:
                commission = store.commission
            response = {
                'id': store.id,
                'name': store.name,
                'slug': store.slug,
                'owner_name': store.owner_name,
                'shopkeeper_name': store.shopkeeper_name,
                'image': store.image,
                'address_line_1': store.address_line_1,
                'address_line_2': store.address_line_2,
                'store_latitude': store.store_latitude,
                'store_longitude': store.store_longitude,
                'pay_later': store.pay_later,
                'delivery_mode': store.delivery_mode,
                'open_status': store_open_status(store),
                'delivery_start_time': if_time(store.delivery_start_time),
                'delivery_end_time': if_time(store.delivery_end_time),
                'radius': store.radius,
                'status': store.status,
                'city_id' : store.city_id,
                'city_name': cityname,
                'commission':commission,
                'created_at': str(store.created_at),
                'updated_at': str(store.updated_at),
            }

            apiResponce = ApiResponse(True, 'Store Details fetched',
                                    response, None)
            return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
        return (error.__dict__), 500
    
    
def show_all_store_info_by_id(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if ((user['role'] == 'super_admin' or user['role'] == 'admin')):
            record = Store.query.filter(Store.id == data['store_id'],
                                     Store.deleted_at == None).first()

            if record:
                # recordObject = []
                # for record in records:
                cityname = ""
                if record.city:
                    cityname = record.city.name
                commission = 0
                if record.commission != None:
                    commission = record.commission
                response = {
                    'id': record.id,
                    'name': record.name,
                    'slug': record.slug,
                    'owner_name': record.owner_name,
                    'shopkeeper_name': record.shopkeeper_name,
                    'image': record.image,
                    'address_line_1': record.address_line_1,
                    'address_line_2': record.address_line_2,
                    'store_latitude': record.store_latitude,
                    'store_longitude': record.store_longitude,
                    'pay_later': record.pay_later,
                    'delivery_mode': record.delivery_mode,
                    'open_status': store_open_status(record),
                    'delivery_start_time': if_time(record.delivery_start_time),
                    'delivery_end_time': if_time(record.delivery_end_time),
                    'radius': record.radius,
                    'status': record.status,
                    'city_id' : record.city_id,
                    'city_name': cityname,
                    'commission': commission,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                    #recordObject.append(response)


                apiResponce = ApiResponse(True, 'Store Details fetched',
                                        response, None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(False, 'Store Not Found', None, 'Given Store id Wrong or Deleted')
                return (error.__dict__), 400

        elif ((user['role'] == 'merchant')):
            
            user_id = user['id']
            #Merchant can find only their stores otherwise data will be blank
            record = Store.query.filter_by(merchant_id=user_id)\
            .filter(Store.id == data['store_id'],Store.deleted_at == None
            ).first()
            
            if not record:
                error = ApiResponse(False, 'Store Not Found', None, 'Given Store id Worng or Deleted')
                return (error.__dict__), 404
            
            taxes = StoreTaxes.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).order_by(func.lower(StoreTaxes.name)).all()
            
            return_tax_object = []
            
            if taxes:
                for tax in taxes:
                    tax = {
                        'id' : tax.id,
                        'store_id' : tax.store_id,
                        'tax_name' : tax.name,
                        'description':tax.description,
                        'tax_type': tax.tax_type,
                        'amount' : tax.amount
                    }
                    return_tax_object.append(tax)
                
            cityname = ""
            if record.city:
                cityname = record.city.name
            commission = 0
            if record.commission != None:
                commission = record.commission
            response = {
                'id': record.id,
                'name': record.name,
                'slug': record.slug,
                'owner_name': record.owner_name,
                'shopkeeper_name': record.shopkeeper_name,
                'image': record.image,
                'address_line_1': record.address_line_1,
                'address_line_2': record.address_line_2,
                'store_latitude': record.store_latitude,
                'store_longitude': record.store_longitude,
                'pay_later': record.pay_later,
                'delivery_mode': record.delivery_mode,
                'open_status': store_open_status(record),
                'delivery_start_time': if_time(record.delivery_start_time),
                'delivery_end_time': if_time(record.delivery_end_time),
                'radius': record.radius,
                'status': record.status,
                'city_id' : record.city_id,
                'city_name': cityname,
                'commission':commission,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
                'store_tax':return_tax_object,
            }
            

            apiResponce = ApiResponse(True, 'Store Details fetched',
                                    response, None)
            return (apiResponce.__dict__), 200
            
        elif user['role'] == 'supervisor' :
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400

            cityname = ""
            if store.city:
                cityname = store.city.name
            commission = 0
            if store.commission != None:
                commission = store.commission
            taxes = StoreTaxes.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).order_by(func.lower(StoreTaxes.name)).all()
            
            return_tax_object = []
            if taxes:
                for tax in taxes:
                    tax = {
                        'id' : tax.id,
                        'store_id' : tax.store_id,
                        'tax_name' : tax.name,
                        'description':tax.description,
                        'tax_type': tax.tax_type,
                        'amount' : tax.amount
                    }
                    return_tax_object.append(tax)
            response = {
                'id': store.id,
                'name': store.name,
                'slug': store.slug,
                'owner_name': store.owner_name,
                'shopkeeper_name': store.shopkeeper_name,
                'image': store.image,
                'address_line_1': store.address_line_1,
                'address_line_2': store.address_line_2,
                'store_latitude': store.store_latitude,
                'store_longitude': store.store_longitude,
                'pay_later': store.pay_later,
                'delivery_mode': store.delivery_mode,
                'open_status': store_open_status(store),
                'delivery_start_time': if_time(store.delivery_start_time),
                'delivery_end_time': if_time(store.delivery_end_time),
                'radius': store.radius,
                'status': store.status,
                'city_id' : store.city_id,
                'city_name': cityname,
                'commission':commission,
                'created_at': str(store.created_at),
                'updated_at': str(store.updated_at),
                'store_tax':return_tax_object,
            }

            apiResponce = ApiResponse(True, 'Store Details fetched',
                                    response, None)
            return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
        return (error.__dict__), 500

#NOT USING IT (I DONT KNOW WHY ITS EVEN HERE)
def show_store():
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
        
    try:
        records = db.session.query(Store).all()
        recordObject = []
        for record in records:
            cityname = ""
            if record.city:
                cityname = record.city.name
            commission = 0
            if record.commission != None:
                commission = record.commission
            response = {
                'id': record.id,
                'name': record.name,
                'slug': record.slug,
                'owner_name': record.owner_name,
                'shopkeeper_name': record.shopkeeper_name,
                'image': record.image,
                'address_line_1': record.address_line_1,
                'address_line_2': record.address_line_2,
                'store_latitude': record.store_latitude,
                'store_longitude': record.store_longitude,
                'pay_later': record.pay_later,
                'delivery_mode': record.delivery_mode,
                'delivery_start_time': record.delivery_start_time,
                'delivery_end_time': record.delivery_end_time,
                'radius': record.radius,
                'status': record.status,
                'city_id' : record.city_id,
                'city_name': cityname,
                'commission': commission,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        apiResponce = ApiResponse(True, 'List of All Stores', recordObject,
                                    None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
        return (error.__dict__), 500

def update_store(data):
    
    try:

        store = Store.query.filter(Store.id == data['id']).filter(Store.deleted_at == None).first()
        city = City.query.filter_by(name = data['city_name']).filter_by(deleted_at = None).first()
        
        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')
            return (apiResponce.__dict__), 400
        


        # if data['image'] == "default":
        #     data['image'] = store_dir + "default.png"

        # else:
        #     image_file, status = image_upload(data['image'],store_dir,data['name'])
        #     if status == 400 :   
        #         if not check_file(data['image']):
        #             return image_file, 400
                    
        #     else:
        #         data['image'] = image_file

        # if not check_file(data['image']):
        #     data['image'] = store_dir +  "default.png"
            # error = ApiResponse(False, 'Something Went Wrong', None,
            #                 'Image not found')
            # return (error.__dict__), 400

        if not store:
            apiResponce = ApiResponse(False, 'Store Not Found', None,
                                      'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400
        
        store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()

        if not store_merchant:
            apiResponce = ApiResponse(False, 'Store is Not Linked with the Merchant', None,
                                      'Store id and Merchant id is not mapped')
            return (apiResponce.__dict__), 400
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'merchant' and store_merchant.merchant_id != user['id']: 
            apiResponce = ApiResponse(False, "Merchant can't Update this store", None,
                                      'Merchant id and Store id Not Matched')
            return (apiResponce.__dict__), 400
        
        elif user['role'] == 'supervisor' :
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
                
            if store.city_id not in cities:
                apiResponce = ApiResponse(False, "Supervisor has No access to Update this Store")
        
        store.name = data['name']
        store.slug = data['name']
        store.owner_name = data['owner_name']
        store.shopkeeper_name = data['shopkeeper_name']
        store.image = data['image']
        store.address_line_1 = data['address_line_1']
        store.address_line_2 = data['address_line_2']
        store.store_latitude = data['store_latitude']
        store.store_longitude = data['store_longitude']
        # store.pay_later = data['pay_later']
        # store.delivery_mode = data['delivery_mode']
        # store.delivery_start_time = data['delivery_start_time']
        # store.delivery_end_time = data['delivery_end_time']
        store.radius = data['radius']
        # store.status = data['status']
        store.updated_at = datetime.datetime.utcnow()
        store.city_id = city.id
        
        try:
            db.session.add(store)
            db.session.commit()

        except Exception as e:
            db.session.rollback()
            apiResponce = ApiResponse(False, 'Error Occured',None,
                                    f"Store Database Error: {str(e)}")
            return (apiResponce.__dict__), 500
            
        
        if user['role'] != 'merchant':
            
            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'role': user['role'].capitalize(),
                'template_name': 'store_update',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
        
        apiResponce = ApiResponse(True, 'Store Successfully Updated.',
                                    None, None)
        return (apiResponce.__dict__), 201
       

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured',None,
                                      str(e))
        return (apiResponce.__dict__), 500

def update_store_image(data):
    try:
        store = Store.query.filter(Store.id == data['id']).filter(Store.deleted_at == None).first()
        
        if not store:
            apiResponce = ApiResponse(False, 'Store Not Found', None,
                                      'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400
        
        store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()

        if not store_merchant:
            apiResponce = ApiResponse(False, 'Store is Not Linked with the Merchant', None,
                                      'Store id and Merchant id is not mapped')
            return (apiResponce.__dict__), 400
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'merchant' and store_merchant.merchant_id != user['id']: 
            apiResponce = ApiResponse(False, "Merchant can't Update this store", None,
                                      'Merchant id and Store id Not Matched')
            return (apiResponce.__dict__), 400
        
        elif user['role'] == 'supervisor' :
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
                
            if store.city_id not in cities:
                apiResponce = ApiResponse(False, "Supervisor has No access to Update this Store")
        
        image, status = image_save(request, store_dir)
        
        if status != 200:
            return image, status
        
        url, status = image_upload(image['data']['image'], store_dir, store.name)
        
        if status != 200:
            return image, status
        
        store.image = url
        store.updated_at = datetime.datetime.utcnow()
        save_db(store)
        
        return ApiResponse(True, "Store Image Updated successfully"), 200
    
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured',None,
                                      str(e))
        return (apiResponce.__dict__), 500    
        
def delete_store(data):
    try:
        store = Store.query.filter_by(id=data['store_id']).first()
        
        if not store:
            apiResponce = ApiResponse(False, 'Store does not exists.', None,
                                      None)
            return (apiResponce.__dict__), 200
        
        store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()

        if not store_merchant:
            apiResponce = ApiResponse(False, 'Store is Not Linked with the Merchant', None,
                                      'Store id and Merchant id is not mapped')
            return (apiResponce.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        if user['role'] == 'merchant' and store_merchant.merchant_id != user['id']: 
            apiResponce = ApiResponse(False, "Merchant can't Update this store", None,
                                      'Merchant id and Store id Not Matched')
            return (apiResponce.__dict__), 403
        
        elif user['role'] != 'super_admin':
            apiResponce = ApiResponse(False, "Un Aunthenticated User", None)
            return (apiResponce.__dict__), 403
                  
        
        store.deleted_at = datetime.datetime.utcnow()
        
        save_db(store)
        
        if user['role'] != 'merchant':
            
            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'role': user['role'].capitalize(),
                'template_name': 'store_delete',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
        
        apiResponce = ApiResponse(True, 'Store Successfully Deleted.', None)
        return (apiResponce.__dict__), 200
   
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None,
                                      str(e))
        return (apiResponce.__dict__), 500

def find_store1(data):
    lat = data['lat']
    lon = data['long']
    max_dist = data['max_dist']
    result = []
    location = (lat, lon)
    stores = Store.query.filter_by(deleted_at=None).filter_by(status=1).all()
    for store in stores:
        if store.store_latitude:
            x1 = float(store.store_latitude)
            x2 = float(store.store_longitude)
            city2 = (x1, x2)
            x3 = haversine(location, city2)
            if (max_dist >= x3):
                if x3 <= store.radius:
                    result.append(store)

    return result

def find_store(data):
    try:
        lat = data['lat']
        lon = data['long']
        max_dist = data['max_dist']
        result = []
        location = (lat, lon)
        stores = Store.query.filter_by(deleted_at=None).filter_by(status=1).all()
        for store in stores:
            if store.store_latitude:
                x1 = float(store.store_latitude)
                x2 = float(store.store_longitude)
                city2 = (x1, x2)
                x3 = haversine(location, city2)
                if (max_dist >= x3):
                    if x3 <= store.radius:
                        response = {
                            'id': store.id,
                            'name': store.name,
                            'slug': store.slug,
                            # 'locality_id': record.locality_id,
                            'owner_name': store.owner_name,
                            'shopkeeper_name': store.shopkeeper_name,
                            'image': store.image,
                            'address_line_1': store.address_line_1,
                            'address_line_2': store.address_line_2,
                            'store_latitude': store.store_latitude,
                            'store_longitude': store.store_longitude,
                            'pay_later': store.pay_later,
                            'delivery_mode': store.delivery_mode,
                            'open_status': store_open_status(store),
                            'delivery_start_time': if_time(store.delivery_start_time),
                            'delivery_end_time': if_time(store.delivery_end_time),
                            'radius': store.radius,
                            'status': store.status, 
                            'created_at': str(store.created_at),
                            'updated_at': str(store.updated_at),
                            # 'deleted_at': str(record.deleted_at),
                        }
                        result.append(response)

        apiResponce = ApiResponse(True, 'List of All Stores', result, None)
        return (apiResponce.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__ , 500

def find_store_by_category_coordinate(data):
    try:
        stores = find_store1(data)
        result = []
        category = Category.query.filter_by(id=data['category_id']).filter_by(deleted_at=None).first()
        for store in stores:
            if category in store.category:
                response = {
                    'id': store.id,
                    'name': store.name,
                    'slug': store.slug,
                    # 'locality_id': record.locality_id,
                    'owner_name': store.owner_name,
                    'shopkeeper_name': store.shopkeeper_name,
                    'image': store.image,
                    'address_line_1': store.address_line_1,
                    'address_line_2': store.address_line_2,
                    'store_latitude': store.store_latitude,
                    'store_longitude': store.store_longitude,
                    'pay_later': store.pay_later,
                    'delivery_mode': store.delivery_mode,
                    'open_status': store_open_status(store),
                    'delivery_start_time': if_time(store.delivery_start_time),
                    'delivery_end_time': if_time(store.delivery_end_time),
                    'radius': store.radius,
                    'status': store.status,
                    'created_at': str(store.created_at),
                    'updated_at': str(store.updated_at)
                    # 'deleted_at': str(record.deleted_at),
                }
                result.append(response)
        apiResponce = ApiResponse(True, 'List of All Stores', result, None)
        return (apiResponce.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__ , 500

def create_store_category_map(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(merchant_id=user_id).filter_by(deleted_at=None)

            store_ids = []

            for merchant_store in merchant_stores:
                store_ids.append(merchant_store.id)

            if not data['store_id'] in store_ids:
                error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400


        if not Store.query.filter_by(id=data['store_id']).filter_by(deleted_at=None).first():
            error = ApiResponse(False, 'Invalid Store ID', None, 'Store id not found or is deleted')
            return error.__dict__, 400

        for record in data['category_id']:

            # get existing Cart
            existingStoreCategories = existingStoreCategoriesData(
                record, data['store_id'])

            if not len(existingStoreCategories):

                category = Category.query.filter_by(id=record).filter_by(deleted_at=None).first()

                if not category:
                    apiResponce = ApiResponse(False,
                                            'Store Category does not exist or is deleted!',
                                            None, 'Store Category not found')
                    return (apiResponce.__dict__), 400
                new_store_cat_map = StoreCategory(
                    store_id=data['store_id'],
                    category_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                db.session.add(new_store_cat_map)
                db.session.commit()
            else:
                apiResponce = ApiResponse(False,
                                            'Store Category Already Mapped',
                                            None, None)
                return (apiResponce.__dict__), 409

        apiResponce = ApiResponse(True,
                                    'Store Category Mapped Successfully.',
                                    None, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store Category Not able to Map', None,
                            str(e))
        return (error.__dict__), 500

def fetch_store_category_map(data):
    try:

        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == 'merchant':
            merchant_stores = Store.query.filter_by(merchant_id=user_id).filter_by(deleted_at=None)

            store_ids = []

            for merchant_store in merchant_stores:
                store_ids.append(merchant_store.id)

            if not data['store_id'] in store_ids:
                error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                return error.__dict__, 401
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['data']['id']).filter_by(deleted_at = None)
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400
        
            
        store_categories = StoreCategory.query.filter_by(store_id=data['store_id']).filter_by(deleted_at = None).all()

        if not store_categories:
            error = ApiResponse(True, 'No category Found', [], 'Store id not in Store Categories')
            return error.__dict__, 200

        response_data = []
        for entry in store_categories:
            category = Category.query.filter_by(id=entry.category_id).filter_by(deleted_at=None).order_by(func.lower(Category.name)).first()

            if category:
                recordObject = {
                'id': entry.id,
                'store_id': entry.store_id,
                'category_id': category.id,
                'name': category.name,
                'image': category.image,
                'status': category.status,
                'created_at': str(category.created_at),
                'deleted_at': str(category.deleted_at),
                'updated_at': str(category.updated_at)
                }
                response_data.append(recordObject)

        # sql = text(
        #     'SELECT store_categories.id,store_categories.store_id, categories.*\
        #     from store_categories join categories on store_categories.category_id = categories.id\
        # where store_id = :store_id and store_categories.deleted_at IS NULL'
        # )

        # result = db.engine.execute(sql, {'store_id': data['store_id']})
        # store_categories = []

        # for row in result:

        #     print(row)
        #     recordObject = {
        #         'id': row[0],
        #         'store_id': row[1],
        #         'category_id': row[2],
        #         'name': row[3],
        #         'image': row[4],
        #         'status': row[5],
        #         'created_at': str(row[6]),
        #         'deleted_at': str(row[7]),
        #         'updated_at': str(row[8])
        #     }
        #     store_categories.append(recordObject)
        # print(store_categories)


        if len(response_data) == 0:
            apiResponce = ApiResponse(
            False, 'Invalid Store ID',
            store_categories, 'Query returned empty result')

            return (apiResponce.__dict__), 404

        apiResponce = ApiResponse(
            True, 'List of All Store category Map Details',
            response_data, None)

        return apiResponce.__dict__, 200
    
    except Exception as e:
        error = ApiResponse(False, 'Store Category Not able to fetch....', None,
                            str(e))
        return (error.__dict__), 500

def delete_store_category(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        if user['role'] == 'super_admin' or user['role'] == 'admin':
            storeCategory = StoreCategory.query.filter_by(id=data['store_cat_id']).filter_by(deleted_at=None).first()

            if not storeCategory:
                apiResponce = ApiResponse(False,
                                      'Error Occured',None, 'Given Catagory Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

            storeCategory.deleted_at = datetime.datetime.utcnow()
            storeCategory.updated_at = datetime.datetime.utcnow()
            try:
                db.session.add(storeCategory)
                db.session.commit()

                response_object = {
                    'id': storeCategory.id,
                    'store_id': storeCategory.store_id,
                    'category_id': storeCategory.category_id,
                }

                apiResponce = ApiResponse(True,
                                      'Store Category Successfully Deleted.',
                                      response_object, None)
                return (apiResponce.__dict__), 200

            except Exception as e:
                db.session.rollback()
                apiResponce = ApiResponse(False,'Database Server Error',None,"Store Category: " + str(e))
                return (apiResponce.__dict__), 500


        elif user['role'] == 'merchant':
            
            storeCategory = StoreCategory.query.filter_by(id=data['store_cat_id']).filter_by(deleted_at=None).first()

            if not storeCategory:
                apiResponce = ApiResponse(False,
                                      'Error Occured',None, 'Given Catagory Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

            merchant_store = Store.query.filter_by(id = storeCategory.store_id).filter_by(merchant_id=user_id).first()
            

            if not merchant_store:
                apiResponce = ApiResponse(False, 'Merchant has no Access to this Store', None, 'Unauthorized Access')
                return (apiResponce.__dict__), 401

            storeCategory.deleted_at = datetime.datetime.utcnow()
            storeCategory.updated_at = datetime.datetime.utcnow()

            try:
                db.session.add(storeCategory)
                db.session.commit()

                response_object = {
                    'id': storeCategory.id,
                    'store_id': storeCategory.store_id,
                    'category_id': storeCategory.category_id,
                }

                apiResponce = ApiResponse(True,
                                    'Store Category Successfully Deleted.',
                                    response_object, None)
                return (apiResponce.__dict__), 200

            except Exception as e:
                db.session.rollback()
                apiResponce = ApiResponse(False,'Database Server Error',None,str(e))
                return (apiResponce.__dict__), 500

        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400
            
            storeCategory = StoreCategory.query.filter_by(id=data['store_cat_id']).filter_by(deleted_at=None).first()

            if not storeCategory:
                apiResponce = ApiResponse(False,
                                      'Error Occured',None, 'Given Catagory Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

            storeCategory.deleted_at = datetime.datetime.utcnow()
            storeCategory.updated_at = datetime.datetime.utcnow()
            try:
                db.session.add(storeCategory)
                db.session.commit()

                response_object = {
                    'id': storeCategory.id,
                    'store_id': storeCategory.store_id,
                    'category_id': storeCategory.category_id,
                }

                apiResponce = ApiResponse(True,
                                      'Store Category Successfully Deleted.',
                                      response_object, None)
                return (apiResponce.__dict__), 200

            except Exception as e:
                db.session.rollback()
                apiResponce = ApiResponse(False,'Database Server Error',None,"Store Category: " + str(e))
                return (apiResponce.__dict__), 500

    
    except Exception as e:
        apiResponce = ApiResponse(False,'Internal Server Error',None,str(e))
        return (apiResponce.__dict__), 500
    
def create_store_menu_category_map(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(merchant_id=user_id).filter_by(deleted_at=None)

            store_ids = []

            for merchant_store in merchant_stores:
                store_ids.append(merchant_store.id)

            if not data['store_id'] in store_ids:
                error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400


        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            apiResponce = ApiResponse(
                    False, 'Error Occured', None,
                    'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        all_ready_mapped = ""
        invalid = ""
        valid = ""
        for menu_category_id in data['menu_category_id']:

            # get existing map
            # existingStoreMenuCategories = existingStoreMenuCategoriesData(
            #     record, data['store_id'])
            
            menu_category = MenuCategory.query.filter_by(id=menu_category_id).filter_by(deleted_at = None).first()

            if not menu_category:
                invalid = invalid + str(menu_category_id) + ", "

            else:

                store_menu_category = StoreMenuCategory.query.filter_by(store_id = data['store_id']).filter_by(menu_category_id = menu_category_id).filter_by(deleted_at=None).first()

                if not store_menu_category:
                    valid = valid + menu_category.name + ", "
                    new_store_cat_map = StoreMenuCategory(
                        store_id=data['store_id'],
                        menu_category_id=menu_category_id,
                        status='1',
                        created_at=datetime.datetime.utcnow())

                    save_db(new_store_cat_map, 'StoreMenuCategory')
                    
                    
                else:
                    all_ready_mapped = all_ready_mapped + menu_category.name + ", "
        
        if invalid == "" and all_ready_mapped == "":
            apiResponce = ApiResponse(
                True, f'Store Menu Category {valid} Mapped Successfully.', None, None)
            return (apiResponce.__dict__), 200

        elif all_ready_mapped != "" and valid != "":
            apiResponce = ApiResponse(True, f'{valid} Menu Categories Mapped Succesfully and {all_ready_mapped} this are allready Mapped',
                                        None, f"Invalid menu categoriy Id are {invalid}")
            return (apiResponce.__dict__), 206
        
        elif all_ready_mapped == "" and valid != "":
            apiResponce = ApiResponse(True, f'{valid} Menu Categories Mapped Succesfully',
                                        None, f"Invalid menu categoriy Id are {invalid} ")
            return (apiResponce.__dict__), 206
        
        elif all_ready_mapped != "" and valid == "":
            apiResponce = ApiResponse(False, f'{all_ready_mapped} Menu Categories are Allready Mapped',
                                        None, f"{all_ready_mapped} are valid Menu categories but allready mapped, and Invalid menu categories are {invalid} ")
            return (apiResponce.__dict__), 400
        
        elif valid == "" and all_ready_mapped == "":
            apiResponce = ApiResponse(False, 'Error Occured',
                                        None, "Given MenuCategory Id's are wrong or Deleted")
            return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store Menu Category Not able to Map',
                            None, str(e))
        return (error.__dict__), 500

def delete_store_menu_category(data):
    try:
        storeMenuCategory = StoreMenuCategory.query.filter_by(
            id=data['menu_category_id']).first()
        
        if storeMenuCategory:
            user, status = Auth.get_logged_in_user(request)
            user_id = user['data']['id']
            role=user['data']['role']

            if role == "merchant":
                merchant_stores = Store.query.filter_by(merchant_id = user_id).filter_by(deleted_at=None)

                store_ids = []

                for merchant_store in merchant_stores:
                    store_ids.append(merchant_store.id)

                if not storeMenuCategory.store_id in store_ids:
                    error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                    return error.__dict__, 401

            elif role == "supervisor":
                
                supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
            
                cities = []
                for supervisor_city in supervisor_cities:
                    cities.append(supervisor_city.city_id)
                
                store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = storeMenuCategory.store_id).first()
                
                if not store:
                    error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                    return (error.__dict__), 400
                
                if store.deleted_at != None:
                    error = ApiResponse(False, 'Store was Deleted', None, None)
                    return (error.__dict__), 400

            storeMenuCategory.deleted_at = datetime.datetime.utcnow()
            
            save_db(storeMenuCategory,"Store MenuCategory")
            

            response_object = {
                'id': storeMenuCategory.id,
                'store_id': storeMenuCategory.store_id,
                'menu_category_id': storeMenuCategory.menu_category_id,
            }
            apiResponce = ApiResponse(
                True, 'Store Menu Category Successfully Deleted.',
                response_object, None)
            return (apiResponce.__dict__), 200

        else:
            apiResponce = ApiResponse(
                False, 'Store Menu Category Map does not exists.', None, None)
            return (apiResponce.__dict__), 404
    
    except Exception as e:
        apiResponce = ApiResponse(False,'Internal Server Error',None,str(e))
        return (apiResponce.__dict__), 500
    
def delete_all_store_menu_category(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(merchant_id = user_id).filter_by(deleted_at=None)

            store_ids = []

            for merchant_store in merchant_stores:
                store_ids.append(merchant_store.id)

            if not data['store_id'] in store_ids:
                error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400

        sql = text(
            'UPDATE store_menu_categories SET deleted_at = :current_date WHERE store_id = :store_id;'
        )

        result = db.engine.execute(
            sql, {
                'current_date': datetime.datetime.utcnow(),
                'store_id': data['store_id']
            })

        apiResponce = ApiResponse(True,
                                    'All Store Menu Category map Deleted',
                                    None, None)

        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store Category Not able to Map', None,
                            str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500

def fetch_store_menu_category_map(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'merchant')):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(merchant_id=user_id).filter_by(deleted_at=None)

            store_ids = []

            for merchant_store in merchant_stores:
                store_ids.append(merchant_store.id)

            if not data['store_id'] in store_ids:
                error = ApiResponse(False, 'Unauthorized Merchant', None, 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['data']['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400


        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            apiResponce = ApiResponse(
                    False, 'Error Occured', None,
                    'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400


        store_menu_categories = StoreMenuCategory.query.filter_by(store_id=data['store_id']).filter_by(deleted_at=None).all()

        
        if not store_menu_categories:
            error = ApiResponse(True, 'Menucategory Fetched Successfuly', [] , 'No Menucategory Mapped')
            return error.__dict__, 200
        
        resp_data = []
        for index,store_menu_category in enumerate(store_menu_categories):

            menu_category = MenuCategory.query.filter_by(id=store_menu_categories[index].menu_category_id).order_by(func.lower(MenuCategory.name)).first()

            if menu_category:
                recordObject = {
                    'id': store_menu_category.id,
                    'store_id': store_menu_category.store_id,
                    'menu_category_id': store_menu_category.menu_category_id,
                    'category_id': menu_category.category_id,
                    'name': menu_category.name,
                    'image': menu_category.image,
                    'slug': menu_category.slug,
                    'status': menu_category.status,
                    'created_at': str(menu_category.created_at),
                    'updated_at': str(menu_category.updated_at),
                    'deleted_at': str(menu_category.deleted_at)
                }
                resp_data.append(recordObject)

        # sql = text(
        #     'SELECT store_menu_categories.id,store_menu_categories.store_id, menu_categories.*\
        #             from store_menu_categories\
        #             join menu_categories on store_menu_categories.menu_category_id = menu_categories.id\
        #             where store_menu_categories.store_id = :store_id\
        #             and store_menu_categories.deleted_at IS NULL')

        # result = db.engine.execute(sql, {'store_id': data['store_id']})
        # store_menu_categories = []

        # for row in result:

        #     print(row)
        #     recordObject = {
        #         'id': row[0],
        #         'store_id': row[1],
        #         'menu_category_id': row[2],
        #         'category_id': row[3],
        #         'name': row[4],
        #         'image': row[5],
        #         'slug': row[6],
        #         'status': row[7],
        #         'created_at': str(row[8]),
        #         'deleted_at': str(row[9]),
        #         'updated_at': str(row[10])
        #     }
        #     store_menu_categories.append(recordObject)
        # print(store_menu_categories)

        apiResponce = ApiResponse(True, 'Menucategory Fetched Successfuly', resp_data, None)

        return apiResponce.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Store Category Not able to Map', None,
                            str(e))
        return error.__dict__, 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def existingStoreCategoriesData(cat_id, store_id):


    store_categories = StoreCategory.query.filter_by(store_id=store_id).filter_by(category_id=cat_id).filter_by(deleted_at=None).all()
    
    category = Category.query.filter_by(id=cat_id).filter_by(deleted_at=None).first()

    if not category:
        return []
    # sql = text('SELECT id, store_id,category_id from store_categories \
    #     where store_id = :store_id and category_id = :cat_id and deleted_at IS NULL'
    #            )
    existCartDetails = []
    for category in store_categories:
        resp_data = {
            'id': category.id,
            'store_id': category.store_id,
            'category_id': category.category_id
        }
        existCartDetails.append(category)

    # result = db.engine.execute(sql, {
    #     'store_id': store_id,
    #     'cat_id': cat_id,
    # })
    

    # for row in result:

    #     existCartDetails = row
    return existCartDetails


def existingStoreMenuCategoriesData(menu_cat_id, store_id):

    sql = text(
        'SELECT id, store_id,menu_category_id from store_menu_categories \
        where store_id = :store_id and menu_category_id = :menu_cat_id and deleted_at IS NULL'
    )

    result = db.engine.execute(sql, {
        'store_id': store_id,
        'menu_cat_id': menu_cat_id,
    })
    existCartDetails = []

    for row in result:

        existCartDetails = row

    return existCartDetails


def front_menu_cat_find_by_store_id(data):
    print("hello")
    try:
        sql = text(
            'SELECT store_menu_categories.id,store_menu_categories.store_id, menu_categories.*\
                    from store_menu_categories\
                    join menu_categories on store_menu_categories.menu_category_id = menu_categories.id\
                    where store_menu_categories.store_id = :store_id\
                    and store_menu_categories.deleted_at IS NULL')

        result = db.engine.execute(sql, {'store_id': data['store_id']})
        store_menu_categories = []

        for row in result:

            print(row)
            recordObject = {
                'id': row[0],
                'store_id': row[1],
                'menu_category_id': row[2],
                'category_id': row[3],
                'name': row[4],
                'image': row[5],
                'slug': row[6],
                'status': row[7],
                'created_at': str(row[8]),
                'deleted_at': str(row[9]),
                'updated_at': str(row[10])
            }
            store_menu_categories.append(recordObject)
        print(store_menu_categories)

        apiResponce = ApiResponse(True,
                                  'List of All Menu Categories by Store ID',
                                  store_menu_categories, None)

        return (apiResponce.__dict__), 200
    except Exception as e:

        error = ApiResponse(False, 'Store Menu Category Not able to Fetch', None,
                            str(e))

        return (error.__dict__), 500

def front_menu_cat_find_by_store_slug(data):

    print("hello")
    try:
        store_id=Store.query.filter_by(slug = data['store_slug']).first()

        #result = StoreMenuCategory.query.filter_by(store_id=store_id.id).filter_by(status=1).filter_by(deleted_at=None).join(MenuCategory, MenuCategory.id == StoreMenuCategory.menu_category_id).all()
        store_menu_cat = StoreMenuCategory.query.filter_by(store_id=store_id.id).filter_by(status=1).filter_by(deleted_at=None).first()
        if not store_menu_cat:
            error = ApiResponse(False, f'No data found with store_id {store_id.id}', None,
                                None)
            return (error.__dict__), 400

        menu_cat = MenuCategory.query.filter_by(id=store_menu_cat.menu_category_id)
        if not menu_cat:
            error = ApiResponse(False, 'No menu category is available', None,
                                None)

            return (error.__dict__), 400

        store_menu_cat_id = store_menu_cat.id
        store_menu_cat_store_id = store_menu_cat.store_id

        # sql = text(
        #     'SELECT store_menu_categories.id,store_menu_categories.store_id, menu_categories.*\
        #             from store_menu_categories\
        #             join menu_categories on store_menu_categories.menu_category_id = menu_categories.id\
        #             where store_menu_categories.store_id = :store_id and store_menu_categories.status = 1\
        #             and store_menu_categories.deleted_at IS NULL')
        #
        # result = db.engine.execute(sql, {'store_id': store_id.id})
        store_menu_categories = []

        for row in menu_cat:

            print(row)
            recordObject = {
                'id': store_menu_cat_id,
                'store_id': store_menu_cat_store_id,
                'menu_category_id': row.id,
                'category_id': row.category_id,
                'name': row.name,
                'image': row.image,
                'slug': row.slug,
                'status': row.status,
                'created_at': str(row.created_at),
                'deleted_at': str(row.deleted_at),
                'updated_at': str(row.updated_at)
            }
            store_menu_categories.append(recordObject)
        print(store_menu_categories)

        apiResponce = ApiResponse(True,
                                  'List of All Menu Categories by Store ID',
                                  store_menu_categories, None)

        return (apiResponce.__dict__), 200
    except Exception as e:

        error = ApiResponse(False, 'Store Menu Category Not able to Fetch', None,
                            str(e))

        return (error.__dict__), 500


def front_menu_cat_find_by_store_slug_pagination(data):
    try:
        store_id=Store.query.filter_by(slug = data['store_slug']).filter_by(deleted_at=None).filter_by(status=1).first()

        if not store_id:
            error=ApiResponse(False, 'Store Not Found', None, 'No records found')
            return error.__dict__, 400
        try:
            page_no = int(data['page'])

        except:
            page_no = 1

        try:
            item_per_page = int(data['item_per_page'])
        except:
            item_per_page = 10

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        # result = StoreMenuCategory.query.filter_by(store_id=store_id.id).filter_by(status=1).filter_by(deleted_at=None).join(MenuCategory, MenuCategory.id == StoreMenuCategory.menu_category_id).all()
        store_menu_cat = StoreMenuCategory.query.filter_by(store_id=store_id.id).filter_by(status=1).filter_by(
            deleted_at=None).paginate(page_no, item_per_page, False)

        if not store_menu_cat:
            error = ApiResponse(False, f'No data found with store_id {store_id.id}', None,
                                None)
            return (error.__dict__), 400

        store_menu_categories = []

        for s_menu_cat in store_menu_cat.items:
            menu_cat = MenuCategory.query.filter(MenuCategory.id == s_menu_cat.menu_category_id).first()

            # if not menu_cat.items:
            #     error = ApiResponse(False, 'No menu category is available', None,
            #                         None)
            #
            #     return (error.__dict__), 400
            store_menu_cat_id = s_menu_cat.id
            store_menu_cat_store_id = s_menu_cat.store_id

            recordObject = {
                'id': store_menu_cat_id,
                'store_id': store_menu_cat_store_id,
                'menu_category_id': menu_cat.id,
                'category_id': menu_cat.category_id,
                'name': menu_cat.name,
                'image': menu_cat.image,
                'slug': menu_cat.slug,
                'status': menu_cat.status,
                'created_at': str(menu_cat.created_at),
                'deleted_at': str(menu_cat.deleted_at),
                'updated_at': str(menu_cat.updated_at)
            }
            store_menu_categories.append(recordObject)

        if len(store_menu_categories) == 0:
            error =ApiResponse(False, 'Menu categories can\'t be fetched', None, 'No records found')
            return error.__dict__, 400
        return_obj = {
            'page': store_menu_cat.page,
            'total_pages': store_menu_cat.pages,
            'has_next_page': store_menu_cat.has_next,
            'has_prev_page': store_menu_cat.has_prev,
            'prev_page': store_menu_cat.prev_num,
            'next_page': store_menu_cat.next_num,
            'prev_page_url': None,
            'next_page_url': None,
            'current_page_url': None,
            'items_per_page': store_menu_cat.per_page,
            'items_current_page': len(store_menu_categories),
            'total_items': store_menu_cat.total,
            'items': store_menu_categories
        }

        print(store_menu_categories)

        apiResponce = ApiResponse(True,
                                  'List of All Menu Categories by Store ID',
                                  return_obj, None)

        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store Menu Category Not able to Fetch', None,
                            str(e))

        return (error.__dict__), 500


def add_store_commison(data):
    try:
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400
        
        if user['role'] == 'supervisor':
            supervisor_city = UserCities.query.filter_by(user_id = user['id']).filter_by(city_id = store.city_id).filter_by(deleted_at = None).first()
        
            if not supervisor_city:
                error = ApiResponse(False, 'Supervisor have no access to this store')
                return (error.__dict__), 400
                
            
        if store.commission == None:
            msg = 'Commision Added Successfully'
        else:
            msg = 'Commision Updated Successfully'
            
        store.commission = data['commission']
        store.updated_at = datetime.datetime.utcnow()
        save_db(store, 'Store')
        
        
        store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

        reciepent = store_merchant.merchant
        city = store.city
        notification_data = {
            'store_name': store.name,
            'city' : city.name,
            'status': msg.replace("Successfully",""),
            'role': user['role'].capitalize(),
            'template_name': 'store_commission',
        }
        
        CreateNotification.gen_notification_v2(reciepent, notification_data)

        apiResponse = ApiResponse(True, msg, None,
                            None)
        return (apiResponse.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, 'Adding Commision to the Store Failed', None,
                            str(e))
        return (error.__dict__), 500
    
def add_store_tax(data):
    try:
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        storemerchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()
        
        if storemerchant.merchant_id != user_id :
            error = ApiResponse(False, 'Merchant have no access to add taxes to this Store', None,
                            'Store id is not matched with merchant id')
            return (error.__dict__), 400
        taxes = StoreTaxes.query.filter(func.lower(StoreTaxes.name)==func.lower(data['name'])).filter_by(deleted_at = None).first()

        if taxes:
            error = ApiResponse(False, 'Tax Allready Exists', None,
                            'Tax Name Allready Exists')
            return (error.__dict__), 400
        
        if data['tax_type'] not in [2,1]:
            error = ApiResponse(False, 'Worng Tax Type Provided', None,
                            'Tax type only can be 2 and 1')
            return (error.__dict__), 400

        new_storetax = StoreTaxes(
            store_id = data['store_id'],
            name = data['name'],
            description = data['description'],
            tax_type  = data['tax_type'],
            amount = data['amount'],
            created_at = datetime.datetime.utcnow()    
        )

        save_db(new_storetax, "StoreTaxes")
        

        apiResponse = ApiResponse(True, 'New Store Tax Added Successfully', None,
                            None)
        return (apiResponse.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'Add Store Tax Failed', None,
                            str(e))
        return (error.__dict__), 500

def update_store_tax(data):
    try:
        storetax = StoreTaxes.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not storetax:
            error = ApiResponse(False, 'Tax Does not Exists', None,
                            'Given Tax Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        storemerchant = Store.query.filter_by(id = storetax.store_id).filter_by(deleted_at = None).first()
        
        if storemerchant.merchant_id != user_id :
            error = ApiResponse(False, 'Merchant have no access to update taxes to this Store', None,
                            'Store id is not matched with merchant id')
            return (error.__dict__), 400
        
        if data['tax_type'] not in [2,1]:
            error = ApiResponse(False, 'Worng Tax Type Provided', None,
                            'Tax type only can be 2 and 1')
            return (error.__dict__), 400

        storetax.name = data['name'],
        storetax.description = data['description'],
        storetax.tax_type  = data['tax_type'],
        storetax.amount = data['amount']  
        storetax.updated = datetime.datetime.utcnow()
        save_db(storetax, "StoreTaxes")
        

        apiResponse = ApiResponse(True, 'Store Tax Updated Successfully', None,
                            None)
        return (apiResponse.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Updating Tax to the Store Failed', None,
                            str(e))
        return (error.__dict__), 500

def delete_store_tax(data):
    try:
        storetax = StoreTaxes.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not storetax:
            error = ApiResponse(False, 'Tax Does not Exists', None,
                            'Given Tax Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        storemerchant = Store.query.filter_by(id = storetax.store_id).filter_by(deleted_at = None).first()
        
        if storemerchant.merchant_id != user_id :
            error = ApiResponse(False, 'Merchant have no access to delete taxes to this Store', None,
                            'Store id is not matched with merchant id')
            return (error.__dict__), 400

        storetax.deleted_at = datetime.datetime.utcnow()

        save_db(storetax,"StoreTaxes")        
        

        apiResponse = ApiResponse(True, 'New Store Tax Deleted Successfully', None,
                            None)
        return (apiResponse.__dict__), 201 

    except Exception as e:
        error = ApiResponse(False, 'Deleting Tax to the Store Failed', None,
                            str(e))
        return (error.__dict__), 500

def show_unapproved_stores(data):
    try:
        try:
            if data['query'] != None:
                query = f"%{data['query']}%"
            else:
                query = None
        except:
            query = None

        try:
            status = data['status']
        except:
            status = None

        try:
            city_id = data['city_id']
        except:
            city_id=None

        try:
            page_no = data['page_no']
        except:
            page_no = 1
        
        try:
            items_per_page = data['items_per_page']
        except:
            items_per_page = 10

        user, stat = Auth.get_logged_in_user(request)
        user = user['data']

        stores = None

        if not query:
            if not status:
                if not city_id:
                    
                    if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                    
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            city_ids.append(city.city_id)


                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                
                elif city_id:
                    if user['role'] == 'super_admin':
                            stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(city_id=city_id).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            if city_id == city.city_id:
                                city_ids.append(city.city_id)

                        
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
            
            elif not city_id:
                if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).filter_by(status=status).paginate(page_no, items_per_page, False)
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        city_ids.append(city.city_id)


                    stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).filter_by(status=status).filter_by(approved_at=None).paginate(page_no, items_per_page, False)

            elif city_id:
                if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).filter_by(city_id=city_id).filter_by(status=status).paginate(page_no, items_per_page, False)
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        if city.id == city_id:
                            city_ids.append(city.city_id)


                    stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).filter_by(status=status).filter_by(approved_at=None).paginate(page_no, items_per_page, False)

        elif query:
            if not status:
                if not city_id:
                    if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            city_ids.append(city.city_id)


                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).filter(func.lower(Store.name).like(func.lower(query))).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                elif city_id:
                    if user['role'] == 'super_admin':
                            stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(city_id=city_id).filter(func.lower(Store.name).like(func.lower(query))).filter(func.lower(Store.name).like(func.lower(query))).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            if city_id == city.city_id:
                                city_ids.append(city.city_id)


                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter(Store.city_id.in_(city_ids)).filter_by(approved_at=None).paginate(page_no, items_per_page, False)
            
            elif not city_id:
                if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter_by(approved_at=None).filter_by(status=status).paginate(page_no, items_per_page, False)
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        city_ids.append(city.city_id)


                    stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter(Store.city_id.in_(city_ids)).filter_by(status=status).filter_by(approved_at=None).paginate(page_no, items_per_page, False)

            elif city_id:
                if user['role'] == 'super_admin':
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter_by(approved_at=None).filter_by(city_id=city_id).filter_by(status=status).paginate(page_no, items_per_page, False)
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        if city.id == city_id:
                            city_ids.append(city.city_id)


                    stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(func.lower(Store.name).like(func.lower(query))).filter(Store.city_id.in_(city_ids)).filter_by(status=status).filter_by(approved_at=None).paginate(page_no, items_per_page, False)

            
        if not stores:
            error =ApiResponse(False, 'No Stores found!', None, 'Store list is empty')

            return error.__dict__, 400

        response_data = []
        if not stores:
            error = ApiResponse(False, 'No data found!', '')
        for store in stores.items:
            merchant = store.merchant

            response_data.append({
                'store_id': store.id,
                'store_name': store.name,
                'merchant_name': merchant.name,
                'merchant_phone': merchant.phone,
                'created_at': str(store.created_at),
                'deleted_at': None if store.deleted_at==None else str(store.deleted_at),
                'city': store.city.name,
            })

        return_obj = {
                'page': stores.page,
                'total_pages': stores.pages,
                'has_next_page': stores.has_next,
                'has_prev_page': stores.has_prev,
                'prev_page': stores.prev_num,
                'next_page': stores.next_num,
                'prev_page_url': None,
                'next_page_url': None,
                'current_page_url': None,
                'items_per_page': stores.per_page,
                'items_current_page': len(stores.items),
                'total_items': stores.total,
                'items': response_data
            }

       

        response = ApiResponse(True, 'Unapproved stores fetched successfully', return_obj, None)

        return response.__dict__, 200


    except Exception as e:
        error = ApiResponse(False, 'Something went wrong!', None, str(e))

        return error.__dict__, 500
            
def show_onboarding_stores(data):
    try:
        try:
            if data['query'] != None:
                query = f"%{data['query']}%"
            else:
                query = None
        except:
            query = None

        try:
            status = data['status']
        except:
            status = None

        try:
            city_id = data['city_id']
        except:
            city_id=None

        try:
            page_no = data['page_no']
        except:
            page_no = 1
        
        try:
            items_per_page = data['items_per_page']
        except:
            items_per_page = 10

        user, stat = Auth.get_logged_in_user(request)
        user = user['data']

        stores = None

        if not query:
            if status == None:
                if not city_id:
                    
                    #IF ALL FILTERS ARE NONE
                    
                    if user['role'] == 'super_admin':
                        stores = Store.query.filter(Store.merchant_id!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            city_ids.append(city.city_id)


                        stores = Store.query.filter(Store.merchant_id!=None).filter(Store.city_id.in_(city_ids)).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                
                elif city_id:
                    
                    #IF ONLY CITY_ID
                    
                    if user['role'] == 'super_admin':
                        stores = Store.query.filter(Store.merchant_id!=None).filter_by(city_id=city_id).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif user['role'] == 'supervisor':
                        supervisor_city = UserCities.query.filter_by(user_id=user['id']).filter_by(city_id = city_id).filter_by(deleted_at=None).first()
                    
                        if not supervisor_city:
                            error = ApiResponse(False, "City Not Belongs to Supervisor"), 400

                        
                        stores = Store.query.filter(Store.merchant_id!=None).filter(Store.city_id == city_id).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
            
            elif not city_id:
                
                #IF ONLY STATUS
                
                if user['role'] == 'super_admin':
                    if status == 0:
                        stores = Store.query.filter(Store.deleted_at!=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                    elif status == 1:
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        city_ids.append(city.city_id)


                    if status == 0:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).filter(Store.deleted_at!=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                            
                    elif status == 1:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    

            elif city_id:
                
                #IF STATUS AND CITY_ID
                
                if user['role'] == 'super_admin':
                    
                    if status == 0:
                        stores = Store.query.filter(Store.deleted_at!=None).filter(Store.merchant_id!=None).filter_by(city_id = city_id).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                    elif status == 1:
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(city_id = city_id).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(city_id = city_id).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                elif user['role'] == 'supervisor':
                    supervisor_city = UserCities.query.filter_by(user_id=user['id']).filter_by(city_id = city_id).filter_by(deleted_at=None).first()
                    
                    if not supervisor_city:
                        error = ApiResponse(False, "City Not Belongs to Supervisor"), 400

                    if status == 0:
                        stores = Store.query.filter(Store.city_id == city_id).filter(Store.deleted_at!=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                            
                    elif status == 1:
                        stores = Store.query.filter(Store.city_id == city_id).filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter_by(approved_at=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.filter(Store.city_id == city_id).filter_by(deleted_at=None).filter(Store.merchant_id!=None).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)

        elif query:
            if status == None:
                if not city_id:
                    
                    #IF ONLY QUERY
                    
                    if user['role'] == 'super_admin':
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                        
                    elif user['role'] == 'supervisor':
                        supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                        
                        city_ids = []
                        for city in supervisor_cities:
                            city_ids.append(city.city_id)

                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.city_id.in_(city_ids)).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                    
                        
                elif city_id:
                    
                    #IF QUERY AND CITY_ID
                    
                    if user['role'] == 'super_admin':
                            stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter_by(city_id=city_id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).paginate(page_no, items_per_page, False)
                            
                    elif user['role'] == 'supervisor':
                        supervisor_city = UserCities.query.filter_by(user_id=user['id']).filter_by(city_id = city_id).filter_by(deleted_at=None).first()
                    
                        if not supervisor_city:
                            error = ApiResponse(False, "City Not Belongs to Supervisor"), 400

                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.city_id==city_id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
            
            
            elif not city_id:
                
                # IF QUERY AND STATUS
                
                if user['role'] == 'super_admin':
                    if status == 0:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                    elif status == 1:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at==None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at==None)/filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                
                elif user['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None).all()
                    
                    city_ids = []
                    for city in supervisor_cities:
                        city_ids.append(city.city_id)


                    if status == 0:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                            
                    elif status == 1:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at==None).filter(Store.merchant_id!=None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.filter(Store.city_id.in_(city_ids)).join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at==None).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    

            elif city_id:
                
                # IF ALL
                
                if user['role'] == 'super_admin':
                    
                    if status == 0:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.city_id == city_id).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                    elif status == 1:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.city_id == city_id).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.city_id == city_id).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                        
                elif user['role'] == 'supervisor':
                    supervisor_city = UserCities.query.filter_by(user_id=user['id']).filter_by(city_id = city_id).filter_by(deleted_at=None).first()
                    
                    if not supervisor_city:
                        error = ApiResponse(False, "City Not Belongs to Supervisor"), 400


                    if status == 0:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.city_id == city_id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                            
                    elif status == 1:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.city_id == city_id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.approved_at==None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)
                    
                    elif status == 2:
                        stores = Store.query.join(Merchant, Store.merchant_id == Merchant.id).filter(Store.city_id == city_id).filter(Store.merchant_id!=None).filter(or_(func.lower(Store.name).like(func.lower(query)),func.lower(Merchant.name).like(func.lower(query)))).filter(Store.deleted_at!=None).filter(Store.approved_at!=None).order_by(Store.created_at.desc()).paginate(page_no, items_per_page, False)

                     
        # if not stores:
        #     error =ApiResponse(False, 'No Stores found!', None, 'Store list is empty')

        #     return error.__dict__, 400

        response_data = []
        
        for store in stores.items:
            
            if not status:
                if store.approved_at != None and store.deleted_at == None:
                    approve_status = 2
                
                elif store.approved_at != None and store.deleted_at != None:
                    approve_status = 3
                
                elif store.approved_at == None and store.deleted_at == None:
                    approve_status = 1
                
                else:
                    approve_status = 0
            
            else:
                approve_status = status
            
            merchant = store.merchant

            response_data.append({
                'store_id': store.id,
                'store_name': store.name,
                'merchant_name': merchant.name,
                'merchant_phone': merchant.phone,
                'approve_status': approve_status, 
                'created_at': if_date_time(store.created_at),
                'deleted_at': if_date_time(store.deleted_at),
                'approved_at' : if_date_time(store.approved_at),
                'city': store.city.name,
            })

        return_obj = {
                'page': stores.page,
                'total_pages': stores.pages,
                'has_next_page': stores.has_next,
                'has_prev_page': stores.has_prev,
                'prev_page': stores.prev_num,
                'next_page': stores.next_num,
                'prev_page_url': None,
                'next_page_url': None,
                'current_page_url': None,
                'items_per_page': stores.per_page,
                'items_current_page': len(stores.items),
                'total_items': stores.total,
                'items': response_data
            }

       
        response = ApiResponse(True, 'Onboard stores fetched successfully', return_obj, None)
        return response.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Something went wrong!', None, str(e))

        return error.__dict__, 500
            

def show_store_tax(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            storemerchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
            if storemerchant.merchant_id != user_id :
                error = ApiResponse(False, 'Merchant have no access to Show taxes of this Store', None,
                                'Store id is not matched with merchant id')
                return (error.__dict__), 400

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None)
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None, None)
                return (error.__dict__), 400

        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400

        taxes = StoreTaxes.query.filter_by(store_id = store.id).filter_by(deleted_at = None).order_by(func.lower(StoreTaxes.name)).all()

        return_object = []
        for tax in taxes:
            tax = {
                'id' : tax.id,
                'store_id' : tax.store_id,
                'tax_name' : tax.name,
                'description':tax.description,
                'tax_type': tax.tax_type,
                'amount' : tax.amount
            }
            return_object.append(tax)

        apiResponse = ApiResponse(True, 'Tax Details Fetched', return_object,
                            None)
        return (apiResponse.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Fetching Store Tax Failed', None,
                            str(e))
        return (error.__dict__), 500

def walkin_tax_status_change(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            storemerchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
            if storemerchant.merchant_id != user_id :
                error = ApiResponse(False, 'Merchant have no access to Show taxes of this Store', None,
                                'Store id is not matched with merchant id')
                return (error.__dict__), 400    
            
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400

        elif role == "supervisor":
            check = UserCities.query.filter_by(user_id = user_id).filter_by(city_id = store.city_id).fitler_by(deleted_at = None).first()
            
            if not check:
               error = ApiResponse(False, 'Supervisor has no access to change status of this store')
               return (error.__dict__), 400 
           
        if data['status'] == 1:
            msg = "Walkin Order Tax Enabled"
        
        elif data['status'] == 0:
            msg = "Walkin Order Tax Disabled"

        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', None, None)
            return (error.__dict__), 400
    
        store.walkin_order_tax = data['status']
        save_db(store, "Store")
        

        apiResponse = ApiResponse(True, msg , None,
                            None)
        return (apiResponse.__dict__), 200 

    except Exception as e:
        error = ApiResponse(False, 'Updating Walkin Order Status Failed', None,
                            str(e))
        return (error.__dict__), 500

def walkin_tax_status_fetch(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            storemerchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
            if storemerchant.merchant_id != user_id :
                error = ApiResponse(False, 'Merchant have no access to Show taxes of this Store', None,
                                'Store id is not matched with merchant id')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400
        
        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(city_id = store.city_id).filter_by(deleted_at = None).all()
        
            
            if not supervisor_cities:
                error = ApiResponse(False, 'Supervisor has no access to see about this store', None, None)
                return (error.__dict__), 400
        
    
        return_object ={ 'data' : store.walkin_order_tax }

        apiResponse = ApiResponse(True, "Walkin Order Tax Status Fetched" , return_object,
                            None)
        return (apiResponse.__dict__), 200 

    except Exception as e:
        error = ApiResponse(False, 'Unable to Fetch Walkin Order Tax Status', None,
                            str(e))
        return (error.__dict__), 500

def walkin_commission_status_change(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400

        if role == "supervisor":
            check = UserCities.query.filter_by(user_id = user_id).filter_by(city_id = store.city_id).fitler_by(deleted_at = None).first()
            
            if not check:
               error = ApiResponse(False, 'Supervisor has no access to change status of this store')
               return (error.__dict__), 400 
        
        elif role != 'super_admin':
            error = ApiResponse(False, 'User has no access to change status of this store')
            return (error.__dict__), 400 
        
        if data['status'] == 1:
            msg = "Walkin Order Commission Enabled"
        
        elif data['status'] == 0:
            msg = "Walkin Order Commission Disabled"

        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', None, None)
            return (error.__dict__), 400
    
        store.walkin_order_commission = data['status']
        save_db(store, "Store")
        
        apiResponse = ApiResponse(True, msg , None,
                            None)
        return (apiResponse.__dict__), 200 

    except Exception as e:
        error = ApiResponse(False, 'Updating Walkin Order Commission Status Failed', None,
                            str(e))
        return (error.__dict__), 500

def walkin_commission_status_fetch(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            storemerchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
            if storemerchant.merchant_id != user_id :
                error = ApiResponse(False, 'Merchant have no access to Show commissions of this Store', None,
                                'Store id is not matched with merchant id')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        
        if not store:
            error = ApiResponse(False, 'Store Does not Exists', None,
                            'Given Store Id is Wrong or deleted')
            return (error.__dict__), 400
        
        if role == "supervisor":
            check = UserCities.query.filter_by(user_id = user_id).filter_by(city_id = store.city_id).fitler_by(deleted_at = None).first()
            
            if not check:
               error = ApiResponse(False, 'Supervisor has no access to change status of this store')
               return (error.__dict__), 400 
    
        return_object ={ 'data' : store.walkin_order_commission }

        apiResponse = ApiResponse(True, "Walkin Order Commission Status Fetched" , return_object,
                            None)
        return (apiResponse.__dict__), 200 

    except Exception as e:
        error = ApiResponse(False, 'Unable to Fetch Walkin Order Commission Status', None,
                            str(e))
        return (error.__dict__), 500


####################################
######## SUEPR VISOR ###############
####################################

def supervisor_fetch_stores():

    try:

        try:
            page_no  = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, f"Only {config.item_per_page} item per page allowed", None , None)
            return apiresponse.__dict__ , 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None , None)
            return apiresponse.__dict__ , 400

        try:
            #query = request.args.get('id')
            query = request.args.get('query')
        except Exception:
            query = ""

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = str(user['role']).capitalize().replace('_', '')

        # try:
        #     page_no  = int(request.args.get('page'))
        # except:
        #     page_no = 1
        # try:
        #     item_per_page = int(request.args.get('item_per_page'))
        # except:
        #     item_per_page = 10
        
        # if item_per_page not in config.item_per_page:
        #     apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None , None)
        #     return apiresponse.__dict__ , 400

        supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
        cities = []
        for supervisor_city in supervisor_cities:
            cities.append(supervisor_city.city_id)
        
        if query:
            if len(query) > 2:
                query=f'%{query}%'
                stores = Store.query.filter(Store.city_id.in_(cities)).filter(func.lower(Store.name).like(func.lower(query))).filter_by(deleted_at = None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)
            else:
                stores = Store.query.filter(Store.city_id.in_(cities)).filter_by(deleted_at=None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)
        else:
            stores = Store.query.filter(Store.city_id.in_(cities)).filter_by(deleted_at = None).order_by(Store.status.desc()).order_by(func.lower(Store.name)).paginate(page_no, item_per_page, False)

        
        storeObject = []
        for store in stores.items:
            cityname = ""
            
            if store.city:
                cityname = store.city.name
            
            commission = 0
            if store.commission != None:
                commission = store.commission
            response = {
                'id': store.id,
                'name': store.name,
                'slug': store.slug,
                'owner_name': store.owner_name,
                'shopkeeper_name': store.shopkeeper_name,
                'image': store.image,
                'address_line_1': store.address_line_1,
                'address_line_2': store.address_line_2,
                'store_latitude': store.store_latitude,
                'store_longitude': store.store_longitude,
                'pay_later': store.pay_later,
                'delivery_mode': store.delivery_mode,
                'open_status': store_open_status(store),
                'delivery_start_time': if_time(store.delivery_start_time),
                'delivery_end_time': if_time(store.delivery_end_time),
                'radius': store.radius,
                'status': store.status,
                'city_id': store.city_id,
                'city_name': cityname,
            }
            storeObject.append(response)

        return_obj= {
                'page': stores.page,
                'total_pages': stores.pages,
                'has_next_page': stores.has_next,
                'has_prev_page': stores.has_prev,
                'prev_page': stores.prev_num,
                'next_page': stores.next_num,
                'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Manage Store_get_{role.lower()}_store_list', page=stores.prev_num) if stores.has_prev else None,
                'next_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Manage Store_get_{role.lower()}_store_list', page=stores.next_num) if stores.has_next else None,
                'current_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Manage Store_get_{role.lower()}_store_list', page=page_no),
                'items_per_page': stores.per_page,
                'items_current_page': len(stores.items),
                'total_items': stores.total,
                'items': storeObject
            }



        if len(storeObject) ==0:
            error = ApiResponse(False, 'Store Not able to fetch', None, 'No Data Found')
            return (error.__dict__), 404

        response = ApiResponse(True, 'Stores Fetched Succesfully', return_obj, None)
        return response.__dict__, 200
        
    
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to create', None,
                            str(e))
        return (error.__dict__), 500

def store_status_change(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id  != user_id:
                error = ApiResponse(False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store not found', 'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400

        if data['status'] == 0:
            msg = "Store Disabled"
        elif data['status'] == 1:
            msg = "Store Enabled"
        
        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', None, None)
            return (error.__dict__), 400
        
        
        if store.approved_at == None:
            return ApiResponse(False, 'Store is Not Approved Yet').__dict__, 400
        
        if store.bank_details_id == None:
            return ApiResponse(False, 'Store Bank Details Not Found').__dict__, 400
        
        store.status = data['status']
        store.updated_at = datetime.datetime.utcnow()
        save_db(store, "Store")
        
        if user['role'] != 'merchant':
            store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'status': msg.split()[1],
                'role': user['role'].capitalize(),
                'template_name': 'store_status',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
        apiResponse = ApiResponse(True, msg, None, None)
        return apiResponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to create', None,
                            str(e))
        return (error.__dict__), 500

def supervisor_store_delete(data):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
        cities = []
        for supervisor_city in supervisor_cities:
            cities.append(supervisor_city.city_id)
        
        store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
        
        if not store:
            error = ApiResponse(False, 'Supervisor has no access to disable this Store', None, None)
            return (error.__dict__), 400
        
        if store.deleted_at != None:
            error = ApiResponse(False, 'Store was Deleted', None, None)
            return (error.__dict__), 400
        
        store.deleted_at = datetime.datetime.utcnow()
        
        save_db(store, "Store")
        
        store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

        reciepent = store_merchant.merchant
        city = store.city
        notification_data = {
            'store_name': store.name,
            'city' : city.name,
            'role': 'Supervisor',
            'template_name': 'store_delete',
        }
        
        CreateNotification.gen_notification_v2(reciepent, notification_data)

        apiResponse = ApiResponse(True, "Store Deleted Successfully", None, None)
        return apiResponse.__dict__, 200
        

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to create', None,
                            str(e))
        return (error.__dict__), 500


def update_delivery_type(data):

    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id  != user_id:
                error = ApiResponse(False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store not found', 'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400

        if data['delivery_mode'] == 0:
            msg = "Delivery mode changed to One day Delivery"
            status = "One day"

        elif data['delivery_mode'] == 1:
            msg = "Delivery mode changed to Express Delivery"
            status = "Express"
        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', 'null', 'null')
            return (error.__dict__), 400

        store.delivery_mode = data['delivery_mode']
        store.delivery_start_time = str_to_time(data['delivery_start_time'])
        store.delivery_end_time = str_to_time(data['delivery_end_time'])
        store.updated_at = datetime.datetime.utcnow()
        save_db(store,"Store")
        
        if role != 'merchant':
            store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'status': status,
                'role': user['data']['role'].capitalize(),
                'template_name': 'store_status',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)

        apiResponse = ApiResponse(True, msg, 'null', 'null')
        return apiResponse.__dict__, 200
        
        

    except Exception as e:
        error = ApiResponse(False, 'Delivery type Not able to Update', 'null',
                            str(e))
        return (error.__dict__), 500

def update_paylater(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        role= resp['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id  != user_id:
                error = ApiResponse(False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store not found', 'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400

        if data['pay_later'] == 0:
            msg = "Paylater Disabled"
        elif data['pay_later'] == 1:
            msg = "Paylater Enabled"
        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', 'null', 'null')
            return (error.__dict__), 400
        
        store.pay_later = data['pay_later']
        store.updated_at = datetime.datetime.utcnow()

        save_db(store, "Store")
        
        if role != 'merchant':
            store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'status': msg,
                'role': role.capitalize(),
                'template_name': 'store_paylater',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
        apiResponse = ApiResponse(True, msg, 'null', 'null')
        return apiResponse.__dict__, 200

        
    except Exception as e:
        error = ApiResponse(False, 'Unable to Change the Paylater Status', 'null',
                            str(e))
        return (error.__dict__), 500

def store_mis_report(data):
    try:
        start_date = str_to_datetime(data['start_date'])
        end = str_to_datetime(data['end_date']) 
        end_date = end + datetime.timedelta(days=1)

        range_date = start_date + datetime.timedelta(days=60)
        if start_date > datetime.date.utcnow() or end > datetime.date.utcnow():
            apiResponce = ApiResponse(False,"Date cannot be greater than today's date",None,"Date cannot be greater than today's date")
            return (apiResponce.__dict__), 400

        if end_date > range_date:
            apiResponce = ApiResponse(False,'Date Interval Can not be Greater than 60 days',None,None)
            return (apiResponce.__dict__), 400
        
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id  != user_id:
                error = ApiResponse(False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store not found', 'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400
    
        mis_details = StoreMis.query.filter(StoreMis.date >= start_date).filter(StoreMis.date < end_date).filter_by(store_id = data['store_id']).all()

        order_delivered = 0
        order_canceled = 0
        delivery_fees = 0
        skus_added = 0
        total_order_value = 0
        total_discount_value = 0
        commission = 0
        total_tax = 0

        for mis in mis_details:
            order_delivered += mis.order_delivered
            order_canceled += mis.order_canceled
            delivery_fees += mis.delivery_fees
            skus_added += mis.new_items_added
            total_order_value += mis.total_order_value
            total_discount_value += mis.total_discount_value
            commission += mis.commission
            total_tax += mis.total_tax

        turnover = total_order_value - total_discount_value + delivery_fees
        average_order_value = 0

        if order_delivered > 0:
            average_order_value = total_order_value / order_delivered

        return_object = {
            "order_delivered":order_delivered,
            "order_cancelled":order_canceled,
            "skus_added":skus_added,
            "average_order_value":average_order_value,
            "commission":commission,
            "delivery_fees": delivery_fees,
            "total_order_value":total_order_value,
            "total_discount_value":total_discount_value,
            "turnover":turnover,
            "tax" : total_tax,
        }

        apiresponse = ApiResponse(True,f"Store Mis Report From {data['start_date']} to {data['end_date']} is Fetched", return_object, "")

        return apiresponse.__dict__ , 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def store_mis_graph(data):
    try:

        
        start_date = str_to_date(data['start_date'])
        end = str_to_date(data['end_date']) 
        end_date = end + datetime.timedelta(days=1)

        range_date = start_date + datetime.timedelta(days=60)
        if start_date > datetime.date.utcnow() or end > datetime.date.utcnow():
            apiResponce = ApiResponse(False,"Date cannot be greater than today's date",None,"Date cannot be greater than today's date")
            return (apiResponce.__dict__), 400

        if end_date > range_date:
            apiResponce = ApiResponse(False,'Date Interval Can not be Greater than 60 days',None,None)
            return (apiResponce.__dict__), 400
        
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id  != user_id:
                error = ApiResponse(False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

        elif role == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400
        
        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()

        if not store:
            error = ApiResponse(False, 'Store not found', 'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400

        order_canceled = []
        skus_added = []
        new_store_created = []
        average_order_value = []
        total_order_value = []
        delivery_fees = []
        turnover = []
        total_discount_value = []
        order_delivered = []
        commission = []
        total_tax = []

        for date_var in daterange(start_date,end_date):
            
            mis = StoreMis.query.filter(StoreMis.date == date_var).filter_by(store_id = data['store_id']).first()

            if mis:
                
                order_delivered_object = {
                    'Date' : date_to_str(mis.date),
                    'Order Delivered': mis.order_delivered,
                    "dataVal": mis.order_delivered
                }
                order_delivered.append(order_delivered_object)

                order_canceled_object = {
                    'Date' : date_to_str(mis.date),
                    'Order Canceled': mis.order_canceled,
                    "dataVal": mis.order_canceled
                }

                order_canceled.append(order_canceled_object)
                
                skus_added_object = {
                    'Date' : date_to_str(mis.date),
                    'Skus Added': mis.new_items_added,
                    "dataVal": mis.new_items_added
                }
                skus_added.append(skus_added_object)

                average_order_value_object = {
                    'Date' : date_to_str(mis.date),
                    'Average Order Value': mis.average_order_value,
                    "dataVal": mis.average_order_value
                }
                average_order_value.append(average_order_value_object)

                total_order_value_object = {
                    'Date' : date_to_str(mis.date),
                    'Total Order Value': mis.total_order_value,
                    "dataVal": mis.total_order_value
                }
                total_order_value.append(total_order_value_object)
                
                delivery_fees_object = {
                    'Date' : date_to_str(mis.date),
                    'Delivery Fees': mis.delivery_fees,
                    "dataVal": mis.delivery_fees
                }
                delivery_fees.append(delivery_fees_object)

                turnover_object = {
                    'Date' : date_to_str(mis.date),
                    'Turnover': mis.turnover,
                    "dataVal": mis.turnover
                }
                turnover.append(turnover_object)
                
                total_discount_value_object = {
                    'Date' : date_to_str(mis.date),
                    'Total Discount Value': mis.total_discount_value,
                    "dataVal": mis.total_discount_value
                }
                total_discount_value.append(total_discount_value_object)

                commission_object = {
                    'Date' : date_to_str(mis.date),
                    'Commision': mis.commission,
                    "dataVal": mis.commission
                }
                commission.append(commission_object)

                total_tax_object = {
                    'Date' : date_to_str(mis.date),
                    'Total Discount Value': mis.total_tax,
                    "dataVal": mis.total_tax
                }
                total_tax.append(total_tax_object)

                
            
            # else:

            #     date.append(date_to_str(date_var))
            #     customer_added.append(0)
            #     order_canceled.append(0)
            #     skus_added.append(0)
            #     new_store_created.append(0)
            #     average_order_value.append(0)
            #     total_order_value.append(0)
            #     delivery_fees.append(0)
            #     turnover.append(0)
            #     total_discount_value.append(0)
            #     order_delivered.append(0)
        
        return_object = {
            'order_delivered' : order_delivered,
            'order_canceled':order_canceled,
            'skus_added':skus_added,
            'new_store_created':new_store_created,
            'average_order_value':average_order_value,
            'total_order_value' : total_order_value,
            'delivery_fees' : delivery_fees,
            'turnover' : turnover,
            'total_discount_value' : total_discount_value,
            'commission' : commission,
            'total_tax' : total_tax
            
        }
        
        apiResponce = ApiResponse(True,f"Store MIS Graph From {data['start_date']} to {str(data['end_date'])} Fetched Successfully",return_object,'')
        return (apiResponce.__dict__), 200
        

        
    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def get_merchant_details_by_store(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        store_id = data['store_id']
        
        store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).first()
        
        if not store:
            error = ApiResponse(False, 'Store not found!', None, 'The store is either approved or deleted')
            return error.__dict__, 400
        
        if user['role'] == 'supervisor':
            supervisor_city = UserCities.query.filter_by(user_id = user['id']).filter_by(city_id = store.city_id).filter_by(deleted_at = None).all()
        
            if not supervisor_city:
                error = ApiResponse(False, 'Supervisor has no access to approve this Store', None, None)
                return (error.__dict__), 400
            
        merchant = store.merchant
        city = store.city
        
        response_object={
            'name':merchant.name,
            'email':merchant.email,
            'image':merchant.image,
            'phone':merchant.phone,
            'store_owner_name': store.owner_name,
            'store_name': store.name,
            'store_address': str(store.address_line_1) + " " + str(store.address_line_2),
            'city': city.name,
        }
        
        return ApiResponse(True, "Merchant details fetched successfuly",response_object).__dict__, 200
        
                
    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured',None,str(e))
        return (apiResponce.__dict__), 500   
        