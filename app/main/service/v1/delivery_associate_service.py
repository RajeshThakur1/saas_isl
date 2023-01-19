from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.config import profile_pic_dir
import datetime
from app.main.util.v1.database import save_db
from app.main.model.apiResponse import ApiResponse
from app.main.model.hubDa import HubDA

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/delivery_associate_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def add_delivery_associate(data):
    try:
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
            hub_id = data['hub_id'],
            delivery_associate_id = new_delivery_associate.id,
            status=1,
            created_at=datetime.datetime.utcnow())

        save_db(new_hub_da_map, "HubDA")
        
    
        apiResponce = ApiResponse(
                False, 'Delivery Associate Added Successfully', None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Error Occured', None, str(e))
        return (apiResponce.__dict__), 500




