from app.main.model.storeMenuCategory import StoreMenuCategory
from sqlalchemy import or_
from app.main.model.userCities import UserCities
import json
import os
import uuid
import pandas
import openpyxl
from flask.json import jsonify
from app.main import config
from app.main.model.progress import Progress
from app.main.service.v1.image_service import image_save, image_upload
from flask.helpers import stream_with_context
from app.main.model.quantityUnit import QuantityUnit
from app.main.util.v1.database import get_count, save_db
import datetime
from logging import error
from app.main import db
from app.main.model import menuCategory
from app.main.model.storeItems import StoreItem
from app.main.model.store import Store
from app.main.model.city import City
from app.main.model.itemOrders import ItemOrder
from app.main.model.itemOrderLists import ItemOrderLists

from app.main.model.menuCategory import MenuCategory
from app.main.model.storeItemVariable import StoreItemVariable
from sqlalchemy import text, engine
from flask import request, url_for
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.model.menuCategory import MenuCategory
from app.main.model.store import Store
from app.main.config import ENDPOINT_PREFIX, UPLOAD_FOLDER, item_icon_dir
import csv
from sqlalchemy import func
from sqlalchemy.orm import query, sessionmaker

from app.main.util.v1.dateutil import if_time, store_open_status

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/store_item_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_store_item(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        if (data['selling_price'] > data['mrp']):
            error = ApiResponse(
                False, 'Selling Price Can Not Be Greater Than MRP', None,
                None)
            return (error.__dict__), 400

        store = Store.query.filter_by(
            id=data['store_id']).filter_by(deleted_at=None).first()

        quantity = QuantityUnit.query.filter_by(
            id=data['quantity_unit']).filter_by(deleted_at=None).first()

        if not quantity:
            apiResponce = ApiResponse(
                False, 'Error Occurd',
                None, 'Given Qunantity Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if not store:
            apiResponce = ApiResponse(
                False, 'Error Occurd',
                None, 'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        menucategory = MenuCategory.query.filter_by(
            id=data['menu_category_id']).filter_by(deleted_at=None).first()

        if not menucategory:
            apiResponce = ApiResponse(
                False, 'Error Occurd',
                None, 'Given Menu Category Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        else:
            # get existing store item
            existing_store_item = check_existing_store_item(
                data['store_id'], data['name'], data['brand_name'])

            # if data['image'] == "default":
            #     data['image'] = item_icon_dir +  "default.png"
            if data['image'] == "default":
                data['image'] = item_icon_dir + "default.png"

            else:
                image_file, status = image_upload(
                    data['image'], item_icon_dir, data['name'])

                if status == 400:
                    return image_file, status

                data['image'] = image_file

            # if the store item with name,brand_name & store_id does not exist
            if not len(existing_store_item):
                print("store_item not exists")
                # create store item entry
                new_store_item_add = StoreItem(
                    store_id=data['store_id'],
                    menu_category_id=data['menu_category_id'],
                    name=data['name'],
                    brand_name=data['brand_name'],
                    image=data['image'],
                    packaged='0',
                    status='1',
                    created_at=datetime.datetime.utcnow())

                # Database Transaction Function
                save_db(new_store_item_add, "StoreItem")
                
                # db.session.add(new_store_item_add)
                # db.session.commit()

                # getting store item id
                store_item_id = new_store_item_add.id

                # create store item variable entry
                new_store_item_variable = StoreItemVariable(
                    store_item_id=store_item_id,
                    quantity=data['quantity'],
                    quantity_unit=data['quantity_unit'],
                    mrp=data['mrp'],
                    selling_price=data['selling_price'],
                    created_at=datetime.datetime.utcnow(),
                    stock=data['stock'])

                # Database Transaction Function
                save_db(new_store_item_variable, "StoreItemVariable")
                
                # db.session.add(new_store_item_variable)
                # db.session.commit()

                response_object = {
                    'store_item_id': new_store_item_add.id,
                    'store_id': new_store_item_add.store_id,
                    'name': new_store_item_add.name,
                    'brand_name': new_store_item_add.brand_name,
                    'image': new_store_item_add.image,
                    'store_item_variable_id': new_store_item_variable.id,
                    'id': new_store_item_variable.id,
                    'store_item_id': new_store_item_variable.store_item_id,
                    'quantity': new_store_item_variable.quantity,
                    'quantity_unit': new_store_item_variable.quantity_unit,
                    'mrp': new_store_item_variable.mrp,
                    'selling_price': new_store_item_variable.selling_price,
                    'stock': new_store_item_variable.stock
                }

                apiResponce = ApiResponse(
                    True, 'Store item created Successfully.',
                    response_object, None)
                return (apiResponce.__dict__), 200

            # if the store item exists
            else:
                print("store_item exists")
                # existing store item id
                exist_store_item_id = existing_store_item[0]['id']

                # get existing item variable wrt store_id,quantity,quantity_unit
                existing_store_item_variable = check_existing_store_item_variable(
                    exist_store_item_id, data['quantity'],
                    data['quantity_unit'])
                print("exist_store_item_id exists", exist_store_item_id)

                # item variable does not exist
                if not len(existing_store_item_variable):
                    print("store_item_variable not exists")

                    # create store item variable entry
                    new_store_item_variable = StoreItemVariable(
                        store_item_id=exist_store_item_id,
                        quantity=data['quantity'],
                        quantity_unit=data['quantity_unit'],
                        mrp=data['mrp'],
                        selling_price=data['selling_price'],
                        created_at=datetime.datetime.utcnow(),
                        stock=data['stock'])

                    # Database Transaction Function
                    save_db(new_store_item_variable, "StoreItemVariable")
                    
                    # db.session.add(new_store_item_variable)
                    # db.session.commit()

                    response_object = {
                        'store_item_id': exist_store_item_id,
                        'store_item_variable_id':
                        new_store_item_variable.id,
                        'id': new_store_item_variable.id,
                        'store_item_id':
                        new_store_item_variable.store_item_id,
                        'quantity': new_store_item_variable.quantity,
                        'quantity_unit':
                        new_store_item_variable.quantity_unit,
                        'mrp': new_store_item_variable.mrp,
                        'selling_price':
                        new_store_item_variable.selling_price,
                        'stock': new_store_item_variable.stock
                    }

                    apiResponce = ApiResponse(
                        True,
                        'Store item variant is created Successfully.',
                        response_object, None)
                    return (apiResponce.__dict__), 200

                # item variable exists
                else:
                    error = ApiResponse(
                        False, 'Store item variant Already Exists', None,
                        None)
                    return (error.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to create', None,
                            str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500

def update_store_item(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        menucategory = MenuCategory.query.filter_by(
            id=data['menu_category_id']).filter_by(deleted_at=None).first()

        if not menucategory:
            apiResponce = ApiResponse(
                False, 'Error Occurd',
                None, 'Given Menu Category Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        else:
            # get existing store item
            store_item = StoreItem.query.filter_by(id = data['store_item_id']).first()

            if not store_item:
                apiResponce = ApiResponse(
                False, 'Store Item Not Found',
                None, 'Given Store Item Id is Wrong')
                return (apiResponce.__dict__), 400
            
            if store_item.deleted_at != None:
                apiResponce = ApiResponse(
                False, 'Store Item Deleted',
                None, 'Given Store Item is Deleted')
                return (apiResponce.__dict__), 400

            store_merchant = Store.query.filter_by(id = store_item.store_id).filter_by(deleted_at = None).first()

            if store_merchant.merchant_id != user['id']:
                apiResponce = ApiResponse(
                False, 'User has No access to Update this Item',
                None)
                return (apiResponce.__dict__), 403
            
            # if data['image'] == "default":
            #     data['image'] = item_icon_dir + "default.png"
            
            # elif data['image'] == store_item.image:
            #     pass
            # else:
            #     image_file, status = image_upload(
            #         data['image'], item_icon_dir, data['name'])

            #     if status == 400:
            #         return image_file, status

            #     data['image'] = image_file

            # if the store item with name,brand_name & store_id does not exist
            
        
            store_item.menu_category_id=data['menu_category_id']
            store_item.name=data['name'],
            store_item.brand_name=data['brand_name'],
            store_item.image=data['image'],
            store_item.updated_at=datetime.datetime.utcnow()

            # Database Transaction Function
            save_db(store_item, "StoreItem")
            
                

            apiResponce = ApiResponse(
                True, 'Store item updated Successfully.',
                None, None)
            return (apiResponce.__dict__), 200


    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to update', None,
                            str(e))
        return (error.__dict__), 500

def update_store_item_image(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        store_item = StoreItem.query.filter_by(id = data['store_item_id']).first()

        if not store_item:
            apiResponce = ApiResponse(
            False, 'Store Item Not Found',
            None, 'Given Store Item Id is Wrong')
            return (apiResponce.__dict__), 400
        
        if store_item.deleted_at != None:
            apiResponce = ApiResponse(
            False, 'Store Item Deleted',
            None, 'Given Store Item is Deleted')
            return (apiResponce.__dict__), 400

        store_merchant = Store.query.filter_by(id = store_item.store_id).filter_by(deleted_at = None).first()

        if store_merchant.merchant_id != user['id']:
            apiResponce = ApiResponse(
            False, 'User has No access to Update this Item',
            None)
            return (apiResponce.__dict__), 403
        
        image, status = image_save(request, item_icon_dir)
        
        if status != 200:
            return image, status
        
        url, status = image_upload(image['data']['image'], item_icon_dir, store_item.name)
        
        if status != 200:
            return image, status
        
        store_item.image = url
        store_item.updated_at = datetime.datetime.utcnow()
        save_db(store_item)
        
        return ApiResponse(True, "Store Item Image Updated successfully"), 200
    
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to update', None,
                            str(e))
        return (error.__dict__), 500

def fetch_store_items_by_id1(data):
    # user, status = Auth.get_logged_in_user(request)
    # #
    # # store = Store.query.filter_by(name=data['store_id']).first()
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        # store items array fetch

        store = Store.query.filter_by(
            id=data['store_id']).filter_by(deleted_at=None).first()

        try:
            page_no = int(data['page'])
        except:
            page_no = 1
        try:
            item_per_page = int(data['item_per_page'])
        except:
            item_per_page = 10

        try:
            search = data['search']
        except Exception as e:
            search = None

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)

        merchant_id = resp['data']['id']
        stock = -1
        menu_categories = None

        if resp['data']['role'] == 'merchant':

            merchant_store = Store.query.filter_by(
                id=data['store_id']).filter_by(deleted_at=None).first()
            if not merchant_store.merchant_id == merchant_id:
                error = ApiResponse(
                    False, 'Merchant does not have access to this store', None, 'Unauthorized Merchant')
                return error.__dict__, 401

        if len(data['stock']) > 2:
            error = ApiResponse(
                False, 'Only 2 Parameter needed in Stock', None)
            return error.__dict__, 400

        try:
            minimum = data['stock'][0]
        except:
            minimum = None

        try:
            maximum = data['stock'][1]

            if minimum > maximum:
                error = ApiResponse(
                    False, 'Minimum Stock Value cannot be Greater Than Maximum Stock Value', None)
                return error.__dict__, 400

        except:
            maximum = None

        if len(data['menu_categories']) > 0:
            menu_categories = data['menu_categories']

        items = None
        if store:
            menu_category_ids = []
            if menu_categories:
                for cat in menu_categories:
                    menucat = MenuCategory.query.filter_by(
                        id=cat).filter_by(deleted_at=None).first()
                    if not menucat:
                        error = ApiResponse(
                            False, f'Wrong Menucategory ID {cat}', None)
                        return error.__dict__, 400

                    menu_category_ids.append(cat)

                if not search or len(search) < 2:
                    items = StoreItem.query.filter_by(store_id=data['store_id']).filter_by(deleted_at=None).filter(
                        StoreItem.menu_category_id.in_(menu_category_ids)).order_by(StoreItem.status.desc()).order_by(func.lower(StoreItem.name)).paginate(page_no, item_per_page, False)
                else:
                    items = StoreItem.query.filter_by(store_id=data['store_id']).filter(or_(func.lower(StoreItem.name).like(func.lower(
                        search)), func.lower(StoreItem.brand_name).like(func.lower(search)))).filter_by(deleted_at=None).filter(
                        StoreItem.menu_category_id.in_(menu_category_ids)).order_by(StoreItem.status.desc()).order_by(func.lower(StoreItem.name)).paginate(page_no, item_per_page, False)
            else:
                if not search or len(search) < 2:
                    items = StoreItem.query.filter_by(store_id=data['store_id']).filter_by(deleted_at=None).order_by(StoreItem.status.desc()).order_by(func.lower(StoreItem.name)).paginate(page_no, item_per_page, False)
                else:
                    items = StoreItem.query.filter_by(store_id=data['store_id']).filter(or_(func.lower(StoreItem.name).like(func.lower(
                        search)), func.lower(StoreItem.brand_name).like(func.lower(search)))).filter_by(deleted_at=None).order_by(StoreItem.status.desc()).order_by(func.lower(StoreItem.name)).paginate(page_no, item_per_page, False)

            if not items:
                error = ApiResponse(
                    False, 'No items found for this store', None, 'No items found')
                return error.__dict__, 400

            resp_data = []
            for item in items.items:

                if maximum == None and minimum == None:
                    variables = StoreItemVariable.query.filter_by(store_item_id=item.id).filter_by(
                        deleted_at=None).order_by(StoreItemVariable.created_at).all()
                elif maximum == None:
                    variables = StoreItemVariable.query.filter_by(store_item_id=item.id).filter_by(
                        deleted_at=None).filter(StoreItemVariable.stock >= minimum).order_by(StoreItemVariable.created_at).all()
                else:
                    variables = StoreItemVariable.query.filter_by(store_item_id=item.id).filter_by(deleted_at=None).filter(
                        StoreItemVariable.stock >= minimum).filter(StoreItemVariable.stock <= maximum).order_by(StoreItemVariable.created_at).all()

                menu_category = MenuCategory.query.filter_by(
                    id=item.menu_category_id).filter_by(deleted_at=None).first()
                item_variables = []

                for variable in variables:
                    # if stock:
                    #     if variable.stock > stock:
                    #         continue
                    item_variables.append({
                        'id': variable.id,
                        'quantity': variable.quantity,
                        'quantity_name': QuantityUnit.query.filter_by(id=variable.quantity_unit).filter_by(deleted_at=None).first().name,
                        'mrp': variable.mrp,
                        'quantity_unit': variable.quantity_unit,
                        'selling_price': variable.selling_price,
                        'status': variable.status,
                        'stock': variable.stock
                    })

                if not len(item_variables) == 0:
                    resp_data.append({
                        'store_item_id': item.id,
                        'store_id': item.store_id,
                        'menu_category_id': item.menu_category_id,
                        'menu_category_name': menu_category.name,
                        'item_name': item.name,
                        'item_brand_name': item.brand_name,
                        'image': item.image,
                        'store_item_status': item.status,
                        'item_variable': item_variables,
                    })

            role = str(resp['data']['role']).capitalize().replace('_', '')

            return_obj = {
                'page': items.page,
                'total_pages': items.pages,
                'has_next_page': items.has_next,
                'has_prev_page': items.has_prev,
                'prev_page': items.prev_num,
                'next_page': items.next_num,
                'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store Item_show_stores', page=items.prev_num) if items.has_prev else None,
                'next_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store Item_show_stores', page=items.next_num) if items.has_next else None,
                'current_page_url': ENDPOINT_PREFIX + url_for(f'api.{role} Store Item_show_stores', page=page_no),
                'items_per_page': items.per_page,
                'items_current_page': len(resp_data),
                'total_items': items.total,
                'items': resp_data
            }

            apiResponce = ApiResponse(
                True, 'Store item fetched Successfully.', return_obj, None)
            return (apiResponce.__dict__), 200

            # sql = text(
            #     'select store_item.id as store_item_id, store_item.store_id, \
            #     store_item.menu_category_id, store_item.name as item_name, \
            #     store_item.brand_name as item_brand_name, store_item.image,\
            #     store_item.status as store_item_status from store_item \
            #     where store_id = :store_id and store_item.status = 1 \
            #     and store_item.deleted_at IS NULL')
            # item_result = db.engine.execute(sql, {
            #     'store_id': data['store_id'],
            # })
            # store_item_details = []

            # if item_result:
            #     for row in item_result:

            #         menucategory = MenuCategory.query.filter_by(id = row[2]).first()
            #         # fetching store item variable data
            #         item_variable = set_item_variable_data(row[0])
            #         recordObject = {
            #             'store_item_id': row[0],
            #             'store_id': row[1],
            #             'menu_category_id': row[2],
            #             'menu_category_name': menucategory.name,
            #             'item_name': row[3],
            #             'item_brand_name': row[4],
            #             'image': row[5],
            #             'stock': row[6],
            #             'store_item_status': row[7],
            #             'item_variable': item_variable,
            #         }
            #         store_item_details.append(recordObject)
        else:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, "Given Store id is wrong or deleted")
            return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def fetch_store_items(data):
    # user = Auth.get_logged_in_user(request)
    # (user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')
    try:
        store = Store.query.filter_by(
            slug=data['store_slug']).filter_by(deleted_at=None).first()
        # if (data['store_slug']):
        if store:
            # store items array fetch
            sql = text(
                'select store_item.id as store_item_id, store_item.store_id, \
                store_item.menu_category_id, store_item.name as item_name, \
                store_item.brand_name as item_brand_name, store_item.image,\
                store_item.status as store_item_status from store_item \
                where store_id = :store_id and store_item.status = 1 \
                and store_item.deleted_at IS NULL')
            item_result = db.engine.execute(sql, {
                'store_id': store.id,
            })
            store_item_details = []

            for row in item_result:

                menu_category_id = row[2]
                store_id = row[1]

                mapping = StoreMenuCategory.query.filter_by(store_id=store_id).filter_by(
                    menu_category_id=menu_category_id).filter_by(deleted_at=None).first()

                if not mapping:
                    continue

                # fetching store item variable data
                item_variable = set_item_variable_data(row[0])
                recordObject = {
                    'store_item_id': row[0],
                    'store_id': row[1],
                    'menu_category_id': row[2],
                    'item_name': row[3],
                    'item_brand_name': row[4],
                    'image': row[5],
                    'store_item_status': row[6],
                    'item_variable': item_variable,
                }
                store_item_details.append(recordObject)

            if len(store_item_details) == 0:
                error = ApiResponse(
                    False, 'Store Items can\'t be Fetched', None, 'No Record Found')
                return error.__dict__, 400

            apiResponce = ApiResponse(True, 'Store item fetched Successfully.',
                                      store_item_details, None)
            return (apiResponce.__dict__), 200
        else:
            #error = ApiResponse(False, 'User is not Authorized', None, None)
            error = ApiResponse(False, 'Store Not Found', None, None)
            return (error.__dict__), 500
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500


def fetch_top_items(data):
    try:
        store_slug = data['store_slug']
        check_date = datetime.datetime.utcnow()-datetime.timedelta(days=180)
        store = Store.query.filter_by(slug=store_slug).filter_by(deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Not Fetched', None, 'Store Not Found')
            return error.__dict__, 400

        top = ItemOrder.query.filter_by(store_id=store.id).filter_by(deleted_at=None).filter(ItemOrder.order_created>=check_date).all()

        if not top:
            error = ApiResponse(False, 'Not Fetched', None, 'No orders found for the store')
            return error.__dict__, 400

        result={}
        store_item_ids=[]
        for items in top:
            top1 = ItemOrderLists.query.filter_by(item_order_id=items.id).filter_by(deleted_at=None).all()

            for item in top1:

                if item.store_item_id in store_item_ids:
                    result[str(item.store_item_id)]+=item.quantity
                    
                else:
                    result[str(item.store_item_id)]=item.quantity
                    store_item_ids.append(item.store_item_id)
                


        sorted_values = sorted(result.values(), reverse=True)
        sorted_dict = {}
        
        sorted_values = sorted_values[0:20]


        for i in sorted_values:
            for k in result.keys():
                if result[k] == i:
                    sorted_dict[k] = result[k]
                    break
        
        return_data =[]
        for k in sorted_dict.keys():
            store_item_id = int(k)

            item = StoreItem.query.filter_by(id=store_item_id).filter_by(deleted_at=None).filter_by(status=1).first()

            if not item:
                continue

            store_menu_cats = StoreMenuCategory.query.filter_by(store_id=store.id).filter_by(deleted_at=None).filter_by(menu_category_id=item.menu_category_id).filter_by(status=1).first()

            if not store_menu_cats:
                continue

            item_variable = set_item_variable_data(store_item_id)

            data_return = {
                "store_item_id": store_item_id,
                "store_id": store.id,
                "menu_category_id": item.menu_category_id,
                "item_name": item.name,
                "item_brand_name": item.brand_name,
                "image": item.image,
                "store_item_status": item.status,
                "item_variable": item_variable
            }
            return_data.append(data_return)

        resp = ApiResponse(True, 'Fetched', return_data, None)
        return resp.__dict__, 200
    except Exception as e:
        resp = ApiResponse(False, 'Not Fetched', None, str(e))
        return resp.__dict__, 500




def update_store_item_variable(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        
        if (data['selling_price'] > data['mrp']):
            error = ApiResponse(
                False, 'Selling Price Can Not Be Greater Than MRP', None,
                None)
            return (error.__dict__), 400
        else:
            store_item = StoreItem.query.filter_by(
                id=data['store_item_id']).filter_by(deleted_at=None).first()
            if not store_item:
                apiResponce = ApiResponse(
                    False, 'Error Occurred', None, "Given Store Item id is wrong or deleted")
                return (apiResponce.__dict__), 400

            if user['role'] == 'merchant':
                store = Store.query.filter_by(merchant_id = user['id']).filter_by(id = store_item.store_id).first()

                if not store:
                    apiResponce = ApiResponse(
                    False, 'Merchant has no access to this Store', None)
                    return (apiResponce.__dict__), 400

            quantity = QuantityUnit.query.filter_by(
                id=data['quantity_unit']).filter_by(deleted_at=None).first()
            if not quantity:
                apiResponce = ApiResponse(
                    False, 'Error Occurd',
                    None, 'Given Qunantity Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

            stock = data['stock']
            if stock < 0:
                error = ApiResponse(False, 'Stock of Item Variable Can\'t be less than zero',
                                    None, 'Stock should be a positive integer.')
                return error.__dict__, 400

            else:
                store_item_variable = StoreItemVariable.query.filter(
                    StoreItemVariable.id == data['store_item_variable_id'],
                    StoreItemVariable.deleted_at == None).first()

                # if the store item variable exists
                if store_item_variable:

                    # get existing store item
                    existing_store_item_variable_update = check_store_item_variable_update(
                        data['store_item_variable_id'], data['store_item_id'],
                        data['quantity'], data['quantity_unit'])

                    if not len(existing_store_item_variable_update):
                        store_item_variable.store_item_id = data[
                            'store_item_id']
                        store_item_variable.quantity = data['quantity']
                        store_item_variable.quantity_unit = data[
                            'quantity_unit']
                        store_item_variable.mrp = data['mrp']
                        store_item_variable.selling_price = data[
                            'selling_price']
                        store_item_variable.status = data['status']
                        store_item_variable.updated_at = datetime.datetime.utcnow()
                        store_item_variable.stock = data['stock']

                        try:
                            db.session.add(store_item_variable)
                            db.session.commit()
                            apiResponce = ApiResponse(
                                True, 'Store Item variable Successfully Updated.',
                                None, None)
                            return (apiResponce.__dict__), 200

                        except Exception as e:
                            db.session.rollback()
                            apiResponce = ApiResponse(
                                False, 'Error Occurred', None, f"StoreItemVariable Database error: {str(e)}")
                            return (apiResponce.__dict__), 500

                    else:
                        apiResponce = ApiResponse(
                            False, 'Same store item variable exists.', None,
                            None)
                        return (apiResponce.__dict__), 409

                else:
                    apiResponce = ApiResponse(False, 'Store Item Variable does not exists.',
                                              None, 'Given Item variable Id is Wrong or Deleted')
                    return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500




def update_store_item_status(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        
        store_item = StoreItem.query.filter_by(
            id=data['store_item_id']).filter_by(deleted_at=None).first()
        if not store_item:
            apiResponce = ApiResponse(
                False, 'Error Occurred', None, "Given Store Item id is wrong or deleted")
            return (apiResponce.__dict__), 400

        else:

            resp, status = Auth.get_logged_in_user(request)

            merchant_id = resp['data']['id']

            if resp['data']['role'] == 'merchant':

                merchant_store = Store.query.filter_by(
                    id=store_item.store_id).filter_by(deleted_at=None).first()
                if not merchant_store.merchant_id == merchant_id:
                    error = ApiResponse(
                        False, 'Merchant does not have access to this store', None, 'Unauthorized Merchant')
                    return error.__dict__, 401


            store_item.status = data['status']
            store_item.updated_at = datetime.datetime.utcnow()

            try:
                db.session.add(store_item)
                db.session.commit()
                apiResponce = ApiResponse(
                    True, 'Store Item status Successfully Updated.',
                    None, None)
                return (apiResponce.__dict__), 200

            except Exception as e:
                db.session.rollback()
                apiResponce = ApiResponse(
                    False, 'Error Occurred', None, f"StoreItem Database error: {str(e)}")
                return (apiResponce.__dict__), 500

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Update', None,
                            str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_store_item_variable_stock(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:

        stock = data['stock']
        if stock <= 0:
            error = ApiResponse(False, 'Stock of Item Variable Can\'t be zero',
                                None, 'Stock should be a non zero integer.')
            return error.__dict__, 400

        else:
            store_item_variable = StoreItemVariable.query.filter(
                StoreItemVariable.id == data['store_item_variable_id'],
                StoreItemVariable.deleted_at == None).first()

            # if the store item variable exists
            if store_item_variable:

                # get existing store item

                store_item_variable.stock += data['stock']

                try:
                    db.session.add(store_item_variable)
                    db.session.commit()
                    apiResponce = ApiResponse(
                        True, 'Store Item variable Successfully Updated.',
                        None, None)
                    return (apiResponce.__dict__), 200

                except Exception as e:
                    db.session.rollback()
                    apiResponce = ApiResponse(
                        False, 'Error Occurred', None, f"StoreItemVariable Database error: {str(e)}")
                    return (apiResponce.__dict__), 500

            else:
                apiResponce = ApiResponse(False, 'Store Item Variable does not exists.',
                                          None, 'Given Item variable Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_store_item_variable_stock(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:

        stock = data['stock']
        if stock <= 0:
            error = ApiResponse(False, 'Stock of Item Variable Can\'t be zero',
                                None, 'Stock should be a non zero integer.')
            return error.__dict__, 400

        else:
            store_item_variable = StoreItemVariable.query.filter(
                StoreItemVariable.id == data['store_item_variable_id'],
                StoreItemVariable.deleted_at == None).first()

            # if the store item variable exists
            if store_item_variable:

                # get existing store item

                store_item_variable.stock += data['stock']

                try:
                    db.session.add(store_item_variable)
                    db.session.commit()
                    apiResponce = ApiResponse(
                        True, 'Store Item variable Successfully Updated.',
                        None, None)
                    return (apiResponce.__dict__), 200

                except Exception as e:
                    db.session.rollback()
                    apiResponce = ApiResponse(
                        False, 'Error Occurred', None, f"StoreItemVariable Database error: {str(e)}")
                    return (apiResponce.__dict__), 500

            else:
                apiResponce = ApiResponse(False, 'Store Item Variable does not exists.',
                                          None, 'Given Item variable Id is Wrong or Deleted')
                return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500








def delete_store_item_variable(data):
    # user, status = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):

    try:
        store_item = StoreItem.query.filter_by(
            id=data['store_item_id']).filter_by(deleted_at=None).first()

        if not store_item:
            apiResponce = ApiResponse(
                False, 'Error Occurred', None, "Store Item id is wrong or deleted")
            return (apiResponce.__dict__), 400

        store_item_variable = StoreItemVariable.query.filter(
            StoreItemVariable.id == data['store_item_variable_id'],
            StoreItemVariable.deleted_at == None).first()

        if not store_item_variable:
            apiResponce = ApiResponse(
                False, 'Error Occurred', None, "Store item variable id is wrong or deleted")
            return (apiResponce.__dict__), 400

        # get existing store item
        existing_store_item_variable_delete = check_store_item_variable_delete(
            data['store_item_id'])

        # the item has more than one variable
        if (len(existing_store_item_variable_delete) != 1):

            store_item_variable.deleted_at = datetime.datetime.utcnow()

            try:

                db.session.add(store_item_variable)
                db.session.commit()
                apiResponce = ApiResponse(
                    True, 'Store Item Variable Successfully Deleted.', None, None)
                return (apiResponce.__dict__), 200

            except Exception as e:

                db.session.rollback()
                apiResponce = ApiResponse(
                    False, 'Error Occurred', None, f"Locality Database error: {str(e)}")
                return (apiResponce.__dict__), 500

        # the item has only one variable
        else:
            store_item_variable = StoreItemVariable.query.filter(
                StoreItemVariable.id == data['store_item_variable_id'],
                StoreItemVariable.deleted_at == None).first()
            # db.session.delete(store_item_variable)

            store_item_variable.deleted_at = datetime.datetime.utcnow()

            store_item = StoreItem.query.filter(
                StoreItem.id == data['store_item_id'],
                StoreItem.deleted_at == None).first()

            store_item.deleted_at = datetime.datetime.utcnow()

            # db.session.add(store_item_variable)
            # db.session.commit()

            save_db(store_item_variable, "Store Item Variable")
            
            save_db(store_item, "Store Item")
            

            apiResponce = ApiResponse(
                True, 'Store Item Variable Successfully Deleted.', None, None)
            return (apiResponce.__dict__), 200

    except Exception as e:
        apiResponce = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (apiResponce.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def check_existing_store_item(store_id, name, brand_name):
    try:

        sql = text('select * from store_item where store_id = :store_id \
            and name like :name and brand_name like :brand_name\
            and store_item.deleted_at IS NULL')

        result = db.engine.execute(sql, {
            'store_id': store_id,
            'name': name,
            'brand_name': brand_name,
        })
        exist_store_item = []

        for row in result:

            recordObject = {
                'id': row[0],
                'store_id': row[1],
                'menu_category_id': row[2],
                'name': row[3],
                'brand_name': row[4],
                'image': row[5],
                'packaged': row[6],
                'status': row[7],
                'created_at': str(row[8]),
                'updated_at': str(row[9]),
                'deleted_at': str(row[10]),
            }
            exist_store_item.append(recordObject)

        return exist_store_item
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500


def check_existing_store_item_variable(store_item_id, quantity, quantity_unit):
    try:
        sql = text(
            'select * from store_item_variable where store_item_id =:store_item_id\
            and quantity = :quantity and quantity_unit = :quantity_unit\
            and store_item_variable.deleted_at IS NULL')

        result = db.engine.execute(
            sql, {
                'store_item_id': store_item_id,
                'quantity': quantity,
                'quantity_unit': quantity_unit,
            })
        exist_store_item_variable = []

        for row in result:

            recordObject = {
                'id': row[0],
                'store_item_id': row[1],
                'quantity': row[2],
                'quantity_unit': row[3],
                'mrp': row[4],
                'selling_price': row[5],
                'status': row[6],
                'created_at': str(row[7]),
                'updated_at': str(row[8]),
            }
            exist_store_item_variable.append(recordObject)

        return exist_store_item_variable
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500


def check_store_item_variable_update(store_item_variable_id, store_item_id,
                                     quantity, quantity_unit):
    try:
        sql = text(
            'select * from store_item_variable where store_item_id =:store_item_id\
            and quantity = :quantity and quantity_unit = :quantity_unit\
            and id != :store_item_variable_id\
            and store_item_variable.deleted_at IS NULL')

        result = db.engine.execute(
            sql, {
                'store_item_variable_id': store_item_variable_id,
                'store_item_id': store_item_id,
                'quantity': quantity,
                'quantity_unit': quantity_unit,
            })
        exist_store_item_variable_update = []

        for row in result:

            recordObject = {
                'id': row[0],
                'store_item_id': row[1],
                'quantity': row[2],
                'quantity_unit': row[3],
                'mrp': row[4],
                'selling_price': row[5],
                'status': row[6],
                'created_at': str(row[7]),
                'updated_at': str(row[8]),
            }
            exist_store_item_variable_update.append(recordObject)

        return exist_store_item_variable_update
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500


def check_store_item_variable_delete(store_item_id):
    try:

        sql = text(
            'select * from store_item_variable where store_item_id =:store_item_id\
            and store_item_variable.deleted_at IS NULL')

        result = db.engine.execute(sql, {
            'store_item_id': store_item_id,
        })
        exist_store_item_variable_delete = []

        for row in result:

            recordObject = {
                'id': row[0],
                'store_item_id': row[1],
                'quantity': row[2],
                'quantity_unit': row[3],
                'mrp': row[4],
                'selling_price': row[5],
                'status': row[6],
                'created_at': str(row[7]),
                'updated_at': str(row[8]),
            }
            exist_store_item_variable_delete.append(recordObject)

        return exist_store_item_variable_delete

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500


def front_fetch_store_items_by_menu_cat(data):
    try:
        store_id = Store.query.filter_by(slug=data['store_slug']).first()
        if not store_id:
            error = ApiResponse(False, f"Store not able to fetch with store sludge {data['store_slug']}", None,
                                None)
            return (error.__dict__), 400
        menu_id = MenuCategory.query.filter_by(
            slug=data['menu_slug']).filter_by(status=1).first()
        if not menu_id:
            if not store_id:
                error = ApiResponse(False, f"Menu category not able to fetch with menu sludge {data['menu_slug']}", None,
                                    None)
                return (error.__dict__), 400
        records = StoreItem.query.filter_by(store_id=store_id.id).filter_by(menu_category_id=menu_id.id).filter_by(
            deleted_at=None).join(MenuCategory, MenuCategory.id == StoreItem.menu_category_id)

        sql = text(
            'select store_item.id as store_item_id, store_item.store_id, \
            menu_categories.name as menu_category_name, store_item.name as item_name, \
            store_item.brand_name as item_brand_name, store_item.image,\
            store_item.status from store_item \
            join menu_categories on menu_categories.id = store_item.menu_category_id\
            where store_id = :store_id and menu_category_id= :menu_category_id\
            and store_item.status = 1 and store_item.deleted_at IS NULL ')

        result = db.engine.execute(
            sql, {
                'store_id': store_id.id,
                'menu_category_id': menu_id.id,
            })
        store_item_details = []

        for row in result:

            item_variable = set_item_variable_data(row[0])
            recordObject = {
                'store_item_id': row[0],
                'store_id': row[1],
                'menu_category_name': row[2],
                'item_name': row[3],
                'item_brand_name': row[4],
                'image': row[5],
                'status': row[6],
                'item_variable': item_variable
            }
            store_item_details.append(recordObject)

        apiResponce = ApiResponse(True, 'Store item fetched Successfully.',
                                  store_item_details, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500


def front_fetch_store_items_by_menu_cat_pagination(data):
    try:
        store_id = Store.query.filter_by(slug=data['store_slug']).filter_by(deleted_at = None).first()
        if not store_id:
            error = ApiResponse(False, f"Store not able to fetch with store sludge {data['store_slug']}", None,
                                None)
            return (error.__dict__), 400
        menu_id = MenuCategory.query.filter_by(
            slug=data['menu_slug']).filter_by(status=1).filter_by(deleted_at = None).first()
        if not menu_id:
            error = ApiResponse(False, f"Menu category not able to fetch with menu sludge {data['menu_slug']}",
                                None,
                                None)
            return (error.__dict__), 400

        try:
            page_no = int(data['page'])

        except:
            page_no = 1

        try:
            item_per_page = int(data['item_per_page'])
        except:
            item_per_page = 10
        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        # Session = sessionmaker(bind=engine)
        # session = Session()
        # for s, m in session.query(StoreItem, MenuCategory).filter(StoreItem.menu_category_id == MenuCategory.id).all():
        #     print("ID: {} Name: {} Invoice No: {} Amount: {}".format(s.id, s.name, m.id, m.name))
        records = StoreItem.query.filter_by(store_id=store_id.id).filter_by(
            menu_category_id=menu_id.id).filter_by(deleted_at=None).filter_by(status = 1).paginate(page_no, item_per_page, False)
        # .join(MenuCategory, MenuCategory.id == StoreItem.menu_category_id).paginate(page_no, item_per_page, False)

        if not records.items:
            error = ApiResponse(False, "no items found",
                                None,
                                None)
            return (error.__dict__), 400
        # sql = text(
        #     'select store_item.id as store_item_id, store_item.store_id, \
        #     menu_categories.name as menu_category_name, store_item.name as item_name, \
        #     store_item.brand_name as item_brand_name, store_item.image,\
        #     store_item.status from store_item \
        #     join menu_categories on menu_categories.id = store_item.menu_category_id\
        #     where store_id = :store_id and menu_category_id= :menu_category_id\
        #     and store_item.status = 1 and store_item.deleted_at IS NULL ')
        #
        # result = db.engine.execute(
        #     sql, {
        #         'store_id': store_id.id,
        #         'menu_category_id': menu_id.id,
        #     })
        store_item_details = []

        for row in records.items:
            item_variable = set_item_variable_data(row.id)
            menu_cat = MenuCategory.query.filter_by(
                id=row.menu_category_id).first()
            recordObject = {
                'store_item_id': row.id,
                'store_id': row.store_id,
                'menu_category_name': menu_cat.name,
                'item_name': row.name,
                'item_brand_name': row.brand_name,
                'image': row.image,
                'status': row.status,
                'item_variable': item_variable
            }
            store_item_details.append(recordObject)

            return_obj = {
                'page': records.page,
                'total_pages': records.pages,
                'has_next_page': records.has_next,
                'has_prev_page': records.has_prev,
                'prev_page': records.prev_num,
                'next_page': records.next_num,
                'prev_page_url': None,
                'next_page_url': None,
                'current_page_url': None,
                'items_per_page': records.per_page,
                'items_current_page': len(store_item_details),
                'total_items': records.total,
                'items': store_item_details
            }

        apiResponce = ApiResponse(True, 'Store item fetched Successfully.',
                                  return_obj, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500


def set_item_variable_data(data):
    print("test_rajesh")
    try:
        sql = text('select store_item_variable.id, store_item_variable.quantity,\
            quantity_unit.name as quantity_name,store_item_variable.mrp,\
            store_item_variable.selling_price,store_item_variable.status,\
            store_item_variable.stock from store_item_variable \
            join quantity_unit on quantity_unit.id = store_item_variable.quantity_unit\
            where store_item_variable.store_item_id = :store_item_id and store_item_variable.deleted_at IS NULL'
                   )
        item_variable_result = db.engine.execute(sql, {
            'store_item_id': data,
        })

        item_array = []

        for row2 in item_variable_result:
            recordObject = {
                'id': row2[0],
                'quantity': row2[1],
                'quantity_name': row2[2],
                'mrp': row2[3],
                'selling_price': row2[4],
                'status': row2[5],
                'stock': row2[6]
            }
            item_array.append(recordObject)

        return item_array
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return error.__dict__, 500


def get_item_count_by_id(data):
    try:
        store_id = data['store_id']
        resp, status = Auth.get_logged_in_user(request)
        merchant_id = resp['data']['id']

        if resp['data']['role'] == "merchant":
            store = Store.query.filter_by(
                id=store_id).filter_by(deleted_at=None).first()

            if not store.merchant_id == merchant_id:
                error = ApiResponse(
                    True, 'Merchant does not have access to this store', None, 'Unauthorized Merchant.')
                return error.__dict__, 401

        item_count = get_count(StoreItem.query.filter_by(store_id=store_id).filter_by(
            status=1).filter_by(deleted_at=None))

        response = ApiResponse(
            True, 'Item Count Successfully Fetched', item_count, None)
        return response.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Something went wrong', None, str(e))
        return error.__dict__, 500


def globelSearch_func(data):
    try:
        # print("hellokfwibf")
        searchString = data['search_string']
        # print(searchString,"<<<jubv")
        # city_id=City.query.filter_by(id=data['city_id'])
        # tag = request.form["tag"]
        search = "%{}%".format(searchString)
        # print(search,"<<<=====")
        city_name = data['city_name']

        city_id = City.query.filter(func.lower(City.name) == func.lower(
            city_name)).filter_by(status = 1).filter_by(deleted_at=None).first()

        page = 1
        items_per_page = 10
        try:
            page = int(data['page'])
        except Exception as e:
            pass

        try:
            items_per_page = int(data['items'])
        except Exception as e:
            pass
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if not city_id:
            error = ApiResponse(False, 'We do not serve this city', None,
                                None)
            return (error.__dict__), 400

        city_id = city_id.id

        stores = Store.query.filter(func.lower(Store.name).like(func.lower(
            search))).filter_by(city_id=city_id).filter_by(deleted_at=None).filter_by(status=1).paginate(page, items_per_page, False)

        recordObject = []
        for record in stores.items:

            response = {
                'id': record.id,
                'name': record.name,
                'slug': record.slug,
                'owner_name': record.owner_name,
                'shopkeeper_name': record.shopkeeper_name,
                'image': record.image,
                'address_line_1': record.address_line_1,
                'address_line_2': record.address_line_2,
                'store_latitude': record.store_latitude,
                'store_longitude': record.store_longitude,
                'pay_later': record.pay_later,
                'delivery_mode': record.delivery_mode,
                'open_status': store_open_status(record),
                'delivery_start_time': if_time(record.delivery_start_time),
                'delivery_end_time': if_time(record.delivery_end_time),
                'radius': record.radius,
                'status': record.status,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        items = StoreItem.query.filter(or_(func.lower(StoreItem.name).like(func.lower(
            search)), func.lower(StoreItem.brand_name).like(func.lower(
                search)))).filter_by(status = 1).filter_by(deleted_at=None).paginate(page, items_per_page, False)

        recordObject1 = []
        for record1 in items.items:

            store = Store.query.filter_by(
                id=record1.store_id).filter_by(deleted_at=None).filter_by(status=1).first()

            if not store or not store.city_id == city_id:
                continue

            item_variable = StoreItemVariable.query.filter_by(
                store_item_id=record1.id).filter_by(deleted_at=None).all()

            vars = []
            for item in item_variable:
                quantity = QuantityUnit.query.filter_by(
                    id=item.quantity_unit).first()
                obj = {
                    'id': item.id,
                    'quantity': item.quantity,
                    'store_item_id': item.store_item_id,
                    'quantity_unit': quantity.name,
                    'mrp': item.mrp,
                    'selling_price': item.selling_price,
                    'status': item.status,
                    'stock': item.stock,
                    'created_at': str(item.created_at),
                    'updated_at': str(item.updated_at)
                }
                vars.append(obj)

            response1 = {
                'id': record1.id,
                'name': record1.name,
                'store_id': record1.store_id,
                'menu_category_id': record1.menu_category_id,
                'brand_name': record1.brand_name,
                'image': record1.image,
                'packaged': record1.packaged,
                'status': record1.status,
                'created_at': str(record1.created_at),
                'updated_at': str(record1.updated_at),
                'item_variable': vars
            }
            recordObject1.append(response1)

        return_obj = {
            'type': "Items",
            'page': items.page,
            'total_pages': items.pages,
            'has_next_page': items.has_next,
            'has_prev_page': items.has_prev,
            'prev_page': items.prev_num,
            'next_page': items.next_num,
            'items_per_page': items.per_page,
            'items_current_page': len(items.items),
            'total_items': items.total,
            'items': recordObject1
        }

        return_obj1 = {
            'type': "Stores",
            'page': stores.page,
            'total_pages': stores.pages,
            'has_next_page': stores.has_next,
            'has_prev_page': stores.has_prev,
            'prev_page': stores.prev_num,
            'next_page': stores.next_num,
            'stores_per_page': stores.per_page,
            'stores_current_page': len(stores.items),
            'total_stores': stores.total,
            'stores': recordObject
        }
        dict1 = {
            'search_store_item': return_obj,
            'search_store_data': return_obj1

        }

        apiResponce = ApiResponse(True, 'List of search Stores', dict1,
                                  None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500


def fetch_store_items_by_id(id2):
    #
    # store = Store.query.filter_by(name=data['store_id']).first()
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        # store items array fetch
        sql = text(
            'select store_item.id as store_item_id, store_item.store_id, \
                store_item.menu_category_id, store_item.name as item_name, \
                store_item.brand_name as item_brand_name, store_item.image,\
                store_item.status as store_item_status from store_item \
                where store_id = :store_id and store_item.status = 1 \
                and store_item.deleted_at IS NULL')
        item_result = db.engine.execute(sql, {
            'store_id': id2,
        })
        store_item_details = []

        for row in item_result:

            # fetching store item variable data
            item_variable = set_item_variable_data(row[0])
            recordObject = {
                'store_item_id': row[0],
                'store_id': row[1],
                'menu_category_id': row[2],
                'item_name': row[3],
                'item_brand_name': row[4],
                'image': row[5],
                'store_item_status': row[6],
                'item_variable': item_variable,
            }
            store_item_details.append(recordObject)
        return store_item_details
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500


def update_progress(success, skipped, total, uid, status, user_id, store_id):
    try:

        # Create Progress if it does not exist
        progress = Progress.query.filter_by(
            uid=str(uid)).filter_by(deleted_at=None).first()

        if not progress:
            progress = Progress(
                uid=uid,
                user_id=user_id,
                store_id=store_id,
                success=success,
                skipped=skipped,
                total=total,
                status=status,
                created_at=datetime.datetime.utcnow()
            )
        else:
            progress.success = success
            progress.skipped = skipped
            progress.total = total
            progress.status = status
            progress.updated_at = datetime.datetime.utcnow()

            if status == 1:
                progress.deleted_at = datetime.datetime.utcnow()

        save_db(progress, 'Progress')
        
    except Exception as e:
        print(f'Progress update Error: {str(e)}')


def import_object(data, uid, user_id, store_id, user_role):
    success = 0
    skipped = 0
    total = len(data['name'])
    try:
        ret_dat = []
        for i in range(len(data['name'])):

            if not data['name'][str(i)] or not data['menu_category'][str(i)] or not data['brand_name'][str(i)] or not data['quantity'][str(i)] or not data['quantity_unit'][str(i)] or not data['mrp'][str(i)] or not data['selling_price'][str(i)] or not data['stock'][str(i)]:
                skipped += 1
                update_progress(success, skipped, total,
                                uid, 0, user_id, store_id)
                continue
            data_db = {
                'store_id': store_id,
                'menu_category_id': MenuCategory.query.filter(func.lower(MenuCategory.name) == func.lower(data['menu_category'][str(i)])).filter_by(deleted_at=None).first().id,
                'name': data['name'][str(i)],
                'brand_name': data['brand_name'][str(i)],
                'image': 'default',
                'quantity': data['quantity'][str(i)],
                'quantity_unit': QuantityUnit.query.filter(func.lower(QuantityUnit.short_name) == func.lower(data['quantity_unit'][str(i)])).filter_by(deleted_at=None).first().id if QuantityUnit.query.filter(func.lower(QuantityUnit.short_name) == func.lower(data['quantity_unit'][str(i)])).filter_by(deleted_at=None).first() else None,
                'mrp': data['mrp'][str(i)],
                'selling_price': data['selling_price'][str(i)],
                'stock': data['stock'][str(i)]
            }
            try:
                dat = create_store_item(data_db)

                if dat[0]['success'] == True:
                    ret_dat.append(dat[0]['data'])
                    success += 1
                else:
                    skipped += 1

                update_progress(success, skipped, total,
                                uid, 0, user_id, store_id)
            except Exception as e:
                skipped += 1
                update_progress(success, skipped, total,
                                uid, 0, user_id, store_id)
                continue
        return ret_dat
    except Exception as e:
        update_progress(success, skipped, total, uid, 10, user_id, store_id)
        return e


def items_by_excel(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        user_role = user['data']['role']
        file = request.files['Excel File']
        uid = uuid.uuid4()
        store_id = data['store_id']
        progress = Progress(
            uid=uid,
            user_id=user_id,
            store_id=store_id,
            success=0,
            skipped=0,
            total=0,
            status=0,
            created_at=datetime.datetime.utcnow()
        )
        save_db(progress, 'Progress')
        

        if user_role in ['merchant']:
            store_merchant = Store.query.filter_by(
                id=data['store_id']).filter_by(deleted_at=None).first()
            if not user_id == store_merchant.merchant_id:
                error = ApiResponse(
                    False, 'Merchant does not have access to this store', None, 'Unauthorized Merchant')
                return error.__dict__, 401

        file_name = os.path.join(
            UPLOAD_FOLDER, f"store_items_{user_role}_{user_id}_{str(datetime.date.today())}")

        xlsx_file_name = file_name+".xlsx"
        file.save(xlsx_file_name)
        xlsx = openpyxl.load_workbook(xlsx_file_name)
        sheet = xlsx.active
        data = sheet.rows

        csv_filename = file_name + ".csv"
        # csv = open(f"{csv_filename}", "w+")
        # for row in data:
        #     l = list(row)
        #     for i in range(len(l)):
        #         if i == len(l) - 1:
        #             csv.write(str(l[i].value))
        #         else:
        #             csv.write(str(l[i].value) + ',')
        #         csv.write('\n')

        # csv.close()
        with open(csv_filename, 'w+', newline="") as f:
            col = csv.writer(f)
            for row in sheet.rows:
                col.writerow([cell.value for cell in row])

        excel_data_df = pandas.read_csv(csv_filename)

        os.remove(csv_filename)
        os.remove(xlsx_file_name)

        json_obj = json.loads(excel_data_df.to_json())

        objects = import_object(json_obj, uid, user_id, store_id, user_role)

        progress = Progress.query.filter_by(
            uid=str(uid)).filter_by(deleted_at=None).first()

        response_data = {
            'uid': str(uid),
            'user_id': user_id,
            'store_id': store_id,
            'success': progress.success,
            'skipped': progress.skipped,
            'total': len(json_obj['name']),
            'status': progress.status,
            'created_at': str(progress.created_at),
            'items_added': objects
        }

        progress.deleted_at = datetime.datetime.utcnow()

        save_db(progress, 'Progress')
        

        if not progress.status == 0 or not progress.status == 10:
            return ApiResponse(True, 'File Import Completed', response_data, None).__dict__, 200

        return ApiResponse(False, 'File Import Failed', response_data, None).__dict__, 400

    except Exception as e:
        return ApiResponse(False, 'File Import Failed', None, str(e)).__dict__, 500


def check_progress(data):
    store_id = data['store_id']
    user_id = data['user_id']

    progress = Progress.query.filter_by(user_id=user_id).filter_by(
        store_id=store_id).filter_by(deleted_at=None).first()

    if not progress:
        error = ApiResponse(False, 'Import Job Not Found',
                            None, 'StoreID or UserID is wrong or deleted')
        return error.__dict__, 400

    response_data = {
        'uid': progress.uid,
        'user_id': user_id,
        'store_id': store_id,
        'success': progress.success,
        'skipped': progress.skipped,
        'total': progress.total,
        'status': progress.status,
        'created_at': progress.created_at
    }

    if not progress.status == 0 or not progress.status == 10:
        return ApiResponse(True, 'File Import Completed', response_data, None).__dict__, 200

    if progress.status == 0:
        return ApiResponse(True, 'File Import Active', response_data, None).__dict__, 200

    return ApiResponse(False, 'File Import Failed', response_data, None).__dict__, 400


def get_max_stock(data):
    try:
        user, status = Auth.get_logged_in_user(request)
        user_id = user['data']['id']
        role = user['data']['role']

        if role == "merchant":
            merchant_stores = Store.query.filter_by(
                id=data['store_id']).filter_by(deleted_at=None).first()

            if merchant_stores.merchant_id != user_id:
                error = ApiResponse(
                    False, 'Unauthorized Merchant', 'null', 'Store id not in Merchant stores.')
                return error.__dict__, 401

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

        store = Store.query.filter_by(
            id=data['store_id']).filter_by(deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Store not found',
                                'null', 'Store id is Wrong or Deleted')
            return (error.__dict__), 400

        storeitems = StoreItem.query.filter_by(
            store_id=store.id).filter_by(deleted_at=None).all()
        storeitem_id = []

        for storeitem in storeitems:
            storeitem_id.append(storeitem.id)

        query = db.session.query(func.max(StoreItemVariable.stock))
        max_stock = query.filter(StoreItemVariable.store_item_id.in_(
            storeitem_id)).filter_by(deleted_at=None).first()

        return_object = {
            'max_stock': max_stock[0]
        }

        return ApiResponse(True, None, return_object, None).__dict__, 200

    except Exception as e:
        return ApiResponse(False, 'Error Occured', None, str(e)).__dict__, 500
