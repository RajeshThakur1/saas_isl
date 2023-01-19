from app.main.model.hub import Hub
from app.main.model.hubDa import HubDA
from app.main.model.hubOrders import HubOrders
from app.main.model.merchant import Merchant
from app.main.model.userCities import UserCities
from app.main.model.userAddress import UserAddress
from app.main.model.city import City
from app.main.model.cityMisDetails import CityMisDetails
from app.main.service.v1.mis_service import city_mis_details, mis_details
from app.main.model.misDetails import MisDetails
from app.main.util.v1.database import get_count
from app.main.util.v1.filegen import create_excel
from app.main.util.v1.orders import order_distance
from app.main.util.v1.dateutil import date_to_str, daterange, str_to_date, str_to_datetime
from app.main.model.itemOrders import ItemOrder
from app.main.model.itemOrderLists import ItemOrderLists
from app.main.model.user import User
from app.main.model.store import Store
from app.main.model.locality import Locality
import datetime
from app.main.model.apiResponse import ApiResponse
from app.main.model.storeLocalities import StoreLocalities
from app.main.service.v1.auth_helper import Auth
from app.main.model.storeItems import StoreItem
from flask import request

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/dashboard_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

#Super_ADMIN

def get_stats_super_admin():

    try:

        customer_count = get_count(User.query.filter_by(deleted_at = None))

        store_count = get_count(Store.query.filter_by(deleted_at = None))

        locality_count = get_count(Locality.query.filter_by(deleted_at = None))

        order_count = get_count(ItemOrder.query.filter(ItemOrder.order_created != None , ItemOrder.status != 11 , ItemOrder.deleted_at == None))

        delivered_order_count = get_count(ItemOrder.query.filter(ItemOrder.order_delivered != None , ItemOrder.deleted_at == None))

        data = {
            "users": customer_count,
            "orders": order_count,
            "stores": store_count,
            "locality": locality_count,
            "delivered": delivered_order_count
        }

        apiResponce = ApiResponse(True,'Data Fetched successfully',data,None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured',None,str(e.with_traceback))
        return (apiResponce.__dict__), 500

def get_latest_orders_super_admin():
    try:
        
        orders = ItemOrder.query.filter(ItemOrder.order_created != None).filter_by(deleted_at = None).order_by(ItemOrder.id.desc()).limit(100).all()
        
        order_object = []
        for order in orders:
            
            store_name = ""
            store_id = order.store_id
            
            user_name = ""
            user_id = order.user_id

            order_id = order.id

            store = Store.query.filter_by(id = order.store_id).first()

            if store:
                store_name = store.name
            
            user = User.query.filter_by(id = order.user_id).first()
            
            if user:
                user_name = user.name

            data = {
                'order_id' : order_id,
                'store_id' : store_id,
                'store_name' : store_name,
                'user_id' : user_id,
                'user_name' : user_name, 
            }

            order_object.append(data)

        apiResponce = ApiResponse(True,'',order_object,'')
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def get_latest_users_super_admin():
    try:
        users = User.query.filter_by(deleted_at = None).filter_by(active = True).order_by(User.id.desc()).limit(100).all()

        user_object = []

        for user in users:
            data = {
                'id' : user.id,
                'name' : user.name,
                'phone' : user.phone,
                'created_at' : date_to_str(user.created_at)
            }
            user_object.append(data)
        
        apiResponce = ApiResponse(True,'',user_object,'')
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def get_open_orders_super_admin():
    try:
        orders = ItemOrder.query.filter(ItemOrder.order_created != None).filter_by(status = 1).filter_by(deleted_at = None).filter_by(order_delivered = None).order_by(ItemOrder.id.desc()).limit(100).all()

        order_object = []
        for order in orders:
            
            store_name = ""
            store_id = order.store_id
            
            user_name = ""
            user_id = order.user_id

            order_id = order.id

            store = Store.query.filter_by(id = order.store_id).first()

            if store:
                store_name = store.name
            
            user = User.query.filter_by(id = order.user_id).first()
            
            if user:
                user_name = user.name

            data = {
                'order_id' : order_id,
                'store_id' : store_id,
                'store_name' : store_name,
                'user_id' : user_id,
                'user_name' : user_name,
                'status': order.status,
                'order_created': date_to_str(order.order_created) if order.order_created else 'None',
                'order_confirmed': date_to_str(order.order_confirmed) if order.order_confirmed else 'None',
                'ready_to_pack':  date_to_str(order.ready_to_pack) if order.ready_to_pack else 'None',
                'order_paid':  date_to_str(order.order_paid) if order.order_paid else 'None',
                'order_pickedup':  date_to_str(order.order_pickedup) if order.order_pickedup else 'None',
            }
            order_object.append(data)
        
        apiResponce = ApiResponse(True,'',order_object,'')
        return (apiResponce.__dict__), 200
        

            
    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def mis_report_super_admin(data):
    try:
        start_date = str_to_datetime(data['start_date'])
        end = str_to_datetime(data['end_date']) 
        end_date = end + datetime.timedelta(days=1)

        range_date = start_date + datetime.timedelta(days=60)
        if start_date > datetime.datetime.utcnow() or end > datetime.datetime.utcnow():
            apiResponce = ApiResponse(False,"Date cannot be greater than today's date",None,"Date cannot be greater than today's date")
            return (apiResponce.__dict__), 400

        if end_date > range_date:
            apiResponce = ApiResponse(False,'Date Interval Can not be Greater than 60 days',None,None)
            return (apiResponce.__dict__), 400
        
        if end_date < start_date:
            apiResponce = ApiResponse(False,'Start Date Cannot be Greater than End Date',None,None)
            return (apiResponce.__dict__), 400

        if data['city_ids'] == []:

            mis_details = MisDetails.query.filter(MisDetails.date >= start_date).filter(MisDetails.date < end_date).all()

            customer_added = 0
            order_delivered = 0
            order_canceled = 0
            delivery_fees = 0
            skus_added = 0
            total_order_value = 0
            total_discount_value = 0
            stores_added = 0
            commission = 0
            total_tax = 0

            for mis in mis_details:
                customer_added += mis.daily_new_user
                order_delivered += mis.order_delivered
                order_canceled += mis.order_canceled
                delivery_fees += mis.delivery_fees
                skus_added += mis.new_items_added
                total_order_value += mis.total_order_value
                total_discount_value += mis.total_discount_value
                stores_added += mis.new_stores_created
                commission += mis.commission
                total_tax += mis.total_tax

            turnover = total_order_value - total_discount_value + delivery_fees
            average_order_value = 0

            if order_delivered > 0:
                average_order_value = total_order_value / order_delivered

            return_object = {
               "customer_added":customer_added,
               "order_delivered":order_delivered,
               "order_cancelled":order_canceled,
               "skus_added":skus_added,
               "average_order_value":average_order_value,
               "commission":commission,
               "delivery_fees": delivery_fees,
               "stores_added":stores_added,
               "total_order_value":total_order_value,
               "total_discount_value":total_discount_value,
               "turnover":turnover,
               "tax" : total_tax,
            }

            apiresponse = ApiResponse(True,f"Mis Report From {data['start_date']} to {data['end_date']} is Fetched", return_object, "")

            return apiresponse.__dict__ , 200
        
        else:

            customer_added = 0
            order_delivered = 0
            order_canceled = 0
            delivery_fees = 0
            skus_added = 0
            locality_added = 0
            total_order_value = 0
            total_discount_value = 0
            stores_added = 0
            commission = 0
            city_name = ""
            total_tax = 0

            for city in data['city_ids']:
                city_mis_details = CityMisDetails.query.filter(CityMisDetails.date >= start_date).filter(CityMisDetails.date < end_date).filter_by(city_id = city).all()
                
                city_obj = City.query.filter_by(id = city).first()
                city_name = city_name + city_obj.name + ", "

                for city_mis in city_mis_details:
                    order_delivered += city_mis.order_delivered
                    order_canceled += city_mis.order_canceled
                    delivery_fees += city_mis.delivery_fees
                    locality_added += city_mis.new_locality
                    total_order_value += city_mis.total_order_value
                    total_discount_value += city_mis.total_discount_value
                    stores_added += city_mis.new_stores_created
                    commission += city_mis.commission
                    total_tax += city_mis.total_tax
                
                    mis_details = MisDetails.query.filter_by(id = city_mis.mis_id).all()
                
                    for mis in mis_details:
                        customer_added += mis.daily_new_user
                        skus_added += mis.new_items_added
            
            turnover = total_order_value - total_discount_value + delivery_fees
            average_order_value = 0

            if order_delivered > 0:
                average_order_value = total_order_value / order_delivered

            return_object = {
               "customer_added":customer_added,
               "order_delivered":order_delivered,
               "order_cancelled":order_canceled,
               "skus_added":skus_added,
               "locality_added" : locality_added,
               "average_order_value":average_order_value,
               "commission":commission,
               "delivery_fees": delivery_fees,
               "stores_added":stores_added,
               "total_order_value":total_order_value,
               "total_discount_value":total_discount_value,
               "turnover":turnover,
               "tax" : total_tax
            }

            apiresponse = ApiResponse(True,f"Mis Report From {date_to_str(start_date)} to {data['end_date']} for City {city_name[:-2]} is Fetched", return_object, "")

            return apiresponse.__dict__ , 200

    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Mis Order Report',None,str(e))
        return (apiResponce.__dict__), 500

def detailed_mis_report_super_admin(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        start_date = str_to_datetime(data['start_date'])
        end = str_to_datetime(data['end_date']) 
        end_date = end + datetime.timedelta(days=1)

        range_date = start_date + datetime.timedelta(days=60)
        if start_date > datetime.datetime.utcnow() or end > datetime.datetime.utcnow():
            apiResponce = ApiResponse(False,"Date cannot be greater than today's date",None,"Date cannot be greater than today's date")
            return (apiResponce.__dict__), 400

        if end_date > range_date:
            apiResponce = ApiResponse(False,'Date Interval Can not be Greater than 60 days',None,None)
            return (apiResponce.__dict__), 400
        
        if end_date < start_date:
            apiResponce = ApiResponse(False,'Start Date Cannot be Greater than End Date',None,None)
            return (apiResponce.__dict__), 400

        orders = ItemOrder.query.filter(ItemOrder.order_delivered != None,ItemOrder.order_created >= start_date, ItemOrder.order_created <= end_date, ItemOrder.deleted_at == None).order_by(ItemOrder.delivery_date.desc()).all()

        order_object = []
        for order in orders:

            store_name = ""
            store_id = order.store_id
            
            city_name = ""
            
            order_total = order.order_total

            if not order.order_total:
                order_total = "Not Found"
                commission = "Unable to Calculate"
            
            elif order.commission == None:
                commission = 0

            else:
                commission = order.commission

            store = Store.query.filter_by(id = order.store_id).first()

            commission_percentage = 0
            
            if store:
                store_name = store.name
                commission_percentage = store.commission
            #city logic

            #comisson_percentage logic

            discount = 0

            if order.order_total_discount:
                discount = order.order_total_discount

            distance = order_distance(order)

            delivery_fee = 0

            if delivery_fee:
                delivery_fee = order.delivery_fee

            if not order.grand_order_total:
                if isinstance(order_total,str):
                    grand_order_total = 0
                
                else:
                    grand_order_total = order_total - discount + delivery_fee 
            
            else:
                grand_order_total = order.grand_order_total
            
            total_tax = 0
            if order.total_tax:
                total_tax = order.total_tax

            object = {
                'order_id' : order.id,
                'order_created' : date_to_str(order.order_created),
                'delivered_date' : date_to_str(order.order_delivered),
                'store_name' : store_name,
                'store_id' : store_id,
                'city_name' : city_name,
                'commission_percentage' : commission_percentage,
                'commission' : commission,
                'order_total' : order_total,
                'discount': discount,
                'tax' : total_tax,
                'delivery_fee' : delivery_fee,
                'grand_total' : grand_order_total,
                'distance(km)' : distance
            }

            order_object.append(object)
        
        #Excel Download Logic
        filename = f"OrderMisReport_{user['role']}_{user['name']}.xlsx"
        url = create_excel(order_object,filename)
        
        response={
            'misData' : order_object,
            'url': url
        }
        
        apiResponce = ApiResponse(True,f"Order Report From {data['start_date']} to {str(data['end_date'])} Fetched Successfully",response,None)
        return (apiResponce.__dict__), 200


    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

def mis_graph_super_admin(data):
    try:
        start_date = str_to_datetime(data['start_date'])
        end = str_to_datetime(data['end_date']) 
        end_date = end + datetime.timedelta(days=1)

        range_date = start_date + datetime.timedelta(days=60)
        if start_date > datetime.datetime.utcnow() or end > datetime.datetime.utcnow():
            apiResponce = ApiResponse(False,"Date cannot be greater than today's date",None,"Date cannot be greater than today's date")
            return (apiResponce.__dict__), 400

        if end_date > range_date:
            apiResponce = ApiResponse(False,'Date Interval Can not be Greater than 60 days',None,None)
            return (apiResponce.__dict__), 400
        
        if end_date < start_date:
            apiResponce = ApiResponse(False,'Start Date Cannot be Greater than End Date',None,None)
            return (apiResponce.__dict__), 400
            
        if data['city_ids'] == []:
            #mis_details = MisDetails.query.filter(MisDetails.date >= start_date).filter(MisDetails.date <= end_date).all()

            customer_added = []
            order_canceled = []
            skus_added = []
            new_store_created = []
            average_order_value = []
            total_order_value = []
            delivery_fees = []
            turnover = []
            total_discount_value = []
            order_delivered = []

            for date_var in daterange(start_date,end_date):
                
                mis = MisDetails.query.filter(MisDetails.date == date_var).first()

                if mis:
                 
                    customer_add_object = {
                        'Date' : date_to_str(mis.date),
                        'Customer Added': mis.daily_new_user,
                        "dataVal": mis.daily_new_user
                    }
                    customer_added.append(customer_add_object)

                    order_canceled_object = {
                        'Date' : date_to_str(mis.date),
                        'Order Canceled': mis.order_canceled,
                        "dataVal": mis.order_canceled
                    }

                    order_canceled.append(order_canceled_object)
                    
                    skus_added_object = {
                        'Date' : date_to_str(mis.date),
                        'Skus Added': mis.new_items_added,
                        "dataVal": mis.new_items_added
                    }
                    skus_added.append(skus_added_object)
                    
                    new_store_created_object = {
                        'Date' : date_to_str(mis.date),
                        'New Store Created': mis.new_stores_created,
                        "dataVal": mis.new_stores_created
                    }
                    new_store_created.append(new_store_created_object)

                    average_order_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Average Order Value': mis.average_order_value,
                        "dataVal": mis.average_order_value
                    }
                    average_order_value.append(average_order_value_object)

                    total_order_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Total Order Value': mis.total_order_value,
                        "dataVal": mis.total_order_value
                    }
                    total_order_value.append(total_order_value_object)
                    
                    delivery_fees_object = {
                        'Date' : date_to_str(mis.date),
                        'Delivery Fees': mis.delivery_fees,
                        "dataVal": mis.delivery_fees
                    }
                    delivery_fees.append(delivery_fees_object)

                    turnover_object = {
                        'Date' : date_to_str(mis.date),
                        'Turnover': mis.turnover,
                        "dataVal": mis.turnover
                    }
                    turnover.append(turnover_object)
                    
                    total_discount_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Total Discount Value': mis.total_discount_value,
                        "dataVal": mis.total_discount_value
                    }
                    total_discount_value.append(total_discount_value_object)

                    order_delivered_object = {
                        'Date' : date_to_str(mis.date),
                        'Order Delivered': mis.order_delivered,
                        "dataVal": mis.order_delivered
                    }
                    order_delivered.append(order_delivered_object)
                
                # else:

                #     date.append(date_to_str(date_var))
                #     customer_added.append(0)
                #     order_canceled.append(0)
                #     skus_added.append(0)
                #     new_store_created.append(0)
                #     average_order_value.append(0)
                #     total_order_value.append(0)
                #     delivery_fees.append(0)
                #     turnover.append(0)
                #     total_discount_value.append(0)
                #     order_delivered.append(0)
            
            return_object = {
                'customer_added':customer_added,
                'order_canceled':order_canceled,
                'skus_added':skus_added,
                'new_store_created':new_store_created,
                'average_order_value':average_order_value,
                'total_order_value' : total_order_value,
                'delivery_fees' : delivery_fees,
                'turnover' : turnover,
                'total_discount_value' : total_discount_value,
                'order_delivered' : order_delivered,
            }
            
            apiResponce = ApiResponse(True,f"MIS Graph From {data['start_date']} to {str(data['end_date'])} Fetched Successfully",return_object,'')
            return (apiResponce.__dict__), 200
        
        else:

            customer_added = []
            order_canceled = []
            skus_added = []
            new_store_created = []
            average_order_value = []
            total_order_value = []
            delivery_fees = []
            turnover = []
            total_discount_value = []
            order_delivered = []
            locality_added = []

            # mis_details = MisDetails.query.filter(MisDetails.date >= start_date).filter(MisDetails.date <= end_date).all()
            
            # for mis in mis_details:
            # for date_var in range(start_date,end_date,datetime.timedelta(days=1)):

            for date_var in daterange(start_date, end_date):
                           
                mis = MisDetails.query.filter(MisDetails.date == date_var).first()

                order_delivered_data = 0
                order_canceled_data = 0
                delivery_fees_data = 0
                turnover_data = 0
                locality_added_data = 0
                total_order_value_data = 0
                total_discount_value_data = 0
                stores_added_data = 0
                average_order_value_data = 0
                city_name = ""

                if mis:

                    for id in data['city_ids']:
                        city_mis = CityMisDetails.query.filter_by(mis_id = mis.id).filter_by(city_id = id).first()
                        
                        if city_mis:
                            city_obj = City.query.filter_by(id = id).first()
                            city_name = city_name + city_obj.name + ", "

                            order_delivered_data += city_mis.order_delivered
                            order_canceled_data += city_mis.order_canceled
                            delivery_fees_data += city_mis.delivery_fees
                            locality_added_data += city_mis.new_locality
                            total_order_value_data += city_mis.total_order_value
                            total_discount_value_data += city_mis.total_discount_value
                            stores_added_data += city_mis.new_stores_created
                    
                    turnover_data = total_order_value_data - total_discount_value_data + delivery_fees_data
                    average_order_value_data = 0

                    if order_delivered_data > 0:
                        average_order_value_data = total_order_value_data / order_delivered_data
                    

                    customer_add_object = {
                        'Date' : date_to_str(mis.date),
                        'Customer Added': mis.daily_new_user,
                        "dataVal": mis.daily_new_user
                    }
                    customer_added.append(customer_add_object)

                    order_canceled_object = {
                        'Date' : date_to_str(mis.date),
                        'Order Canceled': order_canceled_data,
                        "dataVal": order_canceled_data
                    }

                    order_canceled.append(order_canceled_object)
                    
                    skus_added_object = {
                        'Date' : date_to_str(mis.date),
                        'Skus Added': mis.new_items_added,
                        "dataVal": mis.new_items_added
                    }
                    skus_added.append(skus_added_object)
                    
                    new_store_created_object = {
                        'Date' : date_to_str(mis.date),
                        'New Store Created': stores_added_data,
                        "dataVal": stores_added_data
                    }
                    new_store_created.append(new_store_created_object)

                    average_order_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Average Order Value': average_order_value_data,
                        "dataVal": average_order_value_data
                    }
                    average_order_value.append(average_order_value_object)

                    total_order_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Total Order Value': total_order_value_data,
                        "dataVal": total_order_value_data
                    }
                    total_order_value.append(total_order_value_object)
                    
                    delivery_fees_object = {
                        'Date' : date_to_str(mis.date),
                        'Delivery Fees': delivery_fees_data,
                        "dataVal": delivery_fees_data
                    }
                    delivery_fees.append(delivery_fees_object)

                    turnover_object = {
                        'Date' : date_to_str(mis.date),
                        'Turnover': turnover_data,
                        "dataVal": turnover_data
                    }
                    turnover.append(turnover_object)
                    
                    total_discount_value_object = {
                        'Date' : date_to_str(mis.date),
                        'Total Discount Value': total_discount_value_data,
                        "dataVal": total_discount_value_data
                    }
                    total_discount_value.append(total_discount_value_object)

                    order_delivered_object = {
                        'Date' : date_to_str(mis.date),
                        'Order Delivered': order_delivered_data,
                        "dataVal": order_delivered_data
                    }
                    order_delivered.append(order_delivered_object)

                    locality_added_object = {
                        'Date' : date_to_str(mis.date),
                        'Order Delivered': locality_added_data,
                        "dataVal": locality_added_data
                    }
                    locality_added.append(locality_added_object)
         
            
                
                # else:
                #     date.append(date_to_str(date_var))
                #     customer_added.append(0)
                #     order_canceled.append(order_canceled_data)
                #     skus_added.append(0)
                #     new_store_created.append(stores_added_data)
                #     average_order_value.append(average_order_value_data)
                #     total_order_value.append(total_order_value_data)
                #     delivery_fees.append(delivery_fees_data)
                #     turnover.append(turnover_data)
                #     total_discount_value.append(total_discount_value_data)
                #     order_delivered.append(order_delivered_data)
                #     locality_added.append(locality_added_data)


            return_object = {
                'customer_added':customer_added,
                'order_canceled':order_canceled,
                'skus_added':skus_added,
                'new_store_created':new_store_created,
                'average_order_value':average_order_value,
                'total_order_value' : total_order_value,
                'delivery_fees' : delivery_fees,
                'turnover' : turnover,
                'total_discount_value' : total_discount_value,
                'order_delivered' : order_delivered,
                'locality_added' : locality_added,
            }

            apiresponse = ApiResponse(True,f"Mis Graph From {data['start_date']} to {data['end_date']} for City {city_name[:-2]} is Fetched", return_object, "")

            return apiresponse.__dict__ , 200

        
    except Exception as e:
        apiResponce = ApiResponse(False,'Error Occured While Fetching Latest Orders',None,str(e))
        return (apiResponce.__dict__), 500

