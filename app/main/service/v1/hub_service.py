import datetime
from uuid import uuid4
from flask.globals import request
from sqlalchemy import func
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.apiResponse import ApiResponse
from app.main.model.city import City
from app.main.model.hub import Hub
from app.main.config import hub_dir
from app.main.model.hubDa import HubDA
from app.main.model.hubTaxes import HubTaxes
from app.main.model.userCities import UserCities
from app.main.service.v1.auth_helper import Auth
from app.main.service.v1.image_service import image_save, image_upload
from app.main.service.v1.notification_service import CreateNotification
from app.main.util.v1.database import save_db
from app.main import config
from app.main.config import profile_pic_dir

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/hub_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_hub(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        user_role = resp['data']['role']

        city = City.query.filter(func.lower(City.name) == func.lower(data['city_name'])).filter_by(deleted_at = None).first()

        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')

            return_object = apiResponce.__dict__
            return return_object, 400

        hub = Hub.query.filter(func.lower(Hub.name) == func.lower(data['name'])).filter((Hub.city_id) == city.id).filter_by(deleted_at = None).first()

        if hub:
            apiResponce = ApiResponse(False,
                                      'Hub already exists with same name.',
                                      None, None)
            return (apiResponce.__dict__), 409
        
        if data['image'] == "default":
                data['image'] = hub_dir+ "default.png"

        else:
            image_file, status = image_upload(
                data['image'], hub_dir, data['name'])

            if status == 400:
                return image_file, status

            data['image'] = image_file

        slug = data['name']+"-"+city.name
        slug = slug.lower().replace(" ","-") + str(uuid4())
        
        if user_role == "super_admin":
            distributor = Distributor.query.filter_by(id = data['distributor_id']).filter_by(deleted_at = None).first()             
            if distributor:
                distributor_id = distributor.id
            else:
                apiResponce = ApiResponse(False,
                                      'Wrong Distributor id',
                                      None, None)
                return (apiResponce.__dict__), 400
        
        elif user_role == "distributor":
            distributor_id = user_id

        else:
            apiResponce = ApiResponse(False,
                                      'Wrong User Role',
                                      None, None)
            return (apiResponce.__dict__), 400

        new_hub = Hub(
                distributor_id = distributor_id,
                name=data['name'],
                slug=slug,
                image=data['image'],
                address_line_1=data['address_line_1'],
                address_line_2=data['address_line_2'],
                hub_latitude=data['hub_latitude'],
                hub_longitude=data['hub_longitude'],
                # pay_later=data['pay_later'],
                # delivery_mode=data['delivery_mode'],
                # delivery_start_time=data['delivery_start_time'],
                # delivery_end_time=data['delivery_end_time'],
                status=1,
                radius=data['radius'],
                created_at=datetime.datetime.utcnow(),
                city_id = city.id
        )

        save_db(new_hub)
        

        delivery_associate = DeliveryAssociate.query.filter_by(
            email=data['delivery_associate_email']).first()
        delivery_associate_phone = DeliveryAssociate.query.filter_by(
            phone=data['delivery_associate_phone']).first()

        if not delivery_associate_phone:

            if not delivery_associate:
                password = f"password_{data['delivery_associate_phone']}"

                new_delivery_associate = DeliveryAssociate(email=data['delivery_associate_email'],
                                        name=data['delivery_associate_name'],
                                        image = profile_pic_dir + "default.png",
                                        password=password,
                                        phone=data['delivery_associate_phone'],
                                        created_at=datetime.datetime.utcnow())
            
                save_db(new_delivery_associate,"DeliveryAssociate")
                

            else:
                error = ApiResponse(False, 'Delivery Associate Phonenumber not matched', None,
                                    None)
                return (error.__dict__), 400
        
        elif delivery_associate:
            if delivery_associate.id == delivery_associate_phone.id:
                new_delivery_associate = delivery_associate

            else:
                error = ApiResponse(False, 'Delivery Associate Phone number not matched', None,
                                    None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'Delivery Associate Email and Phonenumber not matched', None,
                                    None)
            return (error.__dict__), 400
        
        save_db(new_hub)
        
            
        new_hub_da_map = HubDA(
            hub_id = new_hub.id,
            delivery_associate_id = new_delivery_associate.id,
            status=1,
            created_at=datetime.datetime.utcnow())

        save_db(new_hub_da_map, "HubDA")
        
        hub = new_hub
        # new_hub.da_id = new_delivery_associate.id
        
        # save_db(new_hub, "Hub")
        # if error:
        #     return error,500

        if user_role != 'distriutor':
            reciepent = hub.distributor
    
            city = hub.city
            notification_data = {
                'hub_name': hub.name,
                'city' : city.name,
                'role': user_role.capitalize(),
                'template_name': 'hub_create',
                
            }
            
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
        reciepent = new_delivery_associate
    
        city = hub.city
        notification_data = {
            'hub_name': hub.name,
            'city' : city.name,
            'role': user_role.capitalize(),
            'template_name': 'hub_create',
            
        }
            
        CreateNotification.gen_notification_v2(reciepent, notification_data)
        
        apiResponce = ApiResponse(True,
                                    'New Hub Successfully registered.',
                                    None, None)
        return (apiResponce.__dict__), 200
    
        
            
    
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong.',
                            None, str(e))
        return error.__dict__, 500

