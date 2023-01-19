from app.main.util.v1.database import save_db
from app.main.model.userCities import UserCities
from app.main.model.city import City
import datetime
from app.main import db
from app.main.model.locality import Locality
from sqlalchemy import text
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/locality_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_locality(data):
    """
    Create a new locality
    
    Parameters: json data
    Return type: __dict__, Integer
    """
    try:
        city = City.query.filter_by(id=data['city_id']).filter_by(deleted_at = None).first()

        if city:
            locality = Locality(city_id=data['city_id'],
                                name=data['name'],
                                code=data['code'],
                                pin=data['pin'],
                                delivery_fee=data['delivery_fee'],
                                start_time=data['start_time'],
                                end_time=data['end_time'],
                                status=data['status'],
                                created_at=datetime.datetime.utcnow())
            
            try:

                db.session.add(locality)
                db.session.commit()
                apiResponce = ApiResponse(True, 'Successfully created.', None, None)
                return (apiResponce.__dict__), 201

            
            except Exception as e:
                apiResponce = ApiResponse(False, 'Error Occurred', None, f"Locality Database error: {str(e)}")
                return (apiResponce.__dict__), 500
        
        else:
            apiResponce = ApiResponse(False, 'Error Occurred', None, "Given city id is wrong or deleted")
            return (apiResponce.__dict__), 400


        
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None,
                                str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_locality(data):
    """
    Update details of an exiting locality
    
    Parameters: json data
    Return Type: __dict__, Integer
    """
    try:
        locality = Locality.query.filter(Locality.id == data['id'],
                                         Locality.deleted_at == None).first()

        if locality:
            locality.city_id = data['city_id']
            locality.name = data['name']
            locality.code = data['code']
            locality.pin = data['pin']
            locality.delivery_fee = data['delivery_fee']
            locality.start_time = data['start_time']
            locality.end_time = data['end_time']
            locality.status = data['status']
            locality.updated_at = datetime.datetime.utcnow()

            db.session.commit()

            apiResponce = ApiResponse(True, 'Successfully Updated.', None,
                                      None)
            return (apiResponce.__dict__), 200
        else:
            apiResponce = ApiResponse(False, 'Locality does not exists.', None,
                                      None)
            return (apiResponce.__dict__), 409
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None,
                                str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def show_locality_with_cities():
    """
    Returns a list of all localities with its cities
    
    
    Parameters: json data
    Return Type: __dict__, Integer
    """
    try:
        sql = text('SELECT localities.*,cities.* from localities \
                JOIN cities on cities.id = localities.city_id\
                    where localities.deleted_at IS NULL and\
                    cities.deleted_at IS NULL\
                    ORDER BY localities.id asc')

        result = db.engine.execute(sql)

        locality = []

        for row in result:

            recordObject = {
                'id': row[0],
                'city_id': row[1],
                'name': row[2],
                'code': row[3],
                'pin': row[4],
                'delivery_fee': row[5],
                'start_time': row[6],
                'end_time': row[7],
                'status': row[8],
                'created_at': str(row[9]),
                'updated_at': str(row[10]),
                'deleted_at': str(row[11]),
                'city_details': {
                    'id': row[12],
                    'name': row[13],
                    'code': row[14],
                    'status': row[15],
                    'help_number': row[16],
                    'whats_app_number': row[17],
                    'created_at': str(row[18]),
                    'updated_at': str(row[19]),
                    'deleted_at': str(row[20]),
                }
            }
            locality.append(recordObject)
        apiResponce = ApiResponse(
            True, 'List of All Locality with city Details', locality, None)

        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'City Not able to fetch', None,str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def delete_locality(data):
    """
    Delete a locality from a list of servicable localities
    
    
    Parameters: json data
    Return Type: __dict__, Integer
    """
    try:
        locality = Locality.query.filter_by(id=data['id']).first()

        if locality:
            locality.deleted_at = datetime.datetime.utcnow()

            db.session.commit()

            apiResponce = ApiResponse(True, 'Successfully Deleted', None, None)
            return (apiResponce.__dict__), 200
        else:
            apiResponce = ApiResponse(False, 'Locality does not exists.', None,
                                      None)
            return (apiResponce.__dict__), 409

    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None,
                                str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def show_locality_with_cities_by_city_id(data):

    """
    Show all localities by city id
    
    Parameters: json data
    Return Type: __dict__, Integer"""

    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')):
    try:
        sql = text('SELECT localities.*,cities.* from localities \
                JOIN cities on cities.id = localities.city_id\
                where cities.id = :city_id\
                and localities.deleted_at IS NULL \
                and cities.deleted_at IS NULL \
                ORDER BY localities.id asc')

        result = db.engine.execute(sql, {
            'city_id': data['city_id'],
        })

        locality = []

        for row in result:

            recordObject = {
                'id': row[0],
                'city_id': row[1],
                'name': row[2],
                'code': row[3],
                'pin': row[4],
                'delivery_fee': row[5],
                'start_time': row[6],
                'end_time': row[7],
                'status': row[8],
                'created_at': str(row[9]),
                'updated_at': str(row[10]),
                'deleted_at': str(row[11]),
                'city_details': {
                    'id': row[12],
                    'name': row[13],
                    'code': row[14],
                    'status': row[15],
                    'help_number': row[16],
                    'whats_app_number': row[17],
                    'created_at': str(row[18]),
                    'updated_at': str(row[19]),
                    'deleted_at': str(row[20]),
                }
            }
            locality.append(recordObject)
        apiResponce = ApiResponse(
            True, 'List of All Locality with city Details', locality, None)

        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(
            False, 'City Not able to fetch', None,
            str(e)
        )
        return (error.__dict__), 500
    
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500