#Merchant Dashboard Services


#Get dashboard Statistics for merchant

def get_merchant_stats():
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        merchant_stores  = Store.query.filter_by(merchant_id=user_id).filter_by(deleted_at=None).all()
        earnings = get_total_earnings(merchant_stores)
        localities = get_merchant_localities(merchant_stores)
        total_orders = get_total_items(merchant_stores)
        delivered = get_delivered_orders(merchant_stores)

        response_data = {
            'itemsCount': total_orders,
            'locality': localities,
            'delivered': delivered,
            'earnings': earnings
        }

        resp = ApiResponse(True, "Data Fetched Successfully", response_data, None)
        return resp.__dict__, 200
    except Exception as e:
        resp = ApiResponse(False, "Data Not Fetched", None, str(e))
        return resp.__dict__, 500

#Get open orders for merchant
def get_latest_orders_merchant():
    try:
        resp, status = Auth.get_logged_in_user(request)
        id= resp['data']['id']

        stores = Store.query.filter_by(merchant_id=id).filter_by(deleted_at=None).all()

        if stores:
            data = []
            for store in stores:
                orders = ItemOrder.query.filter_by(store_id=store.id).filter_by(deleted_at=None).filter(ItemOrder.order_created != None).order_by(ItemOrder.order_created.desc()).limit(10).all()

                
                for order in orders:
                    data.append({
                        'created_at': str(order.created_at),
                        'order_id': order.id,
                        'user_id': order.user_id,
                        'username': User.query.filter_by(id=order.user_id).first().name,
                        'store_id': order.store_id,
                        'store_name': Store.query.filter_by(id=order.store_id).first().name,
                        'status': order.status,
                        'order_confirmed': str(order.order_confirmed),
                        'order_created': str(order.order_created),
                        'order_delivered': str(order.order_delivered),
                        'order_paid': str(order.order_paid),
                        'ready_to_pack': str(order.ready_to_pack),
                        'order_pickedup': str(order.order_pickedup),
                        'order_total': str(order.order_total)
                    })

            apiResponce = ApiResponse(True,f"Orders Fetched Successfully",data,None)
            return (apiResponce.__dict__), 200
        
        apiResponce = ApiResponse(False,f"No Open Orders found",[],'Open Orders Empty')
        return (apiResponce.__dict__), 400

       

        

    except Exception as e:
        apiResponce = ApiResponse(False,f"Orders Not Fetched",None,str(e))
        return (apiResponce.__dict__), 500