def show_all_hub():
    """
    Show all hubs associated with the user based on login token
    
    Return type: __dict__, Integer
    """
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
        
        if page_no == 0:
            apiresponse = ApiResponse(False, "Wrong Page Number", None , None)
            return apiresponse.__dict__ , 400
        
        if page_no < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id=user['id']

        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):
            
            if query:
                
                if len(query) > 2:

                    query = f'%{query}%'
                    records = Hub.query.filter_by(deleted_at = None).filter(func.lower(Hub.name).like(func.lower(query))).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Hub.query.filter_by(deleted_at = None).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)

            else:
                records = Hub.query.filter_by(deleted_at = None).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
        

        elif user['role'] == 'distributor':
            user_id = user['id']

            if query:
                
                if len(query) > 2:

                    query = f'%{query}%'
                    records = Hub.query.filter_by(deleted_at = None).filter(func.lower(Hub.name).like(func.lower(query))).filter_by(distributor_id = user_id).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Hub.query.filter_by(deleted_at = None).filter_by(distributor_id = user_id).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)

            else:
                records = Hub.query.filter_by(deleted_at = None).filter_by(distributor_id = user_id).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
        
        elif user['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user['id']).filter_by(deleted_at = None).all()
        
            cities = []
            for supervisor_city in supervisor_cities:
                cities.append(supervisor_city.city_id)
                
            if query:
                
                if len(query) > 2:

                    query = f'%{query}%'
                    records = Hub.query.filter_by(deleted_at = None).filter(func.lower(Hub.name).like(func.lower(query))).filter(Hub.city_id.in_(cities)).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Hub.query.filter_by(deleted_at = None).filter(Hub.city._in(cities)).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)

            else:
                records = Hub.query.filter_by(deleted_at = None).filter(Hub.city._in(cities)).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
        
        elif user['role'] == "delivery_associate":

            hubs = HubDA.query.filter_by(deleted_at=None).filter_by(delivery_associate_id = user_id).filter_by(status = 1).all()
            hub_id = []
            for hub in hubs:
                hub_id.append(hub.hub_id)
       
            # cities = []
            # for delivery_associate_city in records.items:
            #     cities.append(delivery_associate_city.city_id)
                
            if query:
                
                if len(query) > 2:

                    query = f'%{query}%'
                    records = Hub.query.filter(Hub.id.in_(hub_id)).filter_by(deleted_at = None).filter(func.lower(Hub.name).like(func.lower(query))).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
                
                else:
                    records = Hub.query.filter(Hub.id.in_(hub_id)).filter_by(deleted_at = None).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)

            else:
                records = Hub.query.filter(Hub.id.in_(hub_id)).filter_by(deleted_at = None).order_by(Hub.status.desc()).order_by(func.lower(Hub.name)).paginate(page_no, item_per_page, False)
            
            
        
        
        if records:
            recordObject = []
            for record in records.items:
                cityname = ""
                
                if record.city_id:
                    city = City.query.filter_by(id=record.city_id).filter_by(deleted_at=None).filter_by(status=1).first()
                
                distributor = record.distributor
                response = {
                    # 'id': record.id,
                    'name': record.name,
                    'city': city.name,
                    'distrbutor_name': distributor.name, 
                    'slug': record.slug,
                    'image': record.image,
                    'address_line_1': record.address_line_1,
                    'address_line_2': record.address_line_2,
                    'hub_latitude': record.hub_latitude,
                    'hub_longitude': record.hub_longitude,
                    # 'pay_later': record.pay_later,
                    # 'delivery_mode': record.delivery_mode,
                    # 'delivery_start_time': record.delivery_start_time,
                    # 'delivery_end_time': record.delivery_end_time,
                    'radius': record.radius,
                    'status': record.status,
                    'city_id': record.city_id
                }
                recordObject.append(response)

            return_obj= {
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

            apiResponce = ApiResponse(True, 'List of All Hubs', return_obj,
                                    None)
            return (apiResponce.__dict__), 200
        else:
            error = ApiResponse(False, 'Hub Not able to fetch', None, 'No Data Found')
            return (error.__dict__), 404
    
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None, str(e))
        return (error.__dict__), 500

