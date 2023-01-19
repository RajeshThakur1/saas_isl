import datetime
from app.main.model.apiResponse import ApiResponse
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.hubOrderPayments import HubOrderPayments
from app.main.model.hubOrders import HubOrders
from app.main.model.userCities import UserCities
from app.main.service.v1.auth_helper import Auth
from flask import request
from app.main.service.v1.notification_service import CreateNotification
from app.main.util.v1.database import save_db

from app.main.util.v1.dateutil import str_to_date, date_to_str

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/hub_order_payment_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def add_hub_order_payment(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        
        hub_order = HubOrders.query.filter_by(id = data['hub_order_id']).filter_by(deleted_at = None).first()

        if not hub_order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
        
        hub = hub_order.hub

        if role == 'distributor':
            if user_id != hub.distributor_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to Add Payments')
                return (apiResponce.__dict__), 403
        
        elif role == 'delivery_associate':
            if user_id != hub_order.da_id:
                apiResponce = ApiResponse(False, 'Delivery associate has No access to Add Payments')
                return (apiResponce.__dict__), 403
        
        else:
            apiResponce = ApiResponse(False, 'User has No access to Add Payments')
            return (apiResponce.__dict__), 403 

        if hub_order.order_created == None:
            apiResponce = ApiResponse(False, 'Order is Not Created Yet')
            return (apiResponce.__dict__), 400
        
        if hub_order.order_confirmed == None:
            apiResponce = ApiResponse(False, 'Order is Not Accepted by the Distributor Yet')
            return (apiResponce.__dict__), 400

        if hub_order.merchant_confirmed == None:
            apiResponce = ApiResponse(False, 'Order is Not Confirmed by the Merchant Yet')
            return (apiResponce.__dict__), 400
        
        if hub_order.due_payment == 0:
            apiResponce = ApiResponse(False, 'No Due Payment Found')
            return (apiResponce.__dict__), 400
        
        date = str_to_date(data['payment_date'])
        
        if date >= datetime.datetime.utcnow()+datetime.timedelta(days=1):
            apiResponce = ApiResponse(False, f"Payment Date is More than Today's date")
            return (apiResponce.__dict__), 400
        
        
        if hub_order.due_payment != None and hub_order.due_payment < data['amount']:
            apiResponce = ApiResponse(False, f"Due Amount is {hub_order.due_payment} where given amount is {data['amount']}")
            return (apiResponce.__dict__), 400

        old_payments = HubOrderPayments.query.filter_by(hub_order_id = hub_order.id).filter_by(deleted_at = None).all()

        all_paid = 0
        not_confirmed = 0

        for old_payment in old_payments:
            all_paid += old_payment.amount
            if old_payment.confirmed == 0:
                not_confirmed += 1
        
        if hub_order.grand_order_total - all_paid < data['amount']:
            if not_confirmed != 0:
               apiResponce = ApiResponse(False, f"{not_confirmed} Payments are Pending for Confirmation, Either Wait for Merchant to Confirm them or Delete te Pending Ones")
               return (apiResponce.__dict__), 400 

            else:
                hub_order.due_payment = hub_order.grand_order_total - all_paid
                save_db(hub_order)
                

                apiResponce = ApiResponse(False, f"Due Amount is {hub_order.due_payment} where given amount is {data['amount']}")
                return (apiResponce.__dict__), 400
        
        new_payment = HubOrderPayments(
            hub_order_id = hub_order.id,
            amount = data['amount'],
            payment_date = str_to_date(data['payment_date']),
            confirmed = 0,
            added_by_id = user_id,
            added_by_role = role,
            created_at = datetime.datetime.utcnow()
        )

        save_db(new_payment)
        
        
        user = hub_order.merchant
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_payment_add',
            'order_id': str(hub_order.id),
            'amount' : str(data['amount']),
            'date' : data['payment_date']
            
                
        }
        CreateNotification.gen_notification_v2(user, notification_data)

        apiResponce = ApiResponse(True, f"Transaction Added Successfully, Wait for Merchant to Confirm it")
        return (apiResponce.__dict__), 200 

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def get_hub_order_payment(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        
        hub_order = HubOrders.query.filter_by(id = data['hub_order_id']).filter_by(deleted_at = None).first()

        if not hub_order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
        
        hub = hub_order.hub

        if role == 'distributor':
            if user_id != hub.distributor_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role == 'delivery_associate':
            if user_id != hub_order.da_id:
                apiResponce = ApiResponse(False, 'Delivery associate has No access to See Order Payments')
                return (apiResponce.__dict__), 403

        elif role == 'merchant':
            if user_id != hub_order.merchant_id:
                apiResponce = ApiResponse(False, 'Merchant has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to Add Payments')
            return (apiResponce.__dict__), 403 
        
        payments = HubOrderPayments.query.filter_by(hub_order_id = hub_order.id).filter_by(deleted_at = None).order_by(HubOrderPayments.payment_date).all()

        confirmed_paid = 0
        not_confirmed_paid = 0

        timeline = []        

        for payment in payments:
            user = None
            if payment.added_by_role == 'delivery_associate':
                user = DeliveryAssociate.query.filter_by(id = payment.added_by_id).first()

            elif payment.added_by_role == 'distributor':
                user = Distributor.query.filter_by(id = payment.added_by_id).first()

            if user:
                user_name = user.name
            
            else:
                user_name = None

            if payment.confirmed == 0:
                not_confirmed_paid += payment.amount

            else:
                confirmed_paid += payment.amount
                
            timeline.append({
                    'id' : payment.id,
                    'amount': payment.amount,
                    'payment_date': date_to_str(payment.payment_date),
                    'added_by':{
                        'name' : user_name,
                        'role': payment.added_by_role,
                    },
                    'confirmed': payment.confirmed
                })

        total_paid = confirmed_paid + not_confirmed_paid

        return_object = {
            'timeline' : timeline,
            'total_paid': total_paid,
            'confirmed_paid' : confirmed_paid,
            'not_confirmed_paid' : not_confirmed_paid,
        }

        apiResponce = ApiResponse(True, f"Order Payment Details Fetched Successfully", return_object)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def update_hub_order_payment(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        
        hub_order = HubOrders.query.filter_by(id = data['hub_order_id']).filter_by(deleted_at = None).first()

        if not hub_order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
        
        hub = hub_order.hub

        if role == 'distributor':
            if user_id != hub.distributor_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role == 'delivery_associate':
            if user_id != hub_order.da_id:
                apiResponce = ApiResponse(False, 'Delivery associate has No access to See Order Payments')
                return (apiResponce.__dict__), 403

        else:
            apiResponce = ApiResponse(False, 'User has No access to Add Payments')
            return (apiResponce.__dict__), 403 

        payment = HubOrderPayments.query.filter_by(id = data['payment_id']).filter_by(deleted_at = None).first()

        if payment.added_by_role == 'distributor' and role == 'delivery_associate':
            error = ApiResponse(
                False, "Delivery Associate have no Access to Update this detail", None)
            return error.__dict__, 400

        if payment.confirmed == 1:
            error = ApiResponse(
                False, "Confirmed Payment Cannot be updated", None)
            return error.__dict__, 400
        
        if payment.hub_order_id != hub_order.id:
            error = ApiResponse(
                False, "Payment is not belong to the Given Order Id", None)
            return error.__dict__, 400
        
        date = str_to_date(data['payment_date'])
        
        if date >= datetime.datetime.utcnow()+datetime.timedelta(days=1):
            apiResponce = ApiResponse(False, f"Payment Date is More than Today's date")
            return (apiResponce.__dict__), 400
        
        if hub_order.due_payment == 0:
            apiResponce = ApiResponse(False, 'No Due Payment Found')
            return (apiResponce.__dict__), 400
        
        if hub_order.due_payment != None and hub_order.due_payment < data['amount']:
            apiResponce = ApiResponse(False, f"Due Amount is {hub_order.due_payment} where given amount is {data['amount']}")
            return (apiResponce.__dict__), 400

        old_payments = HubOrderPayments.query.filter_by(hub_order_id = hub_order.id).filter_by(deleted_at = None).all()

        all_paid = payment.amount * -1
        not_confirmed = -1

        for old_payment in old_payments:
            all_paid += old_payment.amount
            if old_payment.confirmed == 0:
                not_confirmed += 1
        
        if hub_order.grand_order_total - all_paid < data['amount']:
            if not_confirmed != 0:
               apiResponce = ApiResponse(False, f"{not_confirmed} Payment Confirmation is Pending, Either Wait for Merchant to Confirm them or Delete te Pending Ones")
               return (apiResponce.__dict__), 400 

            else:
                hub_order.due_payment = hub_order.grand_order_total - all_paid
                save_db(hub_order)
                
                apiResponce = ApiResponse(False, f"Due Amount is {hub_order.due_payment} where given amount is {data['amount']}")
                return (apiResponce.__dict__), 400

        prev_amount = payment.amount
        prev_date = date_to_str(payment.payment_date) 
        payment.amount = data['amount']
        payment.payment_date = str_to_date(data['payment_date'])                
        payment.confirmed = 0,
        payment.added_by_id = user_id,
        payment.added_by_role = role,
        payment.updated_at = datetime.datetime.utcnow()

        save_db(payment)
        

        user = hub_order.merchant
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_payment_update',
            'order_id': str(hub_order.id),
            'amount' : str(data['amount']),
            'date' : data['payment_date'],
            'prev_date' : prev_date,
            'prev_amount': prev_amount
            
                
        }
        CreateNotification.gen_notification_v2(user, notification_data)
        
        apiResponce = ApiResponse(True, f"Transaction Details Updated Successfully, Wait for Merchant to Confirm it")
        return (apiResponce.__dict__), 200 

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def delete_hub_order_payment(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        
        hub_order = HubOrders.query.filter_by(id = data['hub_order_id']).filter_by(deleted_at = None).first()

        if not hub_order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
        
        hub = hub_order.hub

        if role == 'distributor':
            if user_id != hub.distributor_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role == 'delivery_associate':
            if user_id != hub_order.da_id:
                apiResponce = ApiResponse(False, 'Delivery associate has No access to See Order Payments')
                return (apiResponce.__dict__), 403

        else:
            apiResponce = ApiResponse(False, 'User has No access to Add Payments')
            return (apiResponce.__dict__), 403 

        payment = HubOrderPayments.query.filter_by(id = data['payment_id']).filter_by(deleted_at = None).first()

        if payment.added_by_role == 'distributor' and role == 'delivery_associate':
            error = ApiResponse(
                False, "Delivery Associate have no Access to Update this detail", None)
            return error.__dict__, 400

        if payment.confirmed == 1:
            error = ApiResponse(
                False, "Confirmed Payment Cannot be Deleted", None)
            return error.__dict__, 400
        
        if payment.hub_order_id != hub_order.id:
            error = ApiResponse(
                False, "Payment is not belong to the Given Order Id", None)
            return error.__dict__, 400

        payment.deleted_at = datetime.datetime.utcnow()
        payment.confirmed = 1
        save_db(payment)
        


        apiResponce = ApiResponse(True, f"Transaction Details Deleted Successfully")
        return (apiResponce.__dict__), 200 

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def confirm_hub_order_payment(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        confirm = data['confirm']
        hub_order = HubOrders.query.filter_by(id = data['hub_order_id']).filter_by(deleted_at = None).first()

        if not hub_order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        if role != 'merchant':
            apiResponce = ApiResponse(False, 'User has no access to see this order')
            return (apiResponce.__dict__), 403
        
        if user_id != hub_order.merchant_id:
            apiResponce = ApiResponse(False, 'Merchant has No access to See Order Payments')
            return (apiResponce.__dict__), 403
        
        payment = HubOrderPayments.query.filter_by(id = data['payment_id']).filter_by(deleted_at = None).first()
        
        if confirm not in [0,1]:
            error = ApiResponse(
                False, "Wrong Status Code", None)
            return error.__dict__, 400
        
        if payment.confirmed == 1:
            error = ApiResponse(
                False, "Payment Allready Confiremd", None)
            return error.__dict__, 400
        
        if payment.hub_order_id != hub_order.id:
            error = ApiResponse(
                False, "Payment is not belong to the Given Order Id", None)
            return error.__dict__, 400
        
        if hub_order.due_payment == 0:
            apiResponce = ApiResponse(False, 'No Due Payment Found')
            return (apiResponce.__dict__), 400

        payment.confirmed = confirm
        save_db(payment)

        
        
        payments = HubOrderPayments.query.filter_by(hub_order_id = hub_order.id).filter_by(deleted_at = None).filter_by(confirmed = 1).all()

        total_paid = 0
        for payment in payments:
            total_paid += payment.amount
        
        if hub_order.total_paid == 0 or hub_order.total_paid == None or hub_order.payment_status == 0:
            hub_order.payment_status = 1

        hub_order.total_paid = total_paid
        hub_order.due_payment = hub_order.grand_order_total - total_paid

        if hub_order.grand_order_total == hub_order.total_paid:
            hub_order.payment_status = 2

        save_db(hub_order)
        

        hub = hub_order.hub
        
        distributor = hub.distributor
        
        if confirm == 1:
            payment_status = "Confirmed"
        
        else:
            payment_status = "Rejected"
                                        
        notification_data = {
            'template_name': 'hub_order_confirm_payment',
            'status' : payment_status,
            'order_id': str(hub_order.id),
            'amount' : str(payment.amount),
            'date': date_to_str(payment.payment_date)
        }
        CreateNotification.gen_notification_v2(distributor, notification_data)
        
        apiResponce = ApiResponse(True, f'Transaction {payment_status}')
        return (apiResponce.__dict__), 200


    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

