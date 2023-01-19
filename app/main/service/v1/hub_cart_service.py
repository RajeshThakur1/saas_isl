from flask import request
from app.main.model import distributor

from app.main.model.apiResponse import ApiResponse
from app.main.model.hubOrders import HubOrders
from app.main.model.store import Store
from app.main.model.hubOrderList import HubOrderLists
from app.main.model.storeItems import StoreItem
from app.main.model.storeItemVariable import StoreItemVariable
from app.main.model.hub import Hub
from app.main.model.hubOrders import HubOrders

from app.main.service.v1.auth_helper import Auth
from app.main.service.v1.notification_service import CreateNotification

from app.main.util.v1.database import get_count, save_db

import datetime

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/hub_cart_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")


def wishlist_by_store(data):
    try:
        store_id = data['store_id']

        store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found')

            return error.__dict__, 400
        
        if store.status != 1:
            error = ApiResponse(False, 'Store is Disabled')

            return error.__dict__, 400
        
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400
        
        if data['pagination'] == False:
            hub_cart_orders = HubOrderLists.query.filter_by(store_id=store_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).order_by(HubOrderLists.product_name).order_by(HubOrderLists.created_at).all()

            response_object = []
            for order in hub_cart_orders:

                quantity_unit = order.quantity_unit_

                response_object.append({
                    'hub_order_list_id': order.id,
                    'name': order.product_name,
                    'brand_name': order.product_brand_name,
                    'image': order.product_image,
                    'product_quantity': order.product_quantity,
                    'quantity_unit': quantity_unit.name,
                    'mrp': order.product_mrp,
                    'price': order.product_selling_price,
                    'quantity': order.quantity

                })

            return ApiResponse(True, f'Cart data for store {store.name}', response_object, None).__dict__, 200
        
        else:
            try:
                page = data['page']
            except:
                page = 1
                
            try:
                item_no = data['item_no']
            except:
                item_no = 42
            
            if page < 1 :
                apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
                return apiresponse.__dict__ , 400
            
            hub_cart_orders = HubOrderLists.query.filter_by(store_id=store_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).order_by(HubOrderLists.product_name).order_by(HubOrderLists.created_at).paginate(page, item_no, False)

            response_object = []
            for order in hub_cart_orders.items:
                quantity_unit = order.quantity_unit_

                response_object.append({
                    'hub_order_list_id': order.id,
                    'name': order.product_name,
                    'brand_name': order.product_brand_name,
                    'image': order.product_image,
                    'product_quantity': order.product_quantity,
                    'quantity_unit': quantity_unit.name,
                    'mrp': order.product_mrp,
                    'price': order.product_selling_price,
                    'quantity': order.quantity

                })

                
            return_obj = {
                'page': hub_cart_orders.page,
                'total_pages': hub_cart_orders.pages,
                'has_next_page': hub_cart_orders.has_next,
                'has_prev_page': hub_cart_orders.has_prev,
                'prev_page': hub_cart_orders.prev_num,
                'next_page': hub_cart_orders.next_num,
                'items_per_page': hub_cart_orders.per_page,
                'items_current_page': len(hub_cart_orders.items),
                'total_items': hub_cart_orders.total,
                'items': response_object
            }
                
            return ApiResponse(True, f'Cart data for store {store.name}', return_obj, None).__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500
        