def get_total_earnings(merchant_stores):
    try:

        earning = 0
        for store in merchant_stores:
            orders = ItemOrder.query.filter_by(store_id=store.id).filter(ItemOrder.order_delivered != None).filter_by(status=1).filter_by(deleted_at=None).all()
            for order in orders:
                earning += order.order_total

        return earning
    except Exception as e:
        return e


def get_merchant_localities(merchant_stores):

    try:
        localities = 0

        if not merchant_stores:
            return 0

        for store in merchant_stores:
            stre = Store.query.filter_by(id=store.id).filter_by(deleted_at=None).first()
            if stre:
                localities += get_count(Locality.query.filter_by(city_id=stre.city_id).filter_by(deleted_at=None))

        return localities
    except Exception as e:
        return e


def get_total_items(merchant_stores):
    try:
        item_count = 0
        for store in merchant_stores:
            total_items = get_count(StoreItem.query.filter_by(store_id=store.id).filter_by(deleted_at=None))
            item_count+=total_items
        return item_count
    except Exception as e:
        return e

def get_delivered_orders(merchant_stores):

    try:
        delivered_orders = 0
        for store in merchant_stores:
            orders = get_count(ItemOrder.query.filter_by(store_id=store.id).filter(ItemOrder.order_delivered != None).filter_by(deleted_at=None))
            delivered_orders += orders

        return delivered_orders
    except Exception as e:
        return e