def show_hub_by_slug(data):
    """
    Show hub details by slug if the user has correct permissions to view the information
    
    Parameters: json data
    Return type: __dict__, Integer
    """
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403

        elif role == 'delivery_associate':
            # delivery_associate_cities = Hub.query.filter_by(da_id = user_id).filter_by(deleted_at = None).filter_by(status = 1).all()
            # city_ids = []
            # for delivery_associate_city in delivery_associate_cities:
            #     city_ids.append(delivery_associate_city.city_id)
            hubs = HubDA.query.filter_by(deleted_at=None).filter_by(delivery_associate_id = user_id).filter_by(status = 1).all()
            hub_ids = []
            for item in hubs:
                hub_ids.append(item.hub_id)

            if not hub.id in hub_ids:
                apiResponce = ApiResponse(False, 'Delivery Associate has No access to See Hubs')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400
        

        if hub:
        
            cityname = ""
            if hub.city:
                cityname = hub.city.name
            
            distributor = hub.distributor
            response = {
                # 'id': hub.id,
                'name': hub.name,
                'distrbutor_name': distributor.name, 
                'slug': hub.slug,
                'image': hub.image,
                'address_line_1': hub.address_line_1,
                'address_line_2': hub.address_line_2,
                'hub_latitude': hub.hub_latitude,
                'hub_longitude': hub.hub_longitude,
                # 'pay_later': hub.pay_later,
                # 'delivery_mode': hub.delivery_mode,
                # 'delivery_start_time': hub.delivery_start_time,
                # 'delivery_end_time': hub.delivery_end_time,
                'radius': hub.radius,
                'status': hub.status,
                'city_id' : hub.city_id,
                'city_name': cityname,
            }
                #recordObject.append(response)


            apiResponce = ApiResponse(True, 'Hub Details fetched',
                                    response, None)
            return (apiResponce.__dict__), 200
        else:
            error = ApiResponse(False, 'Hub Not Found', None, 'Given Hub id Wrong or Deleted')
            return (error.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None, str(e))
        return (error.__dict__), 500  

def delete_hub(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400
        
        hub.deleted_at = datetime.datetime.utcnow()
        save_db(hub)
        
        hub_das = HubDA.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).all()
        
        for hub_da in hub_das:
            hub_da.deleted_at = datetime.datetime.utcnow()
            save_db(hub_da)
            
        
        response_object = {
            'id': hub.id,
            'name': hub.name,
        }
        
        if role != 'distriutor':
            reciepent = hub.distributor
        
            city = hub.city
            notification_data = {
                'hub_name': hub.name,
                'city' : city.name,
                'role': role.capitalize(),
                'template_name': 'hub_delete',
                
            }
             
            CreateNotification.gen_notification_v2(reciepent, notification_data)
        
        apiResponce = ApiResponse(True, 'Hub Successfully Deleted.',
                                    response_object, None)
        return (apiResponce.__dict__), 200

        
   
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None,
                                      str(e))
        return (apiResponce.__dict__), 500

