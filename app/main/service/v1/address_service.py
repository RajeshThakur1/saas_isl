from app.main.model.itemOrders import ItemOrder
import datetime
from app.main import db
from flask import request
from app.main.model.userAddress import UserAddress
from app.main.model.user import User
from app.main.service.v1.auth_helper import Auth
from haversine import haversine, Unit
from flask import jsonify, make_response
from app.main.model.apiResponse import ApiResponse
from app.main.util.v1.decorator import *
from app.main.util.v1.database import save_db
from app.main.model.city import City
from app.main.model.store import Store
from sqlalchemy import func
import re

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/address_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def address_by_cart_id(data):
    try:

        user, resp = Auth.get_logged_in_user(request)

        user_id = user['data']['id']

        cart_id= data['cart_id']
        try:
            id = re.search(r"\d+(\.\d+)?", cart_id)
            id = int(id.group(0))
        
        except Exception as e:
            apiResponce = ApiResponse(
            False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
            return (apiResponce.__dict__), 400
        
        cart_id = id

        cart  = ItemOrder.query.filter_by(id=cart_id).filter_by(deleted_at=None).filter_by(order_created=None).first()

        if not cart:
            error = ApiResponse(False, 'Cart not found!', None, 'Cart does not exist or is deleted ')
            return (error.__dict__), 400

        store = Store.query.filter_by(id=cart.store_id).filter_by(deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Store not found!', None, 'Store does not exist or is deleted ')
            return (error.__dict__), 400

        city_id = store.city_id
        city_name = City.query.filter_by(id=city_id).filter_by(deleted_at=None).first()

        if not city_name:
            error = ApiResponse(False, 'City not found!', None, 'City does not exist or is deleted ')
            return (error.__dict__), 400


        addresses = UserAddress.query.filter_by(city_id=city_id).filter_by(deleted_at=None).filter_by(user_id=user_id).all()

        if not addresses:
            error = ApiResponse(False, 'Address not found!', None, 'Address does not exist or is deleted ')
            return (error.__dict__), 400

        resp_data = []
        for address in addresses:
            resp = {
                "id": address.id,
                "city": City.query.filter_by(id=address.city_id).filter_by(deleted_at=None).first().name,
                "address1":address.address1,
                "address2":address.address2,
                "address3":address.address3,
                "landmark":address.landmark,
                "phone":address.phone,
                "lat": address.latitude,
                "long": address.longitude
            }
            resp_data.append(resp)
        
        api_resp = ApiResponse(True, 'Addresses Fetched Successfully', resp_data, None)
        return api_resp.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500
        


def Address_opration(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user  = resp['data']
        user_id = user['id']

        city = City.query.filter(func.lower(City.name) == func.lower(data['city'])).filter_by(deleted_at = None).filter_by(status = 1).first()

        if not city:
            apiResponce = ApiResponse(False,"We don't provide Service int the Given City")
            return (apiResponce.__dict__), 201
        
        new_address = UserAddress(user_id=user_id,
                                address1=data['address1'],
                                address2=data['address2'],
                                address3=data['address3'],
                                landmark=data['landmark'],
                                latitude=data['lat'],
                                longitude=data['long'],
                                phone=data['phone'],
                                city_id = city.id,
                                created_at=datetime.datetime.utcnow())
        save_db(new_address)
        # try:
        #     db.session.add(new_address)
        #     db.session.commit()

        #     apiResponce = ApiResponse(True,'Successfully created.',"",None)
        #     return (apiResponce.__dict__), 201
        
        # except Exception as e:
        #     db.session.rollback()
        #     error = ApiResponse(False, 'Error Occurred', None, f"UserAddress Database Error : {str(e)}")
        #     return (error.__dict__), 500

    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500


# @token_required
# def show_address():
#     user = Auth.get_logged_in_user(request)

# @token_required
def show_address():
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        result=[]
        address = UserAddress.query.filter_by(user_id=user['id']).all()
  
        for add in address:
            city = City.query.filter_by(id = add.city_id).first()
            if city:
                city_name = city.name
            else:
                city_name = None
            result.append({
                'id':add.id,
                'address1':add.address1,
                'address2':add.address2,
                'address3':add.address3,
                'landmark':add.landmark,
                'latitude':add.latitude,
                'longitude':add.longitude,
                'city' : city_name,
                'phone':add.phone
                })

            
        apiResponce = ApiResponse(True,'Get All Address of' + user['name'] ,result,None)
        return (apiResponce.__dict__), 201

    except Exception as e:
        apiResponce = ApiResponse(False,'Internal Server Error',"",str(e))
        return (apiResponce.__dict__), 500



def update_address(data):
    try:
        address = UserAddress.query.filter_by(id=int(data['id'])).filter_by(deleted_at=None).first()

        if not address:
            error = ApiResponse(False, 'Address Not Found', [], "Address does not exist or is deleted")
            return (error.__dict__), 400
        
        city = City.query.filter(func.lower(City.name) == func.lower(data['city'])).first()

        if not city:
            apiResponce = ApiResponse(False,"We don't provide Service int the Given Service","","")
            return (apiResponce.__dict__), 201
        print("==========>>",address.address1)

        if address:
            address.address1 = data['address1']
            address.address2 = data['address2']
            address.address3 = data['address3']
            address.landmark = data['landmark']
            address.phone = data['phone']
            address.latitude = data['lat']
            address.longitude = data['long']
            address.city_id = city.id
            save_db(address, 'Address')
            
            # try:
            #     db.session.add(address)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     apiResponce = ApiResponse(
            #         False, 'Error Occurd',
            #         'null', f'Database user_address : {str(e)}')
            #     return (apiResponce.__dict__), 500

            response_object = {
                'success': "success",
                'message': 'Successfully Updated.',
                'data':'',
                'error':None,

            }
            return response_object, 201
        else:
            response_object = {
                'success': False,
                'message': 'Address does not exists.',
                'data':None,
                'error':'Address does not exists.'
                
            }
            return response_object, 409
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500


def delete_address(data):
    try:
        address = UserAddress.query.filter_by(id=data['id']).first()
        if address:
            db.session.delete(address)
            db.session.commit()
            response_object = {
                'success': True,
                'message': 'Successfully Deleted.',
                'data':'',
                'error':None
            }
            return response_object, 200
        else:
            response_object = {
                'success': False,
                'message': 'Address does not exists.',
                'data': None,
                'error':'Address does not exists'
            }
            return response_object, 400
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500
