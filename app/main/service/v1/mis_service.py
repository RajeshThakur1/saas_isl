from app.main.model.storeMis import StoreMis
from app.main.util.v1.dateutil import str_to_datetime
from app.main.model.cityMisDetails import CityMisDetails
from app.main.model.storeLocalities import StoreLocalities
from app.main.model.locality import Locality
from app.main.model.city import City
from re import split
from app.main.model.storeItems import StoreItem
from app.main.util.v1.database import get_count, save_db
from datetime import datetime, timedelta
from app.main.model.store import Store
from app.main.model.storeItemVariable import StoreItemVariable
from app.main.model.itemOrders import ItemOrder
from app.main.model.user import User
from app.main.model.misDetails import MisDetails
from app.main.model.apiResponse import ApiResponse
from app.main import db 

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/mis_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")


def mis_details(data):
    try:
        date =  str_to_datetime(data['date'])
        end_date = date+timedelta(days=1)

        daily_new_user = get_count(User.query.filter(User.created_at >= date).filter(User.created_at < end_date).filter_by(deleted_at = None))

        # date_min  = datetime(f"{date} 00:00:00")

        order_delivered = get_count(ItemOrder.query.filter(ItemOrder.order_delivered >= date).filter(ItemOrder.order_delivered < end_date).filter_by(deleted_at = None))

        order_canceled = get_count(ItemOrder.query.filter(ItemOrder.updated_at >= date).filter(ItemOrder.updated_at < end_date).filter_by(status = 11).filter_by(deleted_at = None))

        new_items_added = get_count(StoreItem.query.filter(StoreItem.created_at >= date).filter(StoreItem.created_at < end_date).filter_by(deleted_at = None))

        new_stores_created = get_count(Store.query.filter(Store.created_at >= date).filter(Store.created_at < end_date).filter_by(deleted_at = None))

        orders = ItemOrder.query.filter(ItemOrder.order_created >= date).filter(ItemOrder.order_created < end_date).filter_by(deleted_at = None).filter_by(status=1).all()

        total_order_value = 0        
        total_discount_value = 0        
        delivery_fees = 0
        commission = 0
        total_tax = 0

        for order in orders:
            
            if order.order_total:
                total_order_value += order.order_total
            
            if order.order_total_discount:
                total_discount_value += order.order_total_discount
            
            if order.delivery_fee:
                delivery_fees += order.delivery_fee
            
            if order.commission:
                commission += order.commission
            
            if order.total_tax:
                total_tax += order.total_tax

        turn_over = total_order_value - total_discount_value + delivery_fees + total_tax
        
        average_order_value = total_order_value
        if order_delivered > 0 :
            average_order_value = total_order_value / order_delivered

        

        mis_details = MisDetails.query.filter_by(date = date).filter_by(deleted_at = None).first()

        if not mis_details:
            
            new_mis = MisDetails(
                date = date,
                daily_new_user = daily_new_user,
                order_delivered = order_delivered,
                order_canceled = order_canceled,
                new_items_added = new_items_added,
                new_stores_created = new_stores_created,
                average_order_value = average_order_value,
                total_order_value = total_order_value,
                total_discount_value = total_discount_value,
                delivery_fees = delivery_fees,
                total_tax = total_tax,
                turnover = turn_over,
                commission = commission,
                created_at = datetime.utcnow()
            )

            save_db(new_mis, "MisDetail")
            
        
        else:
            mis_details.date = date
            mis_details.daily_new_user = daily_new_user
            mis_details.order_delivered = order_delivered
            mis_details.order_canceled = order_canceled
            mis_details.new_items_added = new_items_added
            mis_details.new_stores_created = new_stores_created
            mis_details.average_order_value = average_order_value
            mis_details.total_order_value = total_order_value
            mis_details.total_discount_value = total_discount_value
            mis_details.delivery_fees = delivery_fees
            mis_details.total_tax = total_tax
            mis_details.turnover = turn_over
            mis_details.commission = commission
            mis_details.updated_at = datetime.utcnow()

        save_db(mis_details, "MisDetail")
        
        city_mis_details(data)

        store_mis(data)

        apiresponse = ApiResponse(True, f"Mis Details Updated for {date}, City Mis Details Added for {date}, Store Mis Details Added for {date}",None, None)
        return apiresponse.__dict__ , 200


    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured',None,str(e))
        return (apiResponce.__dict__), 500