def update_hub_details(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400

        city = City.query.filter(func.lower(City.name) == func.lower(data['city_name'])).filter_by(deleted_at = None).first()

        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')

            return_object = apiResponce.__dict__
            return return_object, 400
        
        slug = data['name']+"-"+city.name
        slug = slug.lower().replace(" ","-")

        hub.name = data['name']
        hub.city_id = city.id
        hub.slug = slug
        hub.address_line_1=data['address_line_1'],
        hub.address_line_2=data['address_line_2'],
        hub.hub_latitude=data['hub_latitude'],
        hub.hub_longitude=data['hub_longitude'],
        hub.radius=data['radius'],
        hub.updated_at=datetime.datetime.utcnow()

        save_db(hub)
        
        if role != 'distriutor':
            reciepent = hub.distributor
        
            city = hub.city
            notification_data = {
                'hub_name': hub.name,
                'city' : city.name,
                'role': role.capitalize(),
                'template_name': 'hub_update',
                
            }
             
            CreateNotification.gen_notification_v2(reciepent, notification_data)
            
        apiResponce = ApiResponse(True, 'Hub Successfully Updated.',
                                        None, None)
        return (apiResponce.__dict__), 201
    
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured',None,
                                      str(e))
        return (apiResponce.__dict__), 500

def update_hub_image(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role != 'distributor':
            apiResponce = ApiResponse(False, 'User Role has No access to update this hub', None,
                                            None)
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400
        
        image, status = image_save(request, hub_dir)
        
        if status != 200:
            return image, status
        
        url, status = image_upload(image['data']['image'], hub_dir, hub.name)
        
        if status != 200:
            return image, status
        
        hub.image = url
        hub.updated_at = datetime.datetime.utcnow()
        save_db(hub)
        
        return ApiResponse(True, "Hub Image Updated successfully"), 200
    
    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured',None,
                                      str(e))
        return (apiResponce.__dict__), 500
    
    
