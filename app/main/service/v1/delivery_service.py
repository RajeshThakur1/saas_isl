from sqlalchemy.sql.functions import func
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.hubDa import HubDA
from app.main.model.userCities import UserCities
from app.main.model.store import Store
from flask.globals import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.model.deliveryAgent import DeliveryAgent
from app.main.util.v1.database import save_db
import datetime
from app.main.config import profile_pic_dir

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/delivery_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def get_delivery_agents():
    try:
        delivery_agents = DeliveryAgent.query.filter_by(deleted_at=None).all()

        deliveryObject = []

        for delivery_agent in delivery_agents:
            data = {
                'id': delivery_agent.id,
                'name': delivery_agent.name,
                'api_link': delivery_agent.api_link,
                'status': delivery_agent.status
            }
            deliveryObject.append(data)

        apiResponce = ApiResponse(
            True, 'Deliver Agent Fetched', deliveryObject, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500


def add_delivery_agent(data):

    try:
        delivery_agent = DeliveryAgent.query.filter_by(
            name=data['name']).first()

        if delivery_agent:
            apiResponce = ApiResponse(
                False, 'Delivery Agent Already Added', None, None)
            return (apiResponce.__dict__), 400

        new_da = DeliveryAgent(
            name=data['name'],
            api_link=data['api_link'],
            api_key=data['api_key'],
            status=1,
            created_at=datetime.datetime.utcnow()
        )

        save_db(new_da, "Delivery Agent")
        

        apiResponce = ApiResponse(
            False, 'Delivery Agent Added Successfully', None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500


def update_delivery_agent(data):

    try:
        delivery_agent = DeliveryAgent.query.filter_by(
            name=data['id']).filter_by(deleted_at=None).first()

        if not delivery_agent:
            apiResponce = ApiResponse(
                False, 'Delivery Agent Not Found', None, None)
            return (apiResponce.__dict__), 400

        delivery_agent.name = data['name']
        delivery_agent.api_link = data['api_link']
        delivery_agent.api_key = data['api_key']
        delivery_agent.updated_at = datetime.datetime.utcnow()

        save_db(delivery_agent, "Delivery Agent")
        

        apiResponce = ApiResponse(
            False, 'Delivery Agent Updated Successfully', None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500


def delete_delivery_agent(data):

    try:

        if data['id'] == 1:
            apiResponce = ApiResponse(
                False, 'Cannot Delete Self Delivery', None, None)
            return (apiResponce.__dict__), 400

        delivery_agent = DeliveryAgent.query.filter_by(
            id=data['id']).filter_by(deleted_at=None).first()

        if not delivery_agent:
            apiResponce = ApiResponse(
                False, 'Delivery Agent Not Found', None, None)
            return (apiResponce.__dict__), 400

        delivery_agent.deleted_at = datetime.datetime.utcnow()

        save_db(delivery_agent, "Delivery Agent")
        

        apiResponce = ApiResponse(
            False, 'Delivery Agent Updated Successfully', None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500


def delivery_agent_status_change(data):
    try:
        if data['status'] == 0:
            msg = "Delivery Agent Disabled"
        elif data['status'] == 1:
            msg = "Delivery Agent Enabled"
        else:
            apiResponce = ApiResponse(
                False, 'Wrong Status Code Provided', None, None)
            return (apiResponce.__dict__), 400

        delivery_agent = DeliveryAgent.query.filter_by(
            id=data['id']).filter_by(deleted_at=None).first()

        if not delivery_agent:
            apiResponce = ApiResponse(
                False, 'Delivery Agent Not Found', None, None)
            return (apiResponce.__dict__), 400

        delivery_agent.status = data['status']

        save_db(delivery_agent, "Delivery Agent")
        

        apiResponce = ApiResponse(False, msg, None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

# def set_delivery_agent(data):


def fetch_delivery_agents():
    try:
        agents = DeliveryAgent.query.filter_by(
            status=1).filter_by(deleted_at=None).order_by(func.lower(DeliveryAgent.name)).all()

        response = []
        for agent in agents:

            response.append({
                'name': agent.name,
                'id': agent.id
            })

        # if not response:
        #     error = ApiResponse(False, 'Delivery Agents do not exist', None, None)
        #     return error.__dict__, 400

        resp = ApiResponse(
            True, 'Delivery Agents Fetched Successfully', response, None)
        return resp.__dict__, 200

    except Exception as e:

        error = ApiResponse(False, 'Something Went Wrong', None, str(e))
        return error.__dict__, 500


def set_delivery_agent(data):
    try:
        store_id = data['store_id']
        agent_id = data['agent_id']

        try:
            self_delivery_price = data['delivery_price']
        except:
            self_delivery_price = 0

        user, status = Auth.get_logged_in_user(request)

        role = user['data']['role']
        id = user['data']['id']

        store = Store.query.filter_by(id=store_id).filter_by(
            deleted_at=None).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Invalid Store ID',
                                None, 'Invalid Store Id')
            return error.__dict__, 400

        if role == 'merchant':
            stores = Store.query.filter_by(id=store_id).filter_by(
                deleted_at=None).filter_by(status=1).first()

            if id != stores.merchant_id:
                error = ApiResponse(
                    False, 'Unauthorized Merchant', None, "Merchant is not Authorized")
                return error.__dict__, 400

        store.da_id = agent_id
        if store.da_id == 1:
            if self_delivery_price < 0:
                error = ApiResponse(
                    False, 'Self Delivery Price Can not be negetive', None, None)
                return error.__dict__, 400

            store.self_delivery_price = self_delivery_price

        store.updated_at = datetime.datetime.utcnow()

        save_db(store, 'Success')
        

        response = ApiResponse(True, 'Delivery Agent Successfully Set')
        return response.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong.',
                            None, 'Internal Server Error')
        return error.__dict__, 500


def get_delivery_agent(data):
    try:
        store_id = data['store_id']

        user, status = Auth.get_logged_in_user(request)

        role = user['data']['role']
        id = user['data']['id']

        store = Store.query.filter_by(id=store_id).filter_by(
            deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Invalid Store ID',
                                None, 'Invalid Store Id')
            return error.__dict__, 400

        if role == 'merchant':

            if id != store.merchant_id:
                error = ApiResponse(
                    False, 'Unauthorized Merchant', None, "Merchant is not Authorized")
                return error.__dict__, 400

        elif role == "supervisor":

            supervisor_cities = UserCities.query.filter_by(
                user_id=user['id']).filter_by(deleted_at=None).all()

            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)

            store = Store.query.filter(Store.city_id.in_(
                cities)).filter_by(id=data['store_id']).first()

            if not store:
                error = ApiResponse(
                    False, 'Supervisor has no access to disable this Store', 'null', 'null')
                return (error.__dict__), 400

            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400

        if store.da_id == 1:
            self_delivery_price = store.self_delivery_price
        else:
            self_delivery_price = None

        da = DeliveryAgent.query.filter_by(id=store.da_id).first()

        return_object = None

        if da:
            if da.deleted_at != None:
                deleted = 1
            else:
                deleted = 0

            return_object = {
                'id': store.da_id,
                'name': da.name,
                'self_delivery_price': self_delivery_price,
                'is_deleted': deleted
            }

        response = ApiResponse(
            True, 'Delivery Agent Fetched Successfully', return_object)
        return response.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong.',
                            None, str(e))
        return error.__dict__, 500