def city_mis_details(data):
    try:
        date =  str_to_datetime(data['date'])
        end_date = date+timedelta(days=1)
        cities = City.query.filter_by(deleted_at = None).order_by(City.id).all()

        for city in cities:

            stores = Store.query.filter_by(city_id = city.id).filter_by(deleted_at = None).all()

            store_ids = []
            
            for store in stores:
                store_ids.append(store.id)
        
            order_delivered = get_count(ItemOrder.query.filter(ItemOrder.order_delivered >= date).filter(ItemOrder.order_delivered < end_date).filter(ItemOrder.store_id.in_(store_ids)).filter_by(deleted_at = None))

            order_canceled = get_count(ItemOrder.query.filter(ItemOrder.updated_at >= date).filter(ItemOrder.updated_at < end_date).filter_by(status = 11).filter(ItemOrder.store_id.in_(store_ids)).filter_by(deleted_at = None))

            new_stores_created = get_count(Store.query.filter(Store.created_at >= date).filter(Store.created_at < end_date).filter(Store.id.in_(store_ids)).filter_by(deleted_at = None))

            new_locality = get_count(Locality.query.filter(Locality.created_at >= date).filter(Locality.created_at < end_date).filter_by(city_id = city.id).filter_by(deleted_at = None))

            orders = ItemOrder.query.filter(ItemOrder.order_created >= date).filter(ItemOrder.order_created < end_date).filter(ItemOrder.store_id.in_(store_ids)).filter_by(deleted_at = None).filter_by(status=1).all()


            total_order_value = 0        
            total_discount_value = 0        
            delivery_fees = 0
            commission = 0
            total_tax = 0

            for order in orders:
                
                if order.order_total:
                    total_order_value += order.order_total
                
                if order.order_total_discount:
                    total_discount_value += order.order_total_discount
                
                if order.delivery_fee:
                    delivery_fees += order.delivery_fee
                
                if order.commission:
                    commission += order.commission

                if order.total_tax:
                    total_tax += order.total_tax

            turn_over = total_order_value - total_discount_value + delivery_fees

            average_order_value = total_order_value
            if order_delivered > 0 :
                average_order_value = total_order_value / order_delivered

            city_mis_details = CityMisDetails.query.filter_by(date = date).filter_by(city_id = city.id).filter_by(deleted_at = None).first()
            
            mis_details = MisDetails.query.filter_by(date = date).filter_by(deleted_at = None).first()

            if not city_mis_details:    
                new_mis = CityMisDetails(
                    mis_id = mis_details.id,
                    city_id = city.id,
                    date = date,
                    order_delivered = order_delivered,
                    order_canceled = order_canceled,
                    new_locality = new_locality,
                    new_stores_created = new_stores_created,
                    average_order_value = average_order_value,
                    total_order_value = total_order_value,
                    total_discount_value = total_discount_value,
                    total_tax = total_tax,
                    delivery_fees = delivery_fees,
                    turnover = turn_over,
                    commission = commission,
                    created_at = datetime.utcnow()
                )

                save_db(new_mis, "CityMisDetail")
                

            else:
                city_mis_details.mis_id = mis_details.id
                city_mis_details.city_id = city.id
                city_mis_details.date = date
                city_mis_details.order_delivered = order_delivered
                city_mis_details.order_canceled = order_canceled
                city_mis_details.new_locality = new_locality,
                city_mis_details.new_stores_created = new_stores_created
                city_mis_details.average_order_value = average_order_value
                city_mis_details.total_order_value = total_order_value
                city_mis_details.total_discount_value = total_discount_value
                city_mis_details.delivery_fees = delivery_fees
                city_mis_details.total_tax = total_tax
                city_mis_details.turnover = turn_over
                city_mis_details.commission = commission
                city_mis_details.updated_at = datetime.utcnow()

                save_db(city_mis_details, "CityMisDetail")

                # apiresponse = ApiResponse(True, f"City Mis Details Updated for {date}",None, None)
                # return apiresponse.__dict__ , 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured',None,str(e))
        return (apiResponce.__dict__), 500


