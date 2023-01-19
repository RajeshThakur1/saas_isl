from app.main.config import ENDPOINT_PREFIX
from app.main.model.userCities import UserCities
from app.main.model.locality import Locality
import datetime
from app.main import config, db
from flask import request, url_for
from app.main.service.v1.auth_helper import Auth
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import sql, text, func
from app.main.util.v1.database import get_count, save_db

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/city_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_city(data):
    """
    Create Servicable City
    
    parameters: json data
    Return type: __dict__, Integer
    """
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'custmer')):

    # try:
    #     x = int(data['name'])
    #     error = ApiResponse(False, 'City not Created', None, 'City name can only be String')
    #     return error.__dict__, 400
    # except ValueError:
    #     pass

    # try:
    #     x = int(data['code'])
    #     error = ApiResponse(False, 'City not Created', None, 'City code can only be String')
    #     return error.__dict__, 400
    # except ValueError:
    #     pass

    # try:
    #     x = int(data['help_number'])
    # except ValueError:
    #     error = ApiResponse(False, 'City not Created', None, 'Help number can only be a number')
    #     return error.__dict__, 400

    # try:
    #     x = int(data['whats_app_number'])
    # except ValueError:
    #     error = ApiResponse(False, 'City not Created', None, 'Whatsapp number can only be a number')
    #     return error.__dict__, 400

    

    if not len(data['help_number']) == 10:
        error = ApiResponse(False, 'City not Created', None, 'Helpline number must be 10 digits')
        return error.__dict__, 400

    if not len(data['whats_app_number']) == 10:
        error = ApiResponse(False, 'City not Created', None, 'Whatsapp number must be 10 digits')
        return error.__dict__, 400

    if data['status'] not in [0,1]:
        error = ApiResponse(False, ' Wrong City Status Code', None, 'City Status Should be 0 and 1')
        return error.__dict__, 400



    try:
        city = City(name=data['name'],
                    code=data['code'],
                    status=data['status'],
                    help_number=data['help_number'],
                    whats_app_number=data['whats_app_number'],
                    created_at=datetime.datetime.utcnow())

        db.session.add(city)
        db.session.commit()

        apiResponce = ApiResponse(True, 'City Created successfully', None,
                                    None)
        return (apiResponce.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'City Not able to Create', None, str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_city(data):

    """
    Update details of a servicable city
    
    
    Parameters: json data
    Return type: __dict__, Integer
     """
    # print("test")
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')):

    try:
        city = City.query.filter(City.id == data['id'],
                                 City.deleted_at == None).first()

        if city:
            city.name = data['name']
            city.code = data['code']
            city.status = data['status']
            city.help_number = data['help_number']
            city.whats_app_number = data['whats_app_number']
            city.updated_at = datetime.datetime.utcnow()

            db.session.commit()

            apiResponce = ApiResponse(True, 'City Updated successfully', None,
                                      None)
            return (apiResponce.__dict__), 202
        else:
            error = ApiResponse(
                False, 'No City Found, Make Sure to Create a New City', None,
                "Either the city id is given wrong or City may be deleted")
            return (error.__dict__), 400
    
    except Exception as e:
        error = ApiResponse(False, 'City Not able to Create', None, str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500



def show_city(data):

    """
    Returns the list of all servicable cities
    
    Parameters: json data
    Return type: __dict__, Integer
    """
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'customer')):
        
    try:

        page = 1
        items_per_page = 10
        try:
            page = int(data.get('page'))
        except Exception as e:
            pass

        try:
            items_per_page = int(data.get('items'))
        except Exception as e:
            pass
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        
        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        records = City.query.filter(City.deleted_at == None).paginate(page, items_per_page, False)
        recordObject = []
        for record in records.items:
            response = {
                'id': record.id,
                'name': record.name,
                'code': record.code,
                'status': record.status,
                'help_number': record.help_number,
                'whats_app_number': record.whats_app_number,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
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

        apiResponce = ApiResponse(True, 'List of All Cities', return_obj,
                                    None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'City Not able to fetch', None, str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500



def show_all_city(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')
    #         or (user.role == 'customer')):
        
    try:

        records = City.query.filter_by(status = 1).order_by(City.name).filter(City.deleted_at == None).all()
        recordObject = []
        for record in records:
            response = {
                'id': record.id,
                'name': record.name,
                'code': record.code,
                'status': record.status,
                'help_number': record.help_number,
                'whats_app_number': record.whats_app_number,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)


        apiResponce = ApiResponse(True, 'List of All Cities', recordObject,
                                    None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'City Not able to fetch', None, str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500



def delete_city(data):
    """
    Remove a city from the list of servicable cities
    
    Parameters: json data
    Return Type: __dict__, Integer"""
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')):

    try:
        city_locality_map = Locality.query.filter(
            Locality.city_id == data['id'],
            Locality.deleted_at == None).first()

        if city_locality_map:
            error = ApiResponse(
                False, 'City has localities Mapped delete them first', None,
                None)
            return (error.__dict__), 500

        else:
            city = City.query.filter_by(id=data['id']).first()

            if city:
                if city.deleted_at == None:
                    city.deleted_at = datetime.datetime.utcnow()

                    save_db(city)
                    # try:
                    #     db.session.add(city)
                    #     db.session.commit()
                    #     apiResponce = ApiResponse(True, 'City Deleted Successfully',
                    #                         None, None)
                    #     return (apiResponce.__dict__), 201
                    #
                    # except Exception as e:
                    #     db.session.rollback()
                    #     apiResponce = ApiResponse(True, 'Error Occurred',
                    #                         None, "City Database Error: str(e)")
                    #     return (apiResponce.__dict__), 500
                else:
                    apiResponce = ApiResponse(False, 'City allready Deleted.', None,
                                          'Given City ID Allready Deleted')
                    return (apiResponce.__dict__), 400

            else:
                apiResponce = ApiResponse(False, 'City does not exists.', None,
                                          'Given City ID Not Found')
                return (apiResponce.__dict__), 400
    
    except Exception as e:
        error = ApiResponse(False, 'City Not able to fetch', 'none', str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def create_supervisor_city_map(data):
    try:
        for record in data['city_id']:

            user_city_map = UserCities(city_id=record,
                                       user_id=data['supervisor_id'],
                                       role="supervisor",
                                       created_at=datetime.datetime.utcnow())
            save_db(user_city_map)
            # db.session.add(user_city_map)
            # db.session.commit()

        response_object = {
            'status': True,
            'message': 'supervisor City Mapped Successfully.',
            'data': None,
            'error': None,
        }
        return response_object, 200
    except Exception as e:
        response_object = {
            'status': True,
            'message': 'Internal Server Error',
            'data': None,
            'error': str(e),
        }
        return response_object, 500


def fetch_supervisor_city_map(data):

    try:
        sql = text(
            'SELECT user_cities.id,user_cities.user_id,cities.id as city_id,\
            cities.name,cities.code,cities.status,cities.help_number,cities.created_at\
            from user_cities join cities on user_cities.city_id = cities.id\
            where user_cities.user_id = :supervisor_id and user_cities.deleted_at IS NULL;'
        )

        result = db.engine.execute(sql, {'supervisor_id': data['supervisor_id']})
        record = []

        for row in result:

            print(row)
            recordObject = {
                'id': row[0],
                'user_id': row[1],
                'city_id': row[2],
                'name': row[3],
                'code': row[4],
                'status': row[5],
                'help_number': row[6],
                'created_at': str(row[7])
            }
            record.append(recordObject)

        apiResponce = ApiResponse(
            True, 'List of All Supervisor City Map Details',
            record, None)

        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Supervisor City Map Not able to fetch',
                            None, str(e))
        return (error.__dict__), 500



def delete_supervisor_city_map(data):
    try:
        userCItyMap = UserCities.query.filter_by(
            id=data['id']).first()

        if userCItyMap:
            userCItyMap.deleted_at = datetime.datetime.utcnow()
            save_db(userCItyMap)
            #db.session.commit()

            apiResponce = ApiResponse(True,
                                      'Store Category Successfully Deleted.',
                                      None, None)
            return (apiResponce.__dict__), 200

        else:
            apiResponce = ApiResponse(False,
                                      'Store Category Map does not exists.',
                                      None, None)
            return (apiResponce.__dict__), 200
    except Exception as e:
        apiResponce = ApiResponse(False,
                                      'Internal Server Error',
                                      None, str(e))
        return (apiResponce.__dict__), 500

def get_city_names():
    """
    Get the names of all servicable cities

    Return type: __dict__, int
    """
    try:
        cities = City.query.filter_by(deleted_at = None).all()
        
        city_object = []

        if cities:
            for city in cities:
                data = {
                    'id' : city.id,
                    'name' : city.name
                }

                city_object.append(data)
        
        apiResponce = ApiResponse(True,
                                      'City Details Fetched',
                                      city_object, None)
        return (apiResponce.__dict__), 200
    
    except Exception as e:
        apiResponce = ApiResponse(False,
                                      'Internal Server Error',
                                      None, str(e))
        return (apiResponce.__dict__), 500


def get_supervisor_city():
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        try:
            pagination = int(request.args.get('pagination'))
        except:
            pagination = 1    
        
        try:
            page_no = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10
        
        if pagination not in [0,1]:
            apiresponse = ApiResponse(
                False, "Wrong Pagination Code Provided", None, None)
            return apiresponse.__dict__, 400
        
        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no == 0:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        if pagination == 1:
            usercities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).paginate(page_no, item_per_page, False)

            city_object =[]
            for usercity in usercities.items:
                city = City.query.filter_by(id = usercity.city_id).filter_by(deleted_at = None).first()
                if city:
                    data = {
                        'id' : city.id,
                        'name' : city.name,
                        'code' : city.code,
                        'whats_app_number' : city.whats_app_number,
                        'help_number' : city.help_number if city.help_number else None,
                    }
                    city_object.append(data)
            return_obj = {
                'page': usercities.page,
                'total_pages': usercities.pages,
                'has_next_page': usercities.has_next,
                'has_prev_page': usercities.has_prev,
                'prev_page': usercities.prev_num,
                'next_page': usercities.next_num,
                # 'prev_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor cities',
                #                                            page=usercities.prev_num) if usercities.has_prev else None,
                # 'next_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor cities',
                #                                            page=usercities.next_num) if usercities.has_next else None,
                # 'current_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor Order_get_orders', page=page_no),
                'items_per_page': usercities.per_page,
                'items_current_page': len(usercities.items),
                'total_items': usercities.total,
                'items': city_object
            }
            
        else:
            usercities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()

            city_object =[]
            for usercity in usercities:
                city = City.query.filter_by(id = usercity.city_id).filter_by(deleted_at = None).first()
                if city:
                    data = {
                        'id' : city.id,
                        'name' : city.name,
                        'code' : city.code,
                        'whats_app_number' : city.whats_app_number,
                        'help_number' : city.help_number if city.help_number else None,
                    }
                    city_object.append(data)

            return_obj = city_object
        
        apiResponce = ApiResponse(True,"Supervisor Cities Fetched",return_obj,None)

        return apiResponce.__dict__, 200

    except Exception as e:
        apiResponce = ApiResponse(False,
                                      'Error Occurred',
                                      None, str(e))
        return (apiResponce.__dict__), 500

