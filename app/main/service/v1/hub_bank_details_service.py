from app.main.model.apiResponse import ApiResponse
import datetime
from flask import request
from app.main.model.merchant import Merchant
from app.main.model.superAdmin import SuperAdmin
from app.main.model.supervisor import Supervisor
from app.main.model.userCities import UserCities
from app.main.service.v1.auth_helper import Auth
from app.main.model.hub import Hub
from app.main.model.hubBankDetails import HubBankDetails
from app.main.service.v1.notification_service import CreateNotification
from app.main.util.v1.database import get_count, save_db
from sqlalchemy import and_
import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/hub_bank_details_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_hub_bank_details(data):
    try:
       
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        
        if not hub:
            apiResponce = ApiResponse(False,'Store Id is Wrong or Deleted',None,'Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        confirmed = 0
        bank_details=HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0).first()
        
        true_msg = "Bank Details Added Successfully, Waiting For Confirmation by the Distributor"
        false_msg = "Bank Details Allready Exists, Waiting For Confirmation by the Distributor"
        added_by_id = user['id']
        added_by_role = user['role']
            
        if user['role'] == 'distributor':

            if hub.distributor_id != user['id']:
                apiResponce = ApiResponse(False,'Distributor has No access to add Bank Details',None,None)
                return (apiResponce.__dict__), 400
            
            confirmed = 1

            
            
            bank_details=HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            true_msg = "Bank Details Added Successfully"
            false_msg = "Bank Details Allready Exists"
        
        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to add Bank Details')
                return (apiResponce.__dict__), 403
        
        elif user['role'] != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403


        if not bank_details:
            new_bank = HubBankDetails(hub_id=hub.id,
                                    beneficiary_name = data['beneficiary_name'], 
                                    name_of_bank=data['name_of_bank'],
                                    ifsc_code=data['ifsc_code'],
                                    vpa=data['vpa'],
                                    account_number=data['account_number'],
                                    confirmed = confirmed,
                                    added_by_id = added_by_id,
                                    added_by_role = added_by_role,
                                    created_at=datetime.datetime.utcnow())

            save_db(new_bank, "HubBankDetails")
            
            
            if user['role'] != 'distributor':
                
                reciepent = hub.distributor
    
                
                notification_data = {
                    'hub_name': hub.name,
                    'role': user.role.capitalize(),
                    'template_name': 'hub_bankdetails_create',               
                        
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

def show_hub_bank_details(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        if not hub:
            apiResponce = ApiResponse(False,'Invalid Hub Id',None,"Given Hub Id is Wrong or Deleted")
            return (apiResponce.__dict__), 400

        if user['role'] == 'distributor':

            if hub.distributor_id != user['id']:
                apiResponce = ApiResponse(False,'Distributor has No access to see Bank Details',None,None)
                return (apiResponce.__dict__), 400

        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to see Bank Details')
                return (apiResponce.__dict__), 403
        
        elif user['role'] == 'merchant':
            pass

        elif user['role'] != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        selected = None
        update_confirmation = None
        delete_confirmation = None

        bank_details = HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
        
        if bank_details:
                selected = {
                'id':bank_details.id,
                'name_of_bank':bank_details.name_of_bank,
                'benificiary_name': bank_details.beneficiary_name,
                'ifsc_code':bank_details.ifsc_code,
                'vpa':bank_details.vpa,
                'added_by_role' : bank_details.added_by_role,
                'confirmed' : bank_details.confirmed,
                'account_number':bank_details.account_number,
                'updated_at': str(bank_details.updated_at) if bank_details.updated_at else None,
                # 'deleted_at': str(bank_details.deleted_at) if bank_details.deleted_at else None
                }

        if user['role'] == 'supervisor':
            pending_bank_details = HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0).all()
            no_of_pending_bank_details = get_count(HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(added_by_id = user['id']).filter_by(added_by_role = user['role']).filter_by(confirmed = 0))
        
        else:
            pending_bank_details = HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(confirmed = 0).all()
            no_of_pending_bank_details = get_count(HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(confirmed = 0)) 
        
        
        update_confirmation = []
        for pending_bank_detail in pending_bank_details:    
            update_confirmation.append({
                'id':pending_bank_detail.id,
                'name_of_bank':pending_bank_detail.name_of_bank,
                'benificiary_name': pending_bank_detail.beneficiary_name,
                'ifsc_code':pending_bank_detail.ifsc_code,
                'vpa':pending_bank_detail.vpa,
                'added_by_role' : pending_bank_detail.added_by_role,
                'confirmed' : pending_bank_detail.confirmed,
                'account_number':pending_bank_detail.account_number,
                'updated_at': str(pending_bank_detail.updated_at) if pending_bank_detail.updated_at else None,
                # 'deleted_at': str(pending_bank_detail.deleted_at) if pending_bank_detail.deleted_at else None
                })
        
        # bank_details = HubBankDetails.query.filter_by(hub_id = hub.id).filter(HubBankDetails.deleted_at != None).filter_by(confirmed = 0).first()

        # if bank_details:    
        #     delete_confirmation = {
        #         'id':bank_details.id,
        #         'name_of_bank':bank_details.name_of_bank,
        #         'benificiary_name': bank_details.beneficiary_name,
        #         'ifsc_code':bank_details.ifsc_code,
        #         'vpa':bank_details.vpa,
        #         'added_by_role' : bank_details.added_by_role,
        #         'confirmed' : bank_details.confirmed,
        #         'account_number':bank_details.account_number,
        #         'updated_at': str(bank_details.updated_at) if bank_details.updated_at else None,
        #         'deleted_at': str(bank_details.deleted_at) if bank_details.deleted_at else None
        #         }
           
        data ={
            'confirmed' : selected,
            'update_confirmation' : update_confirmation,
            'no_of_pending_update': no_of_pending_bank_details
            # 'delete_confirmation' : delete_confirmation

        }

        apiResponce = ApiResponse(True,'Bank Details Fetched',data,None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def update_hub_bank_details(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        if not hub:
            apiResponce = ApiResponse(False,'Invalid Hub Id',None,"Given Hub Id is Wrong or Deleted")
            return (apiResponce.__dict__), 400
        
        confirmed = 0
        
        true_msg = "Bank Details Updated Successfully, Waiting For Confirmation by the Distributor"
        false_msg = "Bank Details Not Found"
        bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter_by(id = data['id']).filter_by(deleted_at = None).first()

        added_by_id = user['id']
        added_by_role = user['role']
        
        if user['role'] == 'distributor':

            if hub.distributor_id != user['id']:
                apiResponce = ApiResponse(False,'Distributor has No access to add Bank Details',None,None)
                return (apiResponce.__dict__), 400
    
            confirmed = 1
        
            bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            true_msg = "Bank Details Updated Successfully"
            false_msg = "Bank Details Not Found"

            if bank_details:
                bank_details.hub_id=hub.id,
                bank_details.beneficiary_name = data['beneficiary_name'], 
                bank_details.name_of_bank=data['name_of_bank'],
                bank_details.ifsc_code=data['ifsc_code'],
                bank_details.vpa=data['vpa'],
                bank_details.account_number=data['account_number'],
                bank_details.confirmed = confirmed,
                bank_details.updated_at=datetime.datetime.utcnow()

                save_db(bank_details)
                

                apiResponce = ApiResponse(True,true_msg,"",None)
                return (apiResponce.__dict__), 200

            else:
                error = ApiResponse(False, false_msg, None, false_msg)
                return (error.__dict__), 400
        
        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to update Bank Details')
                return (apiResponce.__dict__), 403
    
        elif user['role'] != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to update Bank Details')
            return (apiResponce.__dict__), 403
        
        uncomfirmed_bank_details = HubBankDetails.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).filter_by(added_by_role = user['role']).filter_by(added_by_id = user['id']).filter_by(confirmed = 0).first()
        
        if uncomfirmed_bank_details: 
            if uncomfirmed_bank_details.id != bank_details.id:
                if bank_details.added_by_id != user['id'] and bank_details.added_by_role != user['role']:
                    error = ApiResponse(False, "User Has No Access To Delete this Detail", None)
                    return (error.__dict__), 400
                else:
                    apiResponce = ApiResponse(False, 'Update Request Allready Submited, Wait for Distributor to Confirm it')
                    return (apiResponce.__dict__), 400
            
            bank_details.hub_id=hub.id,
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
            new_payment = HubBankDetails(hub_id=hub.id,
                                    beneficiary_name = data['beneficiary_name'], 
                                    name_of_bank=data['name_of_bank'],
                                    ifsc_code=data['ifsc_code'],
                                    vpa=data['vpa'],
                                    account_number=data['account_number'],
                                    confirmed = confirmed,
                                    added_by_id = added_by_id,
                                    added_by_role = added_by_role,
                                    created_at=bank_details.created_at,
                                    updated_at = datetime.datetime.utcnow()
                                    )


            save_db(new_payment)
            
            
            if user['role'] != 'distributor':
                
                reciepent = hub.distributor
    
                
                notification_data = {
                    'hub_name': hub.name,
                    'role': user['role'].capitalize(),
                    'template_name': 'hub_bankdetails_update',
                    
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

def delete_hub_bank_details(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        if not hub:
            apiResponce = ApiResponse(False,'Invalid Hub Id',None,"Given Hub Id is Wrong or Deleted")
            return (apiResponce.__dict__), 400
        
        # confirmed = 0
        
        # true_msg = "Bank Details Deleted Successfully"
        # false_msg = "Bank Details Not Found"
        
        # added_by_id = user['id'],
        # added_by_role = user['role'],
        
        # if user['role'] == 'distributor':

        #     if hub.distributor_id != user['id']:
        #         apiResponce = ApiResponse(False,'Distributor has No access to add Bank Details',None,None)
        #         return (apiResponce.__dict__), 400
    
        #     confirmed = 1

        #     bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter_by(id = data['id']).filter_by(deleted_at = None).filter_by(confirmed = 1).first()
            
        #     true_msg = "Bank Details Deleted Successfully"
        #     false_msg = "Bank Details Not Found"
        
        if user['role'] == 'super_admin':
            bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to update Bank Details')
                return (apiResponce.__dict__), 403
            
            bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter_by(id = data['id']).filter_by(deleted_at = None).first()

        else:
            error = ApiResponse(False, "User has No access to use this feature", None)
            return (error.__dict__), 400
        
        
        
        if bank_details.confirmed == 1:
            error = ApiResponse(False, "Selected Bank Details Cannot be Deleted", None)
            return (error.__dict__), 400
        
        if bank_details.added_by_id == user['id'] and bank_details.added_by_role == user['role']: 
            bank_details.deleted_at = datetime.datetime.utcnow()
            bank_details.confirmed = 1
            save_db(bank_details)
            
            error = ApiResponse(True, "Pending Update Deleted Successfully", None)
            return (error.__dict__), 200
            
        else:
            error = ApiResponse(False, "User Has No Access To Delete this Pending Update", None)
            return (error.__dict__), 400
            
            
        # No One Cannot Delete Selected Bank Details
        # if bank_details:
        #     bank_details.deleted_at = datetime.datetime.utcnow()
        #     bank_details.confirmed = confirmed
        #     bank_details.added_by_id = added_by_id,
        #     bank_details.added_by_role = added_by_role,
        #     save_db(bank_details)
            
            
            # if user['role'] != 'distributor':
                
            #     reciepent = hub.distributor
    
                
            #     notification_data = {
            #         'hub_name': hub.name,
            #         'role': user['role'].capitalize(),
            #         'template_name': 'hub_bankdetails_delete',
                    
            #     }
                
            #     CreateNotification.gen_notification_v2(reciepent, notification_data)
                
            # apiResponce = ApiResponse(True,true_msg,None,None)
            # return (apiResponce.__dict__), 200

        # else:
        #     error = ApiResponse(False, false_msg, None, false_msg)
        #     return (error.__dict__), 400
        
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

def confirm_hub_bank_details(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        if not hub:
            apiResponce = ApiResponse(False,'Invalid Hub Id',None,"Given Hub Id is Wrong or Deleted")
            return (apiResponce.__dict__), 400


        if hub.distributor_id != user['id']:
            apiResponce = ApiResponse(False,'Distributor has No access to add Bank Details',None,None)
            return (apiResponce.__dict__), 400

        if data['status'] not in [1,0]:
            apiResponce = ApiResponse(False,'Wrong Status Provided',None,None)
            return (apiResponce.__dict__), 400
        
        bank_details=HubBankDetails.query.filter_by(id = data['id']).filter_by(hub_id=hub.id).filter_by(confirmed = 0).first()
        
        selected_bank_details=HubBankDetails.query.filter_by(hub_id=hub.id).filter(and_(HubBankDetails.confirmed == 1, HubBankDetails.deleted_at == None)).first()


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
            
                    save_db(selected_bank_details)
                    
            
        else:
            if data['status'] == 0:
                bank_details.deleted_at = None
                bank_details.confirmed = 1
            
            else:
                bank_details.confirmed = 1
        
        save_db(bank_details)
        

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
                'hub_name': hub.name,
                'template_name': 'hub_bankdetails_confirm',
                'status': status
                    
            }
            CreateNotification.gen_notification_v2(reciepent, notification_data)
        
        
        apiResponce = ApiResponse(True,msg,None,None)
        return (apiResponce.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500