def store_mis(data):
    try:
        date =  str_to_datetime(data['date'])
        end_date = date+timedelta(days=1)

        # date_min  = datetime(f"{date} 00:00:00")
        stores = Store.query.filter_by(deleted_at = None).all()

        for store in stores:

            order_delivered = get_count(ItemOrder.query.filter_by(store_id = store.id).filter(ItemOrder.order_delivered >= date).filter(ItemOrder.order_delivered < end_date).filter_by(deleted_at = None))

            order_canceled = get_count(ItemOrder.query.filter_by(store_id = store.id).filter(ItemOrder.updated_at >= date).filter(ItemOrder.updated_at < end_date).filter_by(status = 11).filter_by(deleted_at = None))

            new_items_added = get_count(StoreItem.query.filter_by(store_id = store.id).filter(StoreItem.created_at >= date).filter(StoreItem.created_at < end_date).filter_by(deleted_at = None))

            orders = ItemOrder.query.filter_by(store_id = store.id).filter(ItemOrder.order_created >= date).filter(ItemOrder.order_created < end_date).filter_by(deleted_at = None).filter_by(status=1).all()

            total_order_value = 0        
            total_discount_value = 0        
            delivery_fees = 0
            commission = 0
            total_tax = 0

            for order in orders:
                
                if order.order_total:
                    total_order_value += order.order_total
                
                if order.order_total_discount:
                    total_discount_value += order.order_total_discount
                
                if order.delivery_fee:
                    delivery_fees += order.delivery_fee
                
                if order.commission:
                    commission += order.commission
                
                if order.total_tax:
                    total_tax += order.total_tax

            turn_over = total_order_value - total_discount_value + delivery_fees
            
            average_order_value = total_order_value
            if order_delivered > 0 :
                average_order_value = total_order_value / order_delivered

            

            store_mis = StoreMis.query.filter_by(date = date).filter_by(store_id = store.id).filter_by(deleted_at = None).first()

            if not store_mis:
                
                new_mis = StoreMis(
                    date = date,
                    order_delivered = order_delivered,
                    order_canceled = order_canceled,
                    new_items_added = new_items_added,
                    average_order_value = average_order_value,
                    total_order_value = total_order_value,
                    total_discount_value = total_discount_value,
                    delivery_fees = delivery_fees,
                    total_tax = total_tax,
                    turnover = turn_over,
                    commission = commission,
                    store_id = store.id,
                    created_at = datetime.utcnow()
                )

                save_db(new_mis, "StoreMis")
                
            
            else:
                store_mis.date = date
                store_mis.order_delivered = order_delivered
                store_mis.order_canceled = order_canceled
                store_mis.new_items_added = new_items_added
                store_mis.average_order_value = average_order_value
                store_mis.total_order_value = total_order_value
                store_mis.total_discount_value = total_discount_value
                store_mis.delivery_fees = delivery_fees
                store_mis.total_tax = total_tax
                store_mis.turnover = turn_over
                store_mis.commission = commission
                store_mis.store_id = store.id
                store_mis.updated_at = datetime.utcnow()

                save_db(store_mis, "StoreMis")
                


    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured',None,str(e))
        return (apiResponce.__dict__), 500