def get_supervisor_stats():
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']
        supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(role = user_role).filter_by(deleted_at = None).all()

        cities = []
        for supervisor_city in supervisor_cities:
            cities.append(supervisor_city.city_id)

        stores = Store.query.filter_by(deleted_at=None).filter(Store.city_id.in_(cities)).filter_by(status = 1).all()
        store_id = []
        for store in stores:
            store_id.append(store.id)
        
        orders = ItemOrder.query.filter_by(deleted_at = None).filter(ItemOrder.store_id.in_(store_id)).filter(ItemOrder.order_delivered != None).filter_by(status=1).all()

        earnings = 0
        for order in orders:
            earnings += order.grand_order_total

        total_stores = len(store_id)
        

        localities = get_count(Locality.query.filter_by(deleted_at = None).filter(Locality.city_id.in_(cities)))
        
        delivered = get_count(ItemOrder.query.filter_by(deleted_at = None).filter(ItemOrder.store_id.in_(store_id)).filter_by(status=1).filter(ItemOrder.order_delivered != None))

        response_data = {
            'store_count': total_stores,
            'locality': localities,
            'delivered': delivered,
            'earnings': earnings
        }

        resp = ApiResponse(True, "Data Fetched Successfully", response_data,None)
        return resp.__dict__, 200
    except Exception as e:
        resp = ApiResponse(False, "Data Not Fetched", None, str(e))
        return resp.__dict__, 500

