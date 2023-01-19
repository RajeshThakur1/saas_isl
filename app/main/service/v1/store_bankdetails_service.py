from app.main.model.supervisor import Supervisor
from app.main.model.userCities import UserCities
from sqlalchemy.sql.expression import select
from app.main.service.v1.notification_service import CreateNotification
from app.main.util.v1.database import get_count, save_db
from app.main.model import merchant
import datetime
from app.main import db
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import text
from app.main.model.itemOrders import ItemOrder
from app.main.model.store_bankdetails import StoreBankDetails
from app.main.model.store import Store
from app.main.model.itemOrderLists import ItemOrderLists
from flask import request
from app.main.service.v1.auth_helper import Auth
from itertools import groupby
from alembic import op
from operator import itemgetter
from flask import request
import requests
import json
from app.main.util.v1.decorator import *
from sqlalchemy import and_
import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/store_bankdetails_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")



def create_store_bankdetails(data):
    try:
        # print(data['store_id'],"0000")
        # print("Shishirohfiwebfi",int(data['store_id']))
        # payment = Store.query.filter_by(id=int(data['store_id'])).first()
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        try: 
            store_id = int(data['store_id'])
        except :
            apiResponce = ApiResponse(False,'Provide a Valid Store Id',None,'Provide a Valid Store Id')
            return (apiResponce.__dict__), 400
        
        try:
            vpa = data['vpa']
        except:
            vpa = None

        store = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
        
        if not store:
            apiResponce = ApiResponse(False,'Store Id is Wrong or Deleted',None,'Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        confirmed = 0
        bank_details=StoreBankDetails.query.filter_by(store_id=int(data['store_id'])).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0).first()
        
        true_msg = "Bank Details Added Successfully, Waiting For Confirmation by the Merchant"
        false_msg = "Bank Details Allready Exists, Waiting For Confirmation by the Merchant"

        if user['role'] == 'merchant':
            store = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
            if store.merchant_id != user['id']:
                apiResponce = ApiResponse(False,'Merchant has No access to add Bank Details',None,None)
                return (apiResponce.__dict__), 400
            confirmed = 1
        
            bank_details=StoreBankDetails.query.filter_by(store_id=int(data['store_id'])).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            true_msg = "Bank Details Added Successfully"
            false_msg = "Bank Details Allready Exists"


        elif user['role'] == "supervisor":
            
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

        
        if not bank_details:
            new_bankdetail = StoreBankDetails(store_id=data['store_id'],
                                    beneficiary_name = data['beneficiary_name'], 
                                    name_of_bank=data['name_of_bank'],
                                    ifsc_code=data['ifsc_code'],
                                    vpa=vpa,
                                    account_number=data['account_number'],
                                    confirmed = confirmed,
                                    created_at=datetime.datetime.utcnow())

            save_db(new_bankdetail)
            
            if user['role'] != 'merchant':
                store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()
                reciepent = store_merchant.merchant
                city = store.city
                notification_data = {
                    'store_name': store.name,
                    'city' : city.name,
                    'role': user['role'].capitalize(),
                    'template_name': 'store_bankdetails_create',
                }
                
                CreateNotification.gen_notification_v2(reciepent, notification_data)
            
            else:
                store.bank_details_id = new_bankdetail.id
                
                save_db(store)

            apiResponce = ApiResponse(True,true_msg,"",None)
            return (apiResponce.__dict__), 201

        else:
            error = ApiResponse(False, false_msg, None, false_msg)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def show_StoreBankDetail(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        store = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at = None).first()
        if not store:
            apiResponce = ApiResponse(False,'Invalid Store Id',None,"Given Store Id is Wrong or Deleted")
            return (apiResponce.__dict__), 400

        if user['role'] == "merchant":
    
            storemerchant = Store.query.filter_by(id = data['store_id']).filter_by(merchant_id = user['id']).filter_by(deleted_at = None).first()

            if not storemerchant:
                apiResponce = ApiResponse(False,'Merchant have No access to this Content',None,"Merchant have no access to the store details")
                return (apiResponce.__dict__), 400
        
        elif user['role'] == "supervisor":
        
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter_by(id = data['store_id']).filter(Store.city_id.in_(cities)).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to Fetch Store Payments', None, None)
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', 'null', 'null')
                return (error.__dict__), 400

        selected = None
        update_confirmation = None
        delete_confirmation = None

        store_bankdetail = StoreBankDetails.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
        
        if store_bankdetail:
                selected = {
                'id':store_bankdetail.id,
                'name_of_bank':store_bankdetail.name_of_bank,
                'benificiary_name': store_bankdetail.beneficiary_name,
                'ifsc_code':store_bankdetail.ifsc_code,
                'vpa':store_bankdetail.vpa,
                'confirmed' : store_bankdetail.confirmed,
                'account_number':store_bankdetail.account_number,
                'updated_at': str(store_bankdetail.updated_at) if store_bankdetail.updated_at else None,
                'deleted_at': str(store_bankdetail.deleted_at) if store_bankdetail.deleted_at else None
                }
        
        if user['role'] == 'supervisor':
            pending_store_bankdetails = StoreBankDetails.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0).all()
            no_of_pending_store_bankdetails = get_count(StoreBankDetails.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0))  
        
        else:
            pending_store_bankdetails = StoreBankDetails.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).filter_by(confirmed = 0).all()
            no_of_pending_store_bankdetails = get_count(StoreBankDetails.query.filter_by(store_id = data['store_id']).filter_by(deleted_at = None).filter_by(confirmed = 0))   
            
        
        update_confirmation = []
        for pending_store_bankdetail in pending_store_bankdetails:    
            update_confirmation.append({
                'id':pending_store_bankdetail.id,
                'name_of_bank':pending_store_bankdetail.name_of_bank,
                'benificiary_name': pending_store_bankdetail.beneficiary_name,
                'ifsc_code':pending_store_bankdetail.ifsc_code,
                'vpa':pending_store_bankdetail.vpa,
                'confirmed' : pending_store_bankdetail.confirmed,
                'account_number':pending_store_bankdetail.account_number,
                'updated_at': str(pending_store_bankdetail.updated_at) if pending_store_bankdetail.updated_at else None,
                'deleted_at': str(pending_store_bankdetail.deleted_at) if pending_store_bankdetail.deleted_at else None
                })
        
        # store_bankdetail = StoreBankDetails.query.filter_by(store_id = data['store_id']).filter(StoreBankDetails.deleted_at != None).filter_by(confirmed = 0).first()

        # if store_bankdetail:    
        #     delete_confirmation = {
        #         'id':store_bankdetail.id,
        #         'name_of_bank':store_bankdetail.name_of_bank,
        #         'benificiary_name': store_bankdetail.beneficiary_name,
        #         'ifsc_code':store_bankdetail.ifsc_code,
        #         'vpa':store_bankdetail.vpa,
        #         'confirmed' : store_bankdetail.confirmed,
        #         'account_number':store_bankdetail.account_number,
        #         'updated_at': str(store_bankdetail.updated_at) if store_bankdetail.updated_at else None,
        #         'deleted_at': str(store_bankdetail.deleted_at) if store_bankdetail.deleted_at else None
        #         }
           
        data ={
            'confirmed' : selected,
            'update_confirmation' : update_confirmation,
            #'delete_confirmation' : delete_confirmation
            'no_of_pending_update': no_of_pending_store_bankdetails

        }

        apiResponce = ApiResponse(True,'Bank Details Fetched',data,None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def update_store_bankdetail(data):
    try:
        # print(data['store_id'],"0000")
        # print("Shishirohfiwebfi",int(data['store_id']))
        # payment = Store.query.filter_by(id=int(data['store_id'])).first()
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        try: 
            store_id = int(data['store_id'])
        except :
            apiResponce = ApiResponse(False,'Provide a Valid Store Id',None,'Provide a Valid Store Id')
            return (apiResponce.__dict__), 400
        
        try:
            vpa = data['vpa']
        except:
            vpa = None
            
        store = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
        
        if not store:
            apiResponce = ApiResponse(False,'Store Id is Wrong or Deleted',None,'Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        confirmed = 0
        bank_details=StoreBankDetails.query.filter_by(id=int(data['id'])).filter_by(store_id = data['store_id']).filter_by(deleted_at = None).first()
        
        true_msg = "Bank Details Updated Successfully, Waiting For Confirmation by the Merchant"
        false_msg = "Bank Details Not Found"

        if user['role'] == 'merchant':
            store = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
            if store.merchant_id != user['id']:
                apiResponce = ApiResponse(False,'Merchant has No access to add Bank Details',None,None)
                return (apiResponce.__dict__), 400
            confirmed = 1
        
            bank_details=StoreBankDetails.query.filter_by(store_id=int(data['store_id'])).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            true_msg = "Bank Details Updated Successfully"
            false_msg = "Bank Details Not Found"

            if bank_details:
                bank_details.store_id=data['store_id'],
                bank_details.beneficiary_name = data['beneficiary_name'], 
                bank_details.name_of_bank=data['name_of_bank'],
                bank_details.ifsc_code=data['ifsc_code'],
                bank_details.vpa=vpa,
                bank_details.account_number=data['account_number'],
                bank_details.confirmed = confirmed,
                bank_details.updated_at=datetime.datetime.utcnow()

                save_db(bank_details, "Store Payments")
                

                apiResponce = ApiResponse(True,true_msg,"",None)
                return (apiResponce.__dict__), 200

            else:
                error = ApiResponse(False, false_msg, None, false_msg)
                return (error.__dict__), 400


        elif user['role'] == "supervisor":
            
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

        elif user['role'] != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to update Bank Details')
            return (apiResponce.__dict__), 403
        
        uncomfirmed_bank_details = StoreBankDetails.query.filter_by(store_id =store_id).filter_by(deleted_at = None).filter_by(added_by_role = user['role']).filter_by(added_by_id = user['id']).filter_by(confirmed = 0).first()
        
        if uncomfirmed_bank_details: 
            if uncomfirmed_bank_details.id != bank_details.id:
                if bank_details.added_by_id != user['id'] and bank_details.added_by_role != user['role']:
                    error = ApiResponse(False, "User Has No Access To Delete this Detail", None)
                    return (error.__dict__), 400
                else:
                    apiResponce = ApiResponse(False, 'Update Request Allready Submited, Wait for Merchant to Confirm it')
                    return (apiResponce.__dict__), 400
            
           
            bank_details.store_id=store_id,
            bank_details.beneficiary_name = data['beneficiary_name'], 
            bank_details.name_of_bank=data['name_of_bank'],
            bank_details.ifsc_code=data['ifsc_code'],
            bank_details.vpa=data['vpa'],
            bank_details.account_number=data['account_number'],
            bank_details.confirmed = confirmed,
            bank_details.updated_at=datetime.datetime.utcnow()

            save_db(bank_details)
            

            apiResponce = ApiResponse(True,"Pending Update Updated Successfully","",None)
            return (apiResponce.__dict__), 200
            
            
        if bank_details:
            new_payment = StoreBankDetails(store_id=data['store_id'],
                                    beneficiary_name = data['beneficiary_name'], 
                                    name_of_bank=data['name_of_bank'],
                                    ifsc_code=data['ifsc_code'],
                                    vpa=data['vpa'],
                                    account_number=data['account_number'],
                                    confirmed = confirmed,
                                    created_at=bank_details.created_at,
                                    updated_at = datetime.datetime.utcnow()
                                    )


            save_db(new_payment, "StoreBankDetail")
            
            
            store_merchant = Store.query.filter_by(id = data['store_id']).filter_by(deleted_at=None).first()
            reciepent = store_merchant.merchant
            city = store.city
            notification_data = {
                'store_name': store.name,
                'city' : city.name,
                'role': user['role'].capitalize(),
                'template_name': 'store_bankdetails_update',
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
            apiResponce = ApiResponse(True,true_msg,"",None)
            return (apiResponce.__dict__), 201

        else:
            error = ApiResponse(False, false_msg, None, false_msg)
            return (error.__dict__), 400
        
        
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def delete_StoreBankDetails(data):
    try:
        # print(data['store_id'],"0000")
        # print("Shishirohfiwebfi",int(data['store_id']))
        # payment = Store.query.filter_by(id=int(data['store_id'])).first()
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        try: 
            store_id = int(data['store_id'])
        except :
            apiResponce = ApiResponse(False,'Provide a Valid Store Id',None,'Provide a Valid Store Id')
            return (apiResponce.__dict__), 400
        
        stores = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
        
        if not stores:
            apiResponce = ApiResponse(False,'Store Id is Wrong or Deleted',None,'Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        # confirmed = 0
        bank_details=StoreBankDetails.query.filter_by(id=int(data['id'])).filter_by(store_id = data['store_id']).filter_by(deleted_at = None).first()
        
        # true_msg = "Bank Details Deleted Successfully, Waiting For Confirmation by the Merchant"
        # false_msg = "Bank Details Not Found"

        # if user['role'] == 'merchant':
        #     store = StoreMerchant.query.filter_by(store_id = store_id).filter_by(deleted_at = None).first()
        #     if store.merchant_id != user['id']:
        #         apiResponce = ApiResponse(False,'Merchant has No access to deleted Bank Details',None,None)
        #         return (apiResponce.__dict__), 400
        #     confirmed = 1
        
        #     bank_details=StoreBankDetails.query.filter_by(store_id=int(data['store_id'])).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
        #     true_msg = "Bank Details Deleted Successfully"
        #     false_msg = "Bank Details Not Found"


        if user['role'] == "supervisor":
            
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
            
            store = Store.query.filter(Store.city_id.in_(cities)).filter_by(id = data['store_id']).first()
            
            if not store:
                error = ApiResponse(False, 'Supervisor has no access to this Store')
                return (error.__dict__), 400
            
            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted')
                return (error.__dict__), 400
        
        elif user['role'] != 'super_admin':
            error = ApiResponse(False, "User has No access to use this feature", None)
            return (error.__dict__), 403
        
        if bank_details.confirmed == 1:
            error = ApiResponse(False, "Selected Bank Details Cannot be Deleted", None)
            return (error.__dict__), 400
        
        if bank_details.added_by_id == user['id'] and bank_details.added_by_role == user['role']: 
            bank_details.deleted_at = datetime.datetime.utcnow()
            bank_details.confirmed = 1
            save_db(bank_details)
            
            # if user['role'] != 'merchant':
            #     store_merchant = StoreMerchant.query.filter_by(store_id = data['store_id']).filter_by(deleted_at=None).first()
            #     reciepent = store_merchant.merchant
            #     city = store.city
            #     notification_data = {
            #         'store_name': store.name,
            #         'city' : city.name,
            #         'role': user['role'].capitalize(),
            #         'template_name': 'store_bankdetails_delete',
            #     }
                
            #     CreateNotification.gen_notification_v2(reciepent, notification_data)

            # apiResponce = ApiResponse(True,true_msg,None,None)
            # return (apiResponce.__dict__), 200

            
            error = ApiResponse(True, "Pending Update Deleted Successfully", None)
            return (error.__dict__), 200
            
        else:
            error = ApiResponse(False, "User Has No Access To Delete this Pending Update", None)
            return (error.__dict__), 400
        
            
        # else:
        #     error = ApiResponse(False, false_msg, None, false_msg)
        #     return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def confirmation_change(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        try: 
            store_id = int(data['store_id'])
        except :
            apiResponce = ApiResponse(False,'Provide a Valid Store Id',None,'Provide a Valid Store Id')
            return (apiResponce.__dict__), 400
        
        stores = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
        
        if not stores:
            apiResponce = ApiResponse(False,'Store Id is Wrong or Deleted',None,'Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if user['role'] == 'merchant':
            store = Store.query.filter_by(id = store_id).filter_by(deleted_at = None).first()
            
            if store.merchant_id != user['id']:
                apiResponce = ApiResponse(False,'Merchant has No access to add Bank Details',None,None)
                return (apiResponce.__dict__), 400

        if data['status'] not in [1,0]:
            apiResponce = ApiResponse(False,'Wrong Status Provided',None,None)
            return (apiResponce.__dict__), 400
        
        bank_details=StoreBankDetails.query.filter_by(id = data['id']).filter_by(store_id=data['store_id']).filter_by(confirmed = 0).first()
        
        selected_bank_details=StoreBankDetails.query.filter_by(store_id=data['store_id']).filter(and_(StoreBankDetails.confirmed == 1, StoreBankDetails.deleted_at == None)).first()


        if not bank_details:
            apiResponce = ApiResponse(False,'Wrong Bank Details id Provided',None,None)
            return (apiResponce.__dict__), 400
        
        
        if bank_details.deleted_at == None:
            if data['status'] == 0:
                bank_details.deleted_at = datetime.datetime.utcnow()
                bank_details.confirmed = 1
            
            else:
                bank_details.confirmed = 1
                if selected_bank_details:
                    selected_bank_details.deleted_at = datetime.datetime.utcnow()
                    selected_bank_details.confirmed = 1
            
                    save_db(selected_bank_details, "StoreBankDetail")
                    
            
        else:
            if data['status'] == 0:
                bank_details.deleted_at = None
                bank_details.confirmed = 1
            
            else:
                bank_details.confirmed = 1
        
        save_db(bank_details, "StoreBankDetail")
        
        store.bank_details_id = bank_details.id
        
        save_db(store)

        if data['status'] == 0:
            msg = "Bank Details Changes Rejected Successfully"
            status = 'Rejected'
        
        else:
            msg = "Bank Details Changes Accepted Successfullt"
            status = 'Accepted'
        
        if bank_details.added_by_role:
            if bank_details.added_by_role == 'super_admin':
                reciepent = SuperAdmin.query.filter_by(id=bank_details.added_by_id).first()
            else:
                reciepent = Supervisor.query.filter_by(id=bank_details.added_by_id).first()
                
        
            notification_data = {
                'store_name': store.name,
                'template_name': 'store_bankdetails_confirm',
                'status': status
                    
            }
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
        apiResponce = ApiResponse(True,msg,None,None)
        return (apiResponce.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500



def fun():
    # curl localhost:5000/post -d '{"foo": "bar"}' -H 'Content-Type: application/json'
    headers = {'Content-type': 'text/html; charset=UTF-8'}
    url='https://smsapi.adfpay.com/api/v1/generate-otp'
    data = {'otp_for': '8707857231','otp_length' :'4'}
    # curl -i -H "Content-Type: application/json" -X POST -d '{'otp_for': '8707857231','otp_length' :'4'}' smsapi.adfpay.com/api/v1/generate-otp




    response=requests.post(url, data).text
    # print(request.dir,'-<<<<<------')
    # response_object= request.post(url, data=data, headers=headers)
    return response