def add_to_wishlist(data):
    try:
        store_id = data['store_id']
        store_item_variable_ids = data['store_item_variable_ids']
        quantity = data['quantity']

        store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).filter_by(status=1).first()

        if not store:
            return ApiResponse(False, 'Store not found', None, 'Store is unavailable or doesn\'t exist').__dict__, 400

        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        for store_item_variable_id in store_item_variable_ids:

            item_variable = StoreItemVariable.query.filter_by(id=store_item_variable_id).filter_by(deleted_at=None).filter_by(status=1).first()

            if not item_variable:
                return ApiResponse(False, f'Item variable not found', None, 'Item_variable is unavailable or doesn\'t exist').__dict__, 400
                

            item = StoreItem.query.filter_by(id=item_variable.store_item_id).filter_by(deleted_at=None).first()

            if not item:
                return ApiResponse(False, f'Item {item_variable.store_item_id} not found', None, 'Item is unavailable or doesn\'t exist').__dict__, 400

            store_item_id = item_variable.store_item_id
            
            product_quantity = item_variable.quantity
            quantity_unit = item_variable.quantity_unit

            product_brand_name = item.brand_name
            product_image = item.image
            product_name = item.name



            store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).filter_by(status=1).first()

            

            existing_item = HubOrderLists.query.filter_by(store_item_variable_id=store_item_variable_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).filter_by(status=1).first()
            
            if not existing_item:
                
                existing_item = HubOrderLists.query.join(HubOrders, HubOrderLists.hub_order_id == HubOrders.id).filter(HubOrders.deleted_at == None).filter(HubOrders.order_created == None).filter(HubOrderLists.store_item_variable_id==store_item_variable_id).filter(HubOrderLists.deleted_at==None).filter(HubOrderLists.status==1).first()
            
            if existing_item:

                existing_item.quantity += quantity
                existing_item.hub_order_id = None
                save_db(existing_item)
                

            else:
                item = HubOrderLists (
                    store_id=store_id,
                    store_item_id=store_item_id,
                    store_item_variable_id=store_item_variable_id,
                    quantity=quantity,
                    status=1,
                    product_name=product_name,
                    product_quantity=product_quantity,
                    product_quantity_unit=quantity_unit,
                    product_brand_name=product_brand_name,
                    product_image=product_image,
                    created_at=datetime.datetime.utcnow(),
                    updated_at=datetime.datetime.utcnow()
                )

                save_db(item)
                

        response = ApiResponse(True, 'Items added to cart successfully', None, None)

        return response.__dict__, 200


        

    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500

def update_item_quantity(data):
    try:
        store_id = data['store_id']
        hub_order_list_id = data['hub_order_list_id']
        quantity = data['quantity']

        store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).filter_by(status=1).first()

        if not store:
            return ApiResponse(False, 'Store not found', None, 'Store is unavailable or doesn\'t exist').__dict__, 400

        
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        existing_item = HubOrderLists.query.filter_by(id=hub_order_list_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).filter_by(status=1).first()

        if existing_item:

            if not quantity < 0:

                existing_item.quantity = quantity
                save_db(existing_item)
                

            elif quantity == 0:
                existing_item.updated_at = datetime.datetime.utcnow()
                existing_item.deleted_at=datetime.datetime.utcnow()
                save_db(existing_item)
                

            else:
                return ApiResponse(False, 'Quantity can\'t be a negative number', None, 'Quantity cannnot be less than 0')

            save_db(existing_item)
            


        else:
            return ApiResponse(False, 'Item not in cart', None, 'Item is not found or deleted').__dict__, 400

        response = ApiResponse(True, 'Item quantity updated successfully', None, None)

        return response.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500

def remove_item_from_wishlist(data):
    try:
        hub_order_list_id = data['hub_order_list_id']
        
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        existing_item = HubOrderLists.query.filter_by(id=hub_order_list_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).filter_by(status=1).first()

        store_id = existing_item.store_id

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        if existing_item:
            if not existing_item.deleted_at == None:
                return ApiResponse(False, 'Item already deleted from cart', None, 'Item is not found or deleted').__dict__, 400

            existing_item.updated_at = datetime.datetime.utcnow()
            existing_item.deleted_at=datetime.datetime.utcnow()
            save_db(existing_item)

        response = ApiResponse(True, 'Item removed successfully', None, None)

        return response.__dict__, 200
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500

def remove_all_item_from_wishlist(data):
    try:
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']
        store_id = data['store_id']
        
        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400
        
        hub_cart_items = HubOrderLists.query.filter_by(store_id=store_id).filter_by(hub_order_id=None).filter_by(deleted_at=None).all()
        
        for hub_cart_item in hub_cart_items:
            
            hub_cart_item.deleted_at = datetime.datetime.utcnow()
            
            save_db(hub_cart_item)
        
        response = ApiResponse(True, 'All Items removed successfully', None, None)

        return response.__dict__, 200
        
    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500
    
def hubs_by_store_id(data):
    try:
        store_id = data['store_id']

        store = Store.query.filter_by(id=store_id).filter_by(deleted_at=None).filter_by(status=1).first()

        if not store:
            return ApiResponse(False, 'Store not found', None, 'Store is unavailable or doesn\'t exist').__dict__, 400

        
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        hubs = Hub.query.filter_by(city_id=store.city_id).filter_by(deleted_at=None).all()

        data_ret = []
        if hubs:
            for hub in hubs:
                data_ret.append({
                    'hub_slug': hub.slug,
                    'name': hub.name,
                    'city': hub.city.name,
                    'status': hub.status,
                    'image': hub.image
                })

            return ApiResponse(True, 'List of hubs near you', data_ret, None).__dict__, 200

        else:
            return ApiResponse(False, 'No hubs found near your location', None, 'No matching hubs are found').__dict__, 400
    except Exception as e:
        return ApiResponse(False, 'Something went wrong', None, str(e)).__dict__, 500