def get_latest_orders_supervisor():
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']
        supervisor_cities = UserCities.query.filter_by(user_id = user_id).filter_by(role = user_role).filter_by(deleted_at = None).all()

        cities = []
        for supervisor_city in supervisor_cities:
            cities.append(supervisor_city.city_id)

        stores = Store.query.filter_by(deleted_at=None).filter(Store.city_id.in_(cities)).filter_by(status = 1).all()
        store_id = []
        for store in stores:
            store_id.append(store.id)
        
        orders = ItemOrder.query.filter_by(deleted_at = None).filter(ItemOrder.store_id.in_(store_id)).filter_by(status=1).order_by(ItemOrder.order_created.desc()).limit(100).all()
        data = []   
        for order in orders:
            data.append({
                'created_at': str(order.created_at),
                'order_id': order.id,
                'user_id': order.user_id,
                'username': User.query.filter_by(id=order.user_id).first().name,
                'store_id': order.store_id,
                'store_name': Store.query.filter_by(id=order.store_id).first().name,
                'status': order.status,
                'order_confirmed': str(order.order_confirmed),
                'order_created': str(order.order_created),
                'order_delivered': str(order.order_delivered),
                'order_paid': str(order.order_paid),
                'ready_to_pack': str(order.ready_to_pack),
                'order_pickedup': str(order.order_pickedup),
                'order_total': str(order.order_total)
            })

        apiResponce = ApiResponse(True,f"Orders Fetched Successfully",data,None)
        return (apiResponce.__dict__), 200
        
        apiResponce = ApiResponse(False,f"No Open Orders found",[],'Open Orders Empty')
        return (apiResponce.__dict__), 400

    except Exception as e:
        apiResponce = ApiResponse(False,f"Orders Not Fetched",None,str(e))
        return (apiResponce.__dict__), 500

