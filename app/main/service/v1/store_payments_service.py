from datetime import datetime
from uuid import uuid4
from flask import request
from app.main import config
from app.main.model import merchant
from app.main.model.apiResponse import ApiResponse
from app.main.model.itemOrders import ItemOrder
from app.main.model.store import Store
from app.main.model.storePayments import StorePayment
from app.main.model.store_bankdetails import StoreBankDetails
from app.main.model.user import User
from app.main.model.userCities import UserCities
from app.main.service.v1.auth_helper import Auth
from app.main.util.v1.database import save_db
from sqlalchemy import or_, func

from app.main.util.v1.dateutil import if_date, if_date_time

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/store_payment_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_store_payments():
    try:
        item_orders = ItemOrder.query.filter(ItemOrder.order_created != None).filter(ItemOrder.transaction_id != None).filter_by(store_payment_id = None).all()
        
        orders = {}
        for item_order in item_orders:
            if str(item_order.store_id) not in orders.keys():
                orders[str(item_order.store_id)] = []
                
            orders[str(item_order.store_id)].append(item_order)
            
        for k in orders.keys():
            grand_total_amount = 0
            total_amount = 0
            commission = 0
            for order in orders[k]:
                grand_total_amount += order.grand_order_total
                total_amount += order.order_total
                if order.commission:
                    commission += order.commission
            
            transaction_id = str(uuid4()) + str(order.id)
            gst = float("{:.2f}".format(commission * config.gst / 100))
            tcs = float("{:.2f}".format(commission * config.tcs / 100))
            commission_perc = commission / total_amount * 100
            merchant_amount = grand_total_amount - commission - gst - tcs 
            
            store = order.store
            bank_details = StoreBankDetails.query.filter_by(id = store.bank_details_id).first()
            
            if not bank_details:
                bank_details = StoreBankDetails.query.filter_by(store_id = store.id).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            
            if not bank_details:
                continue   
                
            store_payment = StorePayment(
                store_id = int(k),
                grand_total_amount = grand_total_amount,
                total_amount = total_amount,
                gst = gst,
                tcs = tcs,
                commission = commission,
                commission_perc = commission_perc,
                merchant_amount = merchant_amount,      
                transaction_id = transaction_id,
                beneficiary_name = bank_details.beneficiary_name,
                name_of_bank =  bank_details.name_of_bank,
                ifsc_code= bank_details.ifsc_code,
                vpa= bank_details.vpa,
                account_number= bank_details.account_number        ,
            )
            
            save_db(store_payment)

            for order in orders[k]:
                order.store_payment_id = store_payment.id
            
                save_db(order)
            
        apiresponse = ApiResponse(True, f"Store Payments Created at {datetime.utcnow()}")
            
        return apiresponse.__dict__ , 200
        
    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured",None, str(e))
        return apiresponse.__dict__ , 500
    
def get_store_payments(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        page = data['page_no']
        items_per_page = data['items_per_page']
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400
        
        try:
            search = data['search']
        except:
            search = None 
            
        if user['role'] == 'supervisor':
            if search == None:
                store_payments = StorePayment.query.join(UserCities, UserCities.user_id == user['id']).join(Store, Store.city_id == UserCities.city_id).filter(StorePayment.store_id == Store.id).all()
            
            else:
                store_payments = StorePayment.query.join(UserCities, UserCities.user_id == user['id']).join(Store, Store.city_id == UserCities.city_id).filter(or_(StorePayment.transaction_id == search),(func.lower(Store.name) == func.lower(search))).all()

        elif user['role'] == 'merchant':
            if search == None:
                store_payments = StorePayment.query.join(Store, Store.merchant_id == user['id']).filter(StorePayment.store_id == Store.id).filter(StorePayment.transferd_at != None).all()
            
            else:
                store_payments = StorePayment.query.join(Store, Store.merchant_id == user['id']).filter(StorePayment.store_id == Store.id).filter(StorePayment.transferd_at != None).filter(or_(StorePayment.transaction_id == search),(func.lower(Store.name) == func.lower(search))).all()
           
        elif user['role'] == 'super_admin':      
            if search == None:
                store_payments = StorePayment.query.filter_by(deleted_at = None).paginate(page, items_per_page, False)
                
            else:
                store_payments = StorePayment.query.join(Store).filter(or_(StorePayment.transaction_id == search),(func.lower(Store.name) == func.lower(search))).all()
        
        else:
            apiresponse = ApiResponse(False, "User role has no access")
        
            return apiresponse.__dict__, 403
         
        return_data = []
        for store_payment in store_payments:
            store = store_payment.store
            name = None
            role = None
            if store_payment.approved_at:
                user = Auth.get_user( store_payment.approved_by_id  , store_payment.approved_by_role)
                if user:
                    name = user.name
                    role = user.role
            
                
            return_data.append({
                'id' : store_payment.id,
                'store_name' : store.name,
                'store_id' : store_payment.id,
                'grand_total_amount' : store_payment.grand_total_amount,
                'total_amount' : store_payment.total_amount,
                'gst' : store_payment.gst,
                'tcs' : store_payment.tcs,
                'commission' : store_payment.commission,
                'commission_perc' : store_payment.commission_perc,
                'merchant_amount' : store_payment.merchant_amount,
                'transaction_id' : store_payment.transaction_id,
                'bank_details' : {
                    'name_of_bank' : store_payment.name_of_bank,
                    'ifsc_code' : store_payment.ifsc_code,
                    'vpa' : store_payment.vpa,
                    'account_number' : store_payment.account_number
                },
                'approved_at' : if_date_time(store_payment.approved_at),
                'approved_by' : name,
                'approved_by_role' : role,
                'created_at' : str(store_payment.created_at),
                
            })
            
        apiresponse = ApiResponse(True, "Data Fetched Successfuly", return_data)
        
        return apiresponse.__dict__, 200
            
            
    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured",None, str(e))
        return apiresponse.__dict__ , 500
    
def get_orders_by_store_payment_id(data):
    try:
        store_payment = StorePayment.query.filter_by(id = data['store_payment_id']).filter_by(deleted_at = None).first()
        
        if not store_payment:
            apiresponse = ApiResponse(False, "Store Payment Not Found")
        
            return apiresponse.__dict__, 400
        
        resp , status = Auth.get_logged_in_user(request)
        
        user = resp['data']
        
        if user['role'] == 'merchant':
            store = store_payment.store
            if user['id'] != store.merchant_id:
                apiresponse = ApiResponse(False, "Merchant has no access to see about this store")
        
                return apiresponse.__dict__, 400
            
        if user['role'] == 'supervisor':
            store = Store.query.join(UserCities, UserCities.user_id == user['id']).filter_by(city_id = UserCities.city_id).filter_by(id = store_payment.store_id).first()
        
            if not store:
                apiresponse = ApiResponse(False, "Supervisor has no access to see about this store")
        
                return apiresponse.__dict__, 400
            
        item_orders = ItemOrder.query.filter_by(store_payment_id = store_payment.id).first()
        
        store = store_payment.store
        
        item_order_object = []
        for item_order in item_orders:
            
            if item_order.walk_in_order==None or item_order.walk_in_order==0:
                user = User.query.filter_by(
                    id=item_order.user_id).first()
            else:
                user = merchant.Merchant.query.filter_by(
                    id=item_order.user_id).first()

            #user = User.query.filter_by(id=item_order.user_id).first()
            data = {
                'order_id': item_order.id,
                'slug': item_order.slug,
                # 'user_id': item_order.user_id,
                'user_name': user.name,
                'order_total': item_order.order_total,
                # 'slug': item_order.slug,
                'store_id': item_order.store_id,
                'store_name': store.name,
                'coupon_id': item_order.coupon_id,
                'order_total_discount': item_order.order_total_discount,
                # 'final_order_total': item_order.final_order_total,
                'delivery_fee': item_order.delivery_fee,
                # 'grand_order_total': item_order.grand_order_total,
                # 'initial_paid': item_order.initial_paid,
                'order_created': if_date(item_order.order_created),
                'order_confirmed': if_date(item_order.order_confirmed),
                'ready_to_pack':  if_date(item_order.ready_to_pack),
                'order_paid':  if_date(item_order.order_paid),
                'order_pickedup':  if_date(item_order.order_pickedup),
                'order_delivered':  if_date(item_order.order_delivered),
                # 'delivery_date':str(item_order.delivery_date),
                # 'user_address_id': item_order.user_address_id,
                # 'delivery_slot_id': item_order.delivery_slot_id,
                # 'da_id': item_order.da_id,
                'status': item_order.status,
                'walkin_order': item_order.walk_in_order,
                # 'merchant_transfer_at': item_order.merchant_transfer_at,
                # 'merchant_transaction_id': item_order.merchant_transaction_id,
                # 'txnid': item_order.txnid,
                # 'gateway': item_order.gateway,
                # 'transaction_status': item_order.transaction_status,
                # 'cancelled_by': item_order.cancelled_by,
                # 'created_at': str(item_order.created_at),
                # 'updated_at': if_date(item_order.updated_at),
                # 'deleted_at': str(item_order.deleted_at),
            }
            item_order_object.append(data)
             
        apiresponse = ApiResponse(
                    True, "Data Loaded Succesfully", item_order_object)
        return apiresponse.__dict__, 200   
    
    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured",None, str(e))
        return apiresponse.__dict__ , 500