def update_hub_status(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        elif role != 'super_admin':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(False, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400

        if data['status'] == 0:
            msg = "Hub Disabled"
        elif data['status'] == 1:
            msg = "Hub Enabled"
        
        else:
            error = ApiResponse(False, 'Wrong Status Code Provided', None, None)
            return (error.__dict__), 400
        
        hub.status = data['status']
        hub.updated_at = datetime.datetime.utcnow()

        save_db(hub)
        
        if role != 'distriutor':
            reciepent = hub.distributor
        
            city = hub.city
            notification_data = {
                'hub_name': hub.name,
                'city' : city.name,
                'role': role.capitalize(),
                'status': msg.split(" ")[1],
                'template_name': 'hub_status',
                
            }
             
            CreateNotification.gen_notification_v2(reciepent, notification_data)
        

        apiResponse = ApiResponse(True, msg, None, None)
        return apiResponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

def distributor_dropdown():
    try:

        distributors = Distributor.query.filter_by(deleted_at = None).all()

        return_object = []

        for distributor in distributors:
            object = {
                'id':distributor.id,
                'name':distributor.name,
            }
            return_object.append(object)
        
        apiResponce = ApiResponse(True, 'List of All Distributor', return_object,
                                    None)
        return (apiResponce.__dict__), 200

    
    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None, str(e))
        return (error.__dict__), 500

def hub_dropdown_by_city(data):
    try:
        
        city = City.query.filter(func.lower(City.name) == func.lower(data['city_name'])).filter_by(deleted_at = None).first()

        if not city:
            apiResponce = ApiResponse(False,
                                      'We dont Provide Service in Given City',
                                      None, 'City id not found in Database')

            return_object = apiResponce.__dict__
            return return_object, 400
            

        hubs = Hub.query.filter_by(city_id = city.id).filter_by(status = 1).filter_by(deleted_at = None).first()

        return_object = []
        for hub in hubs:
            object = {
                'slug' : hub.slug,
                'name': hub.name
            }
            return_object.append(object)    
        
        apiResponce = ApiResponse(True,
                                      'List of Hub successfully fetched by City',
                                      return_object, None)

        return apiResponce.__dict__, 200


    except Exception as e:
        error = ApiResponse(False, 'Error Occurred', None,
                            str(e))
        return (error.__dict__), 500

def add_hub_tax(data):
    try:
        hub = Hub.query.filter_by(slug = data['hub_slug']).filter_by(deleted_at = None).first()
        
        if not hub:
            error = ApiResponse(False, 'Hub Does not Exists', None,
                            'Given Hub Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        
        if user['role'] not in ['super_admin' , 'distributor']:
            error = ApiResponse(False, 'User has No access', None,
                            'User has No access')
            return (error.__dict__), 403

        if hub.distributor_id != user_id :
            error = ApiResponse(False, 'Distributor have no access to add taxes to this Hub', None,
                            'Hub id is not matched with Distributor id')
            return (error.__dict__), 400

        
        taxes = HubTaxes.query.filter_by(hub_id = hub.id).filter(func.lower(HubTaxes.name)==func.lower(data['name'])).filter_by(deleted_at = None).first()

        if taxes:
            error = ApiResponse(False, 'Tax Allready Exists', None,
                            'Tax Name Allready Exists')
            return (error.__dict__), 400
        
        if data['tax_type'] not in [2,1]:
            error = ApiResponse(False, 'Worng Tax Type Provided', None,
                            'Tax type only can be 2 and 1')
            return (error.__dict__), 400

        new_hubtax = HubTaxes(
            hub_id = hub.id,
            name = data['name'],
            description = data['description'],
            tax_type  = data['tax_type'],
            amount = data['amount'],
            created_at = datetime.datetime.utcnow()    
        )

        save_db(new_hubtax)
        

        apiResponse = ApiResponse(True, 'New Hub Tax Added Successfully', None,
                            None)
        return (apiResponse.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'Adding Hub Tax Failed', None,
                            str(e))
        return (error.__dict__), 500

def update_hub_tax(data):
    try:
        hubtax = HubTaxes.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not hubtax:
            error = ApiResponse(False, 'Tax Does not Exists', None,
                            'Given Tax Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        if user['role'] not in ['super_admin' , 'distributor']:
            error = ApiResponse(False, 'User has No access', None,
                            'User has No access')
            return (error.__dict__), 403

        hub = Hub.query.filter_by(id = hubtax.hub_id).filter_by(deleted_at = None).first()
        
        if not hub:
            error = ApiResponse(False, 'Hub Does not Exists', None,
                            'Given Hub Id is Wrong or deleted')
            return (error.__dict__), 400
        
        if hub.distributor_id != user_id :
            error = ApiResponse(False, 'Distributor have no access to update taxes to this Hub', None,
                            'Hub id is not matched with Distributor id')
            return (error.__dict__), 400
        
        if data['tax_type'] not in [2,1]:
            error = ApiResponse(False, 'Worng Tax Type Provided', None,
                            'Tax type only can be 2 and 1')
            return (error.__dict__), 400

        hubtax.name = data['name'],
        hubtax.description = data['description'],
        hubtax.tax_type  = data['tax_type'],
        hubtax.amount = data['amount']  
        hubtax.updated = datetime.datetime.utcnow()
        save_db(hubtax)
        

        apiResponse = ApiResponse(True, 'Distributor Tax Updated Successfully', None,
                            None)
        return (apiResponse.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Updating Tax to the Distributor Failed', None,
                            str(e))
        return (error.__dict__), 500

def delete_hub_tax(data):
    try:
        hubtax = HubTaxes.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not hubtax:
            error = ApiResponse(False, 'Tax Does not Exists', None,
                            'Given Tax Id is Wrong or deleted')
            return (error.__dict__), 400
        
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        
        if user['role'] not in ['super_admin' , 'distributor']:
            error = ApiResponse(False, 'User has No access', None,
                            'User has No access')
            return (error.__dict__), 403

        hub = Hub.query.filter_by(id = hubtax.hub_id).filter_by(deleted_at = None).first()
        
        if not hub:
            error = ApiResponse(False, 'Hub Does not Exists', None,
                            'Given Hub Id is Wrong or deleted')
            return (error.__dict__), 400
        
        if hub.distributor_id != user_id :
            error = ApiResponse(False, 'Distributor have no access to update taxes to this Hub', None,
                            'Hub id is not matched with Distributor id')
            return (error.__dict__), 400

        hubtax.deleted_at = datetime.datetime.utcnow()

        save_db(hubtax)
                
        
        apiResponse = ApiResponse(True, 'New Hub Tax Deleted Successfully', None,
                            None)
        return (apiResponse.__dict__), 201 

    except Exception as e:
        error = ApiResponse(False, 'Deleting Tax to the Hub Failed', None,
                            str(e))
        return (error.__dict__), 500

def show_hub_tax(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role=user['data']['role']

        hub = Hub.query.filter_by(slug = data['slug']).filter_by(deleted_at = None).first()
        
        if not hub:
            error = ApiResponse(False, 'Hub Does not Exists', None,
                            'Given Hub Id is Wrong or deleted')
            return (error.__dict__), 400

        if role not in ['super_admin' , 'distributor', 'supervisor']:
            error = ApiResponse(False, 'User has No access', None,
                            'User has No access')
            return (error.__dict__), 403

        if role == "distributor":
            
            if hub.distributor_id != user_id :
                error = ApiResponse(False, 'Distributor have no access to update taxes to this Hub', None,
                                'Hub id is not matched with Distributor id')
                return (error.__dict__), 400
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        

        taxes = HubTaxes.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).order_by(func.lower(HubTaxes.name)).all()

        return_object = []
        for tax in taxes: 
            tax = {
                'id' : tax.id,
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

def add_delivery_associate(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']
        
        hub = Hub.query.filter_by(slug=data['slug']).first()

        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400

        delivery_associate = DeliveryAssociate.query.filter_by(
            email=data['delivery_associate_email']).first()
        delivery_associate_phone = DeliveryAssociate.query.filter_by(
            phone=data['delivery_associate_phone']).first()

        if not delivery_associate_phone:

            if not delivery_associate:
                password = f"password_{data['delivery_associate_phone']}"

                new_delivery_associate = DeliveryAssociate(email=data['delivery_associate_email'],
                                        name=data['delivery_associate_name'],
                                        image = profile_pic_dir + "default.png",
                                        password=password,
                                        phone=data['delivery_associate_phone'],
                                        created_at=datetime.datetime.utcnow())
            
                save_db(new_delivery_associate,"DeliveryAssociate")
                

            else:
                error = ApiResponse(False, 'Delivery Associate Phonenumber not matched', None,
                                    None)
                return (error.__dict__), 400
        
        elif delivery_associate:
            if delivery_associate.id == delivery_associate_phone.id:
                new_delivery_associate = delivery_associate

            else:
                error = ApiResponse(False, 'Delivery Associate Phone number not matched', None,
                                    None)
                return (error.__dict__), 400
        
        else:
            error = ApiResponse(False, 'Delivery Associate Email and Phonenumber not matched', None,
                                    None)
            return (error.__dict__), 400
        
        new_hub_da_map = HubDA(
            hub_id = hub.id,
            delivery_associate_id = new_delivery_associate.id,
            status=1,
            created_at=datetime.datetime.utcnow())

        save_db(new_hub_da_map, "HubDA")
        
    
        apiResponce = ApiResponse(
                True, 'Delivery Associate Added Successfully', None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def get_hub_delivery_associates(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role not in ['super_admin' , 'distributor', 'supervisor']:
            error = ApiResponse(False, 'User has No access', None,
                            'User has No access')
            return (error.__dict__), 403

        if role == "distributor" and hub.distributor_id != user_id:
            error = ApiResponse(False, 'Distributor have no access to update taxes to this Hub', None,
                            'Hub id is not matched with Distributor id')
            return (error.__dict__), 403
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
                
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400

        hub_da_ids = HubDA.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).all()
        
        return_object = []
        for hub_da in hub_da_ids:
            da = DeliveryAssociate.query.filter_by(id = hub_da.delivery_associate_id).filter_by(deleted_at = None).first()
            
            if not da:
                hub_da_mappers = HubDA.query.filter_by(delivery_associate_id = data['delivery_associate_id']).filter_by(deleted_at = None).all()
                for mappers in hub_da_mappers:
                    mappers.deleted_at = datetime.datetime.now()
                    save_db(mappers, "HubDA")
                    
            
            else:
                delivery_associate = hub_da.delivery_associate
                object = {
                    'id': delivery_associate.id,
                    'name': delivery_associate.name,
                    'image': delivery_associate.image
                }
            
                return_object.append(object)
        
        apiResponce = ApiResponse(
                True, 'Delivery Associates Fetched Successfully', return_object, None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

def delete_hub_delivery_associate(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role != 'distributor':
            apiResponce = ApiResponse(False, 'User has No access to this hub', None,
                                        None)
            return (apiResponce.__dict__), 403

        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass

        if hub.deleted_at != None:
            apiResponce = ApiResponse(False, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400

        hub_da_mapper = HubDA.query.filter_by(hub_id = hub.id).filter_by(delivery_associate_id = data['delivery_associate_id']).filter_by(deleted_at = None).first()
        
        if not hub_da_mapper:
            apiResponce = ApiResponse(False, 'Delivery Associate Not Found')
            return (apiResponce.__dict__), 400

        # if hub.da_id == data['delivery_associate_id']:
        #     apiResponce = ApiResponse(False, 'Cannot Delete Selected Delivery Associate')
        #     return (apiResponce.__dict__), 400

        hub_da_mapper.deleted_at = datetime.datetime.utcnow()
        
        save_db(hub_da_mapper,"HubDA")
        
            
        apiResponce = ApiResponse(
                True, 'Delivery Associates Deleted Successfully', None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500
    
#NOT USING
def get_selected_hub_delivery_associate(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        role = user['role']
        user_id = user['id']

        hub = Hub.query.filter_by(slug=data['slug']).first()
        
        if not hub:
            apiResponce = ApiResponse(False, 'Hub does not exists.', None,
                                        None)
            return (apiResponce.__dict__), 400
        
        if role == 'distributor':
            if hub.distributor_id != user_id:
                apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
                                            None)
                return (apiResponce.__dict__), 403
            
            else:
                pass
        
        elif role == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)
            
            if hub.city_id not in city_ids:
                apiResponce = ApiResponse(False, 'Supervisor has No access to See Order Payments')
                return (apiResponce.__dict__), 403
        
        # elif role != 'super_admin':
        #     apiResponce = ApiResponse(False, 'User has No access to this hub', None,
        #                                 None)
        #     return (apiResponce.__dict__), 403

        if hub.deleted_at != None:
            apiResponce = ApiResponse(True, 'Hub Already Deleted.')
            return (apiResponce.__dict__), 400
        
        if hub.da_id == 0 or hub.da_id == None:
            apiResponce = ApiResponse(False, 'No Delivery Associate Selected', None,
                                        None)
            return (apiResponce.__dict__), 400
            
        hub_da = HubDA.query.filter_by(hub_id = hub.id).filter_by(delivery_associate_id = hub.da_id).filter_by(deleted_at = None).first()


        if not hub_da:
            delivery_associate = DeliveryAssociate.query.filter_by(id = hub.da_id).filter_by(deleted_at = None).first()

#             if not delivery_associate:
#                 hub_da_mappers = HubDA.query.filter_by(delivery_associate_id = hub.da_id).filter_by(deleted_at = None).all()
#                 for mappers in hub_da_mappers:
#                     mappers.deleted_at = datetime.datetime.now()
#                     save_db(mappers, "HubDA")
#                     if error:
#                         return error,500
            
            hub_da_mapper = HubDA.query.filter_by(hub_id = hub.id).filter_by(deleted_at = None).all()
            check = False
            for mapper in hub_da_mapper:
                da = DeliveryAssociate.query.filter_by(id = mapper.delivery_associate_id).filter_by(deleted_at = None).first()
                if da:
                    check=True
                    break
                    
#                     hub_da_mappers = HubDA.query.filter_by(delivery_associate_id = mapper.delivery_associate_id).filter_by(deleted_at = None).all()
#                     for mappers in hub_da_mappers:
#                         mappers.deleted_at = datetime.datetime.now()
#                         save_db(mappers, "HubDA")
#                         if error:
#                             return error,500

#                 if check:
#                     hub.da_id = mapper.delivery_associate_id
#                     save_db(hub, "Hub")
#                     if error:
#                         return error,500

                
#                 else:
#                     hub.da_id = 0
#                     save_db(hub, "Hub")
#                     if error:
#                         return error,500

                apiResponce = ApiResponse(False, 'No DeliveryAssociate Found', None,
                                    None)
                return (apiResponce.__dict__), 400

            else:
                new_hub_da = HubDA(
                   hub_id = hub.id,
                   delivery_associate_id = hub.da_id,
                   created_at = datetime.datetime.utcnow()
                )

#                 save_db(new_hub_da, "HubDA")
#                 if error:
#                     return error,500

        
        delivery_associate = hub.delivery_associate
        return_object = {
            'id' : delivery_associate.id,
            'name': delivery_associate.name,
            'image': delivery_associate.image
        }

        apiResponce = ApiResponse(
                True, 'Delivery Associate Fetched Successfully', return_object, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500

#Not Using
# def select_hub_delivery_associate(data):    
#     try:
#         resp, status = Auth.get_logged_in_user(request)
#         user = resp['data']
#         role = user['role']
#         user_id = user['id']

#         hub = Hub.query.filter_by(slug=data['slug']).first()
        
#         if not hub:
#             apiResponce = ApiResponse(False, 'Hub does not exists.', None,
#                                         None)
#             return (apiResponce.__dict__), 400
        
#         if role != 'distributor':
#             apiResponce = ApiResponse(False, 'User has No access to this hub', None,
#                                         None)
#             return (apiResponce.__dict__), 403

#         if role == 'distributor':
#             if hub.distributor_id != user_id:
#                 apiResponce = ApiResponse(False, 'Distributor has No access to this hub', None,
#                                             None)
#                 return (apiResponce.__dict__), 403
            
#             else:
#                 pass

#         if hub.deleted_at != None:
#             apiResponce = ApiResponse(False, 'Hub Already Deleted.')
#             return (apiResponce.__dict__), 400

#         hub_da_mapper = HubDA.query.filter_by(hub_id = hub.id).filter_by(delivery_associate_id = data['delivery_associate_id']).filter_by(deleted_at = None).first()
        
#         if not hub_da_mapper:
#             apiResponce = ApiResponse(False, 'Delivery Associate Not Found')
#             return (apiResponce.__dict__), 400
        
#         da = DeliveryAssociate.query.filter_by(id = hub_da_mapper.delivery_associate_id).filter_by(deleted_at = None).first()
#         if not da:
#             hub_da_mappers = HubDA.query.filter_by(delivery_associate_id = data['delivery_associate_id']).filter_by(deleted_at = None).all()
#             for mappers in hub_da_mappers:
#                 mappers.deleted_at = datetime.datetime.now()
#                 save_db(mappers, "HubDA")
#                 if error:
#                     return error,500

#             apiResponce = ApiResponse(False, 'Delivery Associate is Deleted')
#             return (apiResponce.__dict__), 400

#         hub.da_id = data['delivery_associate_id']

#         save_db(hub, "Hub")
#         if error:
#             return error,500


#         apiResponce = ApiResponse(
#                 True, 'Delivery Associate Selected Successfully')
#         return (apiResponce.__dict__), 200
#     except Exception as e:
#         apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
#         return (apiResponce.__dict__), 500