def get_distributor_status():
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']

        hubs = Hub.query.filter_by(deleted_at=None).filter_by(distributor_id = user_id).filter_by(status = 1).all()
        hub_id = []
        for hub in hubs:
            hub_id.append(hub.id)

        orders = HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.order_delivered != None).all()

        total_hubs = len(hub_id)
        
        
        not_confirmed_order = get_count(HubOrders.query.filter(HubOrders.order_created != None).filter_by(order_confirmed = None))

        delivered = get_count(HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.order_delivered != None))

        
    
        earnings = 0
        for order in orders:
            earnings += order.grand_order_total

        
        response_data = {
            'hub_count': total_hubs,
            'pending_orders': not_confirmed_order,
            'delivered': delivered,
            'earnings': earnings
        }
        
        resp = ApiResponse(True, "Data Fetched Successfully", response_data,None)
        return resp.__dict__, 200
    except Exception as e:
        resp = ApiResponse(False, "Data Not Fetched", None, str(e))
        return resp.dict, 500

def get_latest_orders_distributor():
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']

        hubs = Hub.query.filter_by(deleted_at=None).filter_by(distributor_id = user_id).filter_by(status = 1).all()
    
        hub_id = []
        for hub in hubs:
            hub_id.append(hub.id)

        
        orders = HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).order_by(HubOrders.order_created.desc()).limit(100).all()
        
        data = []   
        for order in orders:
            hub = Hub.query.filter_by(id=order.hub_id).first()
            data.append({
                'created_at': str(order.created_at),
                'order_id': order.id,
                'merchant_id': order.merchant_id,
                'merchantname': Merchant.query.filter_by(id=order.merchant_id).first().name,
                'hub_slug': hub.slug,
                'hub_name': hub.name,
                'status': order.status,
                'order_confirmed': str(order.order_confirmed) if order.order_confirmed else None ,
                'order_created': str(order.order_created) if order.order_created else None,
                'order_delivered': str(order.order_delivered) if order.order_delivered else None,
                'assigned_to_da': str(order.assigned_to_da) if order.assigned_to_da else None,
                'order_pickedup': str(order.order_pickedup) if order.order_pickedup else None,
                'order_total': order.order_total
            })

        apiResponce = ApiResponse(True,f"Orders Fetched Successfully",data,None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False,f"Orders Not Fetched",None,str(e))
        return (apiResponce.__dict__), 500