def get_supervisor_city_localities(data):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        usercities = UserCities.query.filter_by(user_id = user['id']).filter_by(city_id = data['city_id']).filter_by(deleted_at = None).first()

        if not usercities:
            apiResponce = ApiResponse(False,'Supervisor Can not see the Given City Details', None, 'Supervisor id and city id not matched')
            return (apiResponce.__dict__), 400

        localities = Locality.query.filter_by(city_id = data['city_id']).filter_by(deleted_at = None).all()

        locality_object = []

        for locality in localities:
            object ={
                'id':locality.id,
                'name':locality.name,
                'code':locality.code,
                'pin':locality.pin,
                'delivery_fee': locality.delivery_fee,
                'start_time': locality.start_time,
                'end_time': locality.end_time
            }

            locality_object.append(object)
        
        apiResponce = ApiResponse(True,'Locality Details Fetched', locality_object, None)
        return (apiResponce.__dict__), 200
            
        
    except Exception as e:
        apiResponce = ApiResponse(False,
                                      'Error Occurred',
                                      None, str(e))
        return (apiResponce.__dict__), 500


def supervisor_update_localities(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        usercities = UserCities.query.filter_by(user_id = user['id']).filter_by(city_id = data['city_id']).filter_by(deleted_at = None).first()

        if not usercities:
            apiResponce = ApiResponse(False,'Supervisor Can not see the Given City Details', None, 'Supervisor id and city id not matched')
            return (apiResponce.__dict__), 400

        localities = Locality.query.filter_by(city_id = data['city_id']).filter_by(deleted_at = None).all()
        for locality in localities:
            locality.delivery_fee = data['delivery_fee']
            locality.start_time = data['start_time']
            locality.end_time = data['end_time']
            locality.updated_at = datetime.datetime.utcnow()
            error = (locality, "Locality")
            if error:
                return error,500
        
        apiResponce = ApiResponse(True,'Parameters Updated Successfully', None, None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        apiResponce = ApiResponse(False,
                                      'Error Occurred',
                                      None, str(e))
        return (apiResponce.__dict__), 500