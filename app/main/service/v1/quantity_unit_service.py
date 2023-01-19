import datetime

from sqlalchemy.sql.functions import func
from app.main import db
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.quantityUnit import QuantityUnit
from app.main.model.apiResponse import ApiResponse

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/quantity_unit_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_quantity_unit(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        quantity_unit = QuantityUnit(name=data['name'],
                                        short_name=data['short_name'],
                                        conversion=data['conversion'],
                                        type_details=data['type_details'],
                                        status=data['status'],
                                        created_at=datetime.datetime.utcnow())

        db.session.add(quantity_unit)
        db.session.commit()

        apiResponce = ApiResponse(True,
                                    'QuantityUnit Created successfully',
                                    None, None)
        return (apiResponce.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'QuantityUnit Not able to Create', None,
                            str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_quantity_unit(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):

    try:
        quantity_unit = QuantityUnit.query.filter(
            QuantityUnit.id == data['id'],
            QuantityUnit.deleted_at == None).first()

        if quantity_unit:
            quantity_unit.name = data['name']
            quantity_unit.short_name = data['short_name']
            quantity_unit.conversion = data['conversion']
            quantity_unit.type_details = data['type_details']
            quantity_unit.status = data['status']
            quantity_unit.updated_at = datetime.datetime.utcnow()
            
            try:
                db.session.add(quantity_unit)
                db.session.commit()
            

                apiResponce = ApiResponse(True,
                                        'QuantityUnit Updated successfully',
                                        None, None)
                return (apiResponce.__dict__), 202
           
            except Exception as e:
                apiResponce = ApiResponse(False,'Error Occurred',None,f"QuantityUnit Database Error: {str(e)}")
                return (apiResponce.__dict__), 500
        
        else:
            error = ApiResponse(False, 'QuantityUnit Not able to fetch', None,
                                'No Data Found')
            return (error.__dict__), 400
    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occurred',None,str(e))
        return (apiResponce.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def show_quantity_unit():
    """
    Returns a list of all active mapped quantity units
    
    Return type: __dict__, Integer
    """
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):
            records = QuantityUnit.query.filter(
                QuantityUnit.deleted_at == None).order_by(func.lower(QuantityUnit.name)).all()
        else:
            records = QuantityUnit.query.filter(
                QuantityUnit.deleted_at == None).filter_by(status = 1).order_by(func.lower(QuantityUnit.name)).all()

        if records:

            recordObject = []
            for record in records:
                response = {
                    'id': record.id,
                    'name': record.name,
                    'short_name': record.short_name,
                    'conversion': record.conversion,
                    'type_details': record.type_details,
                    'status': record.status,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)
            apiResponce = ApiResponse(True, 'List of All QuantityUnit',
                                      recordObject, None)
            return (apiResponce.__dict__), 200
        
        else:
            error = ApiResponse(False, 'QuantityUnit Not able to fetch', None,
                                'No Data Found')
            return (error.__dict__), 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def delete_quantity_unit(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):

    try:
        storeMenuCategory = QuantityUnit.query.filter_by(id=data['id']).first()

        if storeMenuCategory:

            storeMenuCategory.deleted_at = datetime.datetime.utcnow()
            db.session.commit()

            response_object = {
                'id': storeMenuCategory.id,
                'name': storeMenuCategory.name,
            }
            apiResponce = ApiResponse(True,
                                      'Quantity Unit Successfully Deleted.',
                                      response_object, None)
            return (apiResponce.__dict__), 200

        else:
            apiResponce = ApiResponse(False, 'QuantityUnit does not exists.',
                                      None, None)
            return (apiResponce.__dict__), 404
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500
    
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500