def get_da_status():
    """
    Returns the following data as status for the logged in delivery associate:

        hub_count | assigned_orders | picked_up_orders | delivered_orders

    Return type: __dict__, int
    """
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']

        
        if not user_role == 'delivery_associate':
            resp = ApiResponse(False, "User is not authorized to view this information", None, "User does not have the correct permissions to view this content")
            return resp.dict, 400

        
        hubs = HubDA.query.filter_by(deleted_at=None).filter_by(delivery_associate_id = user_id).filter_by(status = 1).all()
        hub_id = []
        for hub in hubs:
            hub_id.append(hub.hub_id)

        total_hubs = len(hub_id)

        delivered = get_count(HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.order_delivered != None))


        assigned_orders = get_count(HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.assigned_to_da != None).filter_by(order_delivered=None))

        picked_up_orders = get_count(HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.assigned_to_da != None))

        response_data = {
                'hub_count': total_hubs,
                'assigned_orders': assigned_orders,
                'delivered': delivered,
                'active_orders': picked_up_orders
            }

        resp = ApiResponse(True, "Data Fetched Successfully", response_data,None)
        return resp.__dict__, 200
    
    except Exception as e:
        resp = ApiResponse(False, "Data Not Fetched", None, str(e))
        return resp.dict, 500


def get_latest_orders_da():
    """
    Returns the latest orders the delivery associate has

    Return type: __dict__, int
    """
    try:
        response, status = Auth.get_logged_in_user(request)
        user_id = response['data']['id']
        user_role = response['data']['role']

        
        if not user_role == 'delivery_associate':
            resp = ApiResponse(False, "User is not authorized to view this information", None, "User does not have the correct permissions to view this content")
            return resp.dict, 400

        hubs = HubDA.query.filter_by(deleted_at=None).filter_by(delivery_associate_id = user_id).filter_by(status = 1).all()
        hub_id = []
        for hub in hubs:
            hub_id.append(hub.hub_id)

        assigned_orders = HubOrders.query.filter_by(deleted_at = None).filter(HubOrders.hub_id.in_(hub_id)).filter_by(status=1).filter(HubOrders.assigned_to_da != None).filter_by(order_delivered=None).order_by(HubOrders.order_created).all()

        data = []   
        for order in assigned_orders:
            hub = Hub.query.filter_by(id=order.hub_id).first()
            data.append({
                'created_at': str(order.created_at),
                'order_id': order.id,
                'merchantname': Merchant.query.filter_by(id=order.merchant_id).first().name,
                'hub_name': hub.name,
                'status': order.status,
                'order_confirmed': str(order.order_confirmed) if order.order_confirmed else None ,
                'order_created': str(order.order_created) if order.order_created else None,
                'order_delivered': str(order.order_delivered) if order.order_delivered else None,
                'assigned_to_da': str(order.assigned_to_da) if order.assigned_to_da else None,
                'order_pickedup': str(order.order_pickedup) if order.order_pickedup else None,
                'order_total': order.order_total
            })

        apiResponce = ApiResponse(True,f"Orders Fetched Successfully",data,None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        resp = ApiResponse(False, "Data Not Fetched", None, str(e))
        return resp.dict, 500