def create_hub_cart(data):
    try:

        hub_slug = data['hub_slug']
        store_id = data['store_id']

        hub  = Hub.query.filter_by(slug=hub_slug).filter_by(deleted_at=None).filter_by(status=1).first()

        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        store = Store.query.filter_by(id=store_id).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400

        if store.deleted_at != None:
            error = ApiResponse(False, 'Store was Deleted', None,
                                None)
            return (error.__dict__), 400

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(
                merchant_id=resp['data']['id']).filter_by(deleted_at=None)
            if not store_merchant:
                error = ApiResponse(False, 'Merchant Has No Access', None,
                                    None)
                return (error.__dict__), 403
        
        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        existing_cart = HubOrders.query.filter_by(hub_id=hub.id).filter_by(order_created = None).filter_by(deleted_at=None).filter_by(store_id=store_id).first()

        if existing_cart:
            data_ret = {
                'cart_id': existing_cart.id
            }
            return ApiResponse(False, 'Cart already exists', data_ret, 'Only 1 cart allowed per store and hub').__dict__, 400

        active_cart_count = get_count(HubOrders.query.filter_by(order_created = None).filter_by(deleted_at=None).filter_by(store_id=store_id))
        
        if active_cart_count > 3:
            return ApiResponse(False, 'Only 3 Carts can be active at a time').__dict__, 400
        
        new_cart  = HubOrders(
            merchant_id = resp['data']['id'],
            hub_id = hub.id,
            store_id = store_id,
            status = 1,
            created_at = datetime.datetime.utcnow()
        )

        save_db(new_cart)
        
        data_ret={
            'cart_id': new_cart.id
        }

        return ApiResponse(True, 'Cart created successfully', data_ret, None).__dict__, 200

    except Exception as e:
        return ApiResponse(False, 'Something went wrong', None, str(e)).__dict__, 500

def remove_hub_cart(data):
    try:   
        cart_id = data['hub_cart_id']

        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        cart = HubOrders.query.filter_by(id=cart_id).filter_by(deleted_at=None).filter_by(status=1).first()
        if not cart:
            return ApiResponse(False, 'Cart does not exist', None, 'No cart is created yet').__dict__, 400

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=cart.store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400
        
        order_list = HubOrderLists.query.filter_by(hub_order_id=cart_id).filter_by(deleted_at=None).filter_by(status=1).all()

        for order in order_list:
            order.hub_order_id=None

            save_db(order, 'Hub Order List')

        cart.deleted_at = datetime.datetime.utcnow()

        save_db(cart)

        return ApiResponse(True, 'Cart Removed Successfully', None, None).__dict__, 200

    except Exception as e:
        return ApiResponse(False, 'Server Error', None, 'Something went wrong').__dict__, 500

def get_hub_cart(data):
    try:   
        cart_id = data['hub_cart_id']

        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        cart = HubOrders.query.filter_by(id=cart_id).filter_by(deleted_at=None).filter_by(status=1).first()
        if not cart:
            return ApiResponse(False, 'Cart does not exist', None, 'No cart is created yet').__dict__, 400

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=cart.store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400
        
        order_list = HubOrderLists.query.filter_by(hub_order_id=cart_id).filter_by(deleted_at=None).filter_by(status=1).order_by(HubOrderLists.product_name).order_by(HubOrderLists.created_at).all()

        response_object=[]
        for order in order_list:
            
            quantity_unit = order.quantity_unit_
            
            response_object.append({
                'hub_order_list_id': order.id,
                'name': order.product_name,
                'brand_name': order.product_brand_name,
                'image': order.product_image,
                'product_quantity': order.product_quantity,
                'quantity_unit': quantity_unit.name,
                'mrp': order.product_mrp,
                'price': order.product_selling_price,   
                'quantity' : order.quantity
            })
            
        return ApiResponse(True, 'Cart Fetched Successfully', response_object, None).__dict__, 200

    except Exception as e:
        return ApiResponse(False, 'Server Error', None, 'Something went wrong').__dict__, 500

def reset_hub_cart(data):
    try:   
        cart_id = data['hub_cart_id']

        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        cart = HubOrders.query.filter_by(id=cart_id).filter_by(deleted_at=None).filter_by(status=1).first()
        if not cart:
            return ApiResponse(False, 'Cart does not exist', None, 'No cart is created yet').__dict__, 400

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=cart.store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400
        
        order_list = HubOrderLists.query.filter_by(hub_order_id=cart_id).filter_by(deleted_at=None).filter_by(status=1).all()

        for order in order_list:
            order.hub_order_id=None

            save_db(order, 'Hub Order List')

        return ApiResponse(True, 'Cart Cleared Successfully', None, None).__dict__, 200


    except Exception as e:
        return ApiResponse(False, 'Server Error', None, 'Something went wrong').__dict__, 500
       
def move_to_cart(data):
    try:
        cart_id = data['hub_cart_id']
        hub_order_list_ids = data['hub_order_list_ids']
        
        resp, status = Auth.get_logged_in_user(request)

        role = resp['data']['role']

        if cart_id != 0:
            cart = HubOrders.query.filter_by(id=cart_id).filter_by(deleted_at=None).filter_by(status=1).first()
            if not cart:
                return ApiResponse(False, 'Cart does not exist', None, 'No cart is created yet').__dict__, 400
            
            store = Store.query.filter_by(id=cart.store_id).filter_by(status=1).first()

            if not store:
                error = ApiResponse(False, 'Store Not Found', None,
                                    None)
                return (error.__dict__), 400

            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None,
                                    None)
                return (error.__dict__), 400
            
            if role == 'merchant':
                store_merchant = Store.query.filter_by(id=store.id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

                if not store_merchant:

                    error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                    return error.__dict__, 400
        
            else:
                error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

                return error.__dict__, 400

            for orders in hub_order_list_ids:

                order_list = HubOrderLists.query.filter_by(id=orders).filter_by(deleted_at=None).filter_by(status=1).filter_by(store_id = cart.store_id).first()

                if not order_list:
                    continue

                order_list.hub_order_id = cart_id
                order_list.updated_at = datetime.datetime.utcnow()
                save_db(order_list)
            

            return ApiResponse(True, 'Items Moved Successfully', None, None).__dict__, 200

        else:
            cart_id = None
            
            try :
                store_id = data['store_id']
            
            except:
                return ApiResponse(False, 'Store id not provided', None, None).__dict__, 400

            
            
            store = Store.query.filter_by(id=store_id).filter_by(status=1).first()

            if not store:
                error = ApiResponse(False, 'Store Not Found', None,
                                    None)
                return (error.__dict__), 400

            if store.deleted_at != None:
                error = ApiResponse(False, 'Store was Deleted', None,
                                    None)
                return (error.__dict__), 400
            
            if role == 'merchant':
                store_merchant = Store.query.filter_by(id=store.id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

                if not store_merchant:

                    error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                    return error.__dict__, 400
        
            else:
                error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

                return error.__dict__, 400
            
            for orders in hub_order_list_ids:

                order_list = HubOrderLists.query.filter_by(id=orders).filter_by(deleted_at=None).filter_by(status=1).filter_by(store_id = store_id).first()

                if not order_list:
                    continue

                order_list.hub_order_id = cart_id
                order_list.updated_at = datetime.datetime.utcnow()
                save_db(order_list)
        
        
    except Exception as e:
        return ApiResponse(False, 'Something went wrong', None, str(e)).__dict__, 500

def fetch_store_hub_carts(data):
    try:
        store_id = data['store_id']
        resp, status = Auth.get_logged_in_user(request)
        merchant_id = resp['data']['id']
        role = resp['data']['role']

        store = Store.query.filter_by(id=store_id).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400

        if store.deleted_at != None:
            error = ApiResponse(False, 'Store was Deleted', None,
                                None)
            return (error.__dict__), 400
        
        if store.status != 1:
            error = ApiResponse(False, 'Store is Disable', None,
                                None)
            return (error.__dict__), 400
            

        # try:
        #     page = data['page']
        # except:
        #     page = 1
            
        # try:
        #     item_no = data['item_no']
        # except:
        #     item_no = 20
                
        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=store_id).filter_by(
                merchant_id=merchant_id).filter_by(deleted_at=None)
            if not store_merchant:
                error = ApiResponse(False, 'Merchant Has No Access', None,
                                    None)
                return (error.__dict__), 403
        
        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        carts = HubOrders.query.filter_by(store_id = store_id).filter_by(order_created = None).filter_by(deleted_at = None).all()

        cart_data = []
        for cart in carts:
            items = HubOrderLists.query.filter_by(hub_order_id = cart.id).filter_by(deleted_at = None).order_by(HubOrderLists.product_name).order_by(HubOrderLists.created_at).all()
            item_object = []
            for item in items:
                quantity_unit = item.quantity_unit_

                item_object.append({
                    'hub_order_list_id': item.id,
                    'name': item.product_name,
                    'brand_name': item.product_brand_name,
                    'image': item.product_image,
                    'product_quantity': item.product_quantity,
                    'quantity_unit': quantity_unit.name,
                    'mrp': item.product_mrp,
                    'price': item.product_selling_price,
                    'quantity': item.quantity

                })

            hub = cart.hub
            cart_object = {
                'cart_id' : cart.id,
                'hub_name': hub.name,
                'hub_city_name': hub.city.name,
                # 'page': items.page,
                # 'total_pages': items.pages,
                # 'has_next_page': items.has_next,
                # 'has_prev_page': items.has_prev,
                # 'prev_page': items.prev_num,
                # 'next_page': items.next_num,
                # 'items_per_page': items.per_page,
                # 'items_current_page': len(items.items),
                # 'total_items': items.total,
                'items': item_object,
            }

            cart_data.append(cart_object)

        apiResponce = ApiResponse(True, 'Cart Details Fetced', cart_data,
                                  None)
        return (apiResponce.__dict__), 200

    
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def place_store_hub_order(data):
    try:
        cart_id = data['cart_id']
        resp, status = Auth.get_logged_in_user(request)
        merchant_id = resp['data']['id']
        role = resp['data']['role']
        cart = HubOrders.query.filter_by(id = cart_id).filter_by(deleted_at = None).first()

        if not cart:
            error = ApiResponse(False, 'Cart Not Found', None,
                                None)
            return (error.__dict__), 400

        if cart.merchant_id != merchant_id:
            error = ApiResponse(False, 'User Access Denined', None,
                                None)
            return (error.__dict__), 403

        store = Store.query.filter_by(id=cart.store_id).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400

        if store.deleted_at != None:
            error = ApiResponse(False, 'Store was Deleted', None,
                                None)
            return (error.__dict__), 400

        if role == 'merchant':
            store_merchant = Store.query.filter_by(id=cart.store_id).filter_by(merchant_id=resp['data']['id']).filter_by(deleted_at=None).first()

            if not store_merchant:

                error = ApiResponse(False, 'Unauthorized Access', None, 'Merchant does not have access to the specified store')

                return error.__dict__, 400

        else:
            error = ApiResponse(False, 'Unauthorized Access', None, 'User does not have access to the specified store')

            return error.__dict__, 400

        hub = cart.hub
        
        current_time = datetime.datetime.utcnow()
        cart.order_created = current_time
        cart.payment_status = 0
        cart.updated_at = current_time

        items = HubOrderLists.query.filter_by(hub_order_id = cart.id).filter_by(deleted_at = None).all()
        if not items:
            error = ApiResponse(False, 'Cart is Empty add an item first')
            return error.__dict__, 400
        
        
        # for item in items: 
        #     store_item = item.store_item
        #     store_item_variable = item.store_item_variable
        #     item.product_quantity = store_item_variable.quantity
        #     item.product_quantity_unit = store_item_variable.quantity_unit
        #     item.product_name = store_item.name
        #     item.product_brand_name = store_item.brand_name
        #     item.product_image = store_item.image
        #     save_db(item)
            

        save_db(cart)
        

        #Notification
        merchant = cart.merchant
        hub = cart.hub
        distributor = hub.distributor
        #merchant
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_place_merchant',
            'order_id': str(cart.id),
            'store_name' : store.name    
                
        }
        CreateNotification.gen_notification_v2(merchant, notification_data)
        
        #distributor
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_place_distributor',
            'order_id': str(cart.id),
            'store_name' : store.name    
                
        }
        CreateNotification.gen_notification_v2(distributor, notification_data)
        
        apiResponce = ApiResponse(True, 'Order Placed Successfully', None,
                                  None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500
