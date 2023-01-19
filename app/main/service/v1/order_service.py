from multiprocessing import Process
from xmlrpc.client import DateTime
from sqlalchemy.sql.elements import Null
from sqlalchemy.sql.sqltypes import String
from app.main.model.hub import Hub
from app.main.model.hubDa import HubDA
from app.main.model.hubOrderList import HubOrderLists
from app.main.model.hubOrderTax import HubOrderTax
from app.main.model.hubOrders import HubOrders
from app.main.model.hubTaxes import HubTaxes
from app.main.model.itemOrderTax import ItemOrderTax
from app.main.model import quantityUnit
from app.main.model.quantityUnit import QuantityUnit
from app.main.model.storeItems import StoreItem
from app.main.model.hubDa import HubDA
import datetime
from itertools import groupby

from werkzeug.datastructures import Authorization

from app.main import db
from app.main.model import admin, apiResponse
from app.main.model.locality import Locality
from sqlalchemy import text
from flask import jsonify
from app.main.model.itemOrders import ItemOrder
from app.main.util.v1.PaymentgatewayHelper import Payment_Util
from app.main.util.v1.database import get_count
from app.main.util.v1.dateutil import if_date
from .notification_service import CreateNotification
from ...model.coupon import Coupon
from ...model.notification import NotificationTemplates
from ...model.session import Session
from ...model.supervisor import Supervisor
from ...model.userAddress import UserAddress
from .store_service import *
from app.main.model.apiResponse import ApiResponse


from app.main.model.itemOrders import ItemOrder
from app.main.model.user import User
from app.main.model.storeItemVariable import StoreItemVariable
from app.main.model.blacklist import BlacklistToken
from app.main.util.v1.orders import calculate_hub_order_total, calculate_order_total
from app.main.model.userCities import UserCities

import datetime
from app.main import db
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import text, cast
from app.main.model.itemOrders import ItemOrder
from app.main.model.itemOrderLists import ItemOrderLists
from flask import request
from app.main.service.v1.auth_helper import Auth
from itertools import groupby
import re
from app.main.util.v1.decorator import *
from app.main import config
# get the Order by user_id
from ...util.v1.decorator import token_required

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/order_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def find_order(data):
    stores = find_store1(data)
    result = []
    for store in stores:
        store.itemOrder = ItemOrder.query.filter_by(store_id=store.id).filter_by(status=1).order_by(ItemOrder.order_created.desc()).limit(
            10).all()
        result.append(store.itemOrder)

    return result, 201


def get_orders():
    resp, status = Auth.get_logged_in_user(request)
    user = resp['data']
    user_id = user['id']
    try:
        sql = text(
            'SELECT item_orders.order_total as order_total,\
            item_orders.slug as slug,\
            item_orders.store_id as store_id,\
            item_orders.coupon_id as coupon_id,\
            item_orders.order_total_discount as order_total_discount,\
            item_orders.final_order_total as final_order_total,\
            item_orders.delivery_fee as delivery_fee,\
            item_orders.grand_order_total as grand_order_total,\
            item_orders.initial_paid as initial_paid,\
            item_orders.order_created as order_created,\
            item_orders.order_confirmed as order_confirmed,\
            item_orders.ready_to_pack as ready_to_pack, \
            item_orders.order_paid as order_paid,\
            item_orders.order_pickedup as order_pickedup,\
            item_orders.order_delivered as order_delivered,\
            item_orders.user_address_id as user_address_id,\
            item_orders.delivery_date as delivery_date, \
            item_orders.delivery_slot_id as delivery_slot_id, \
            item_orders.da_id as da_id, \
            item_orders.status as status,\
            item_orders.merchant_transfer_at as merchant_transfer_at,\
            item_orders.merchant_txnid as merchant_txnid,\
            item_orders.txnid as txnid,\
            item_orders.gateway as gateway,\
            item_orders.transaction_status as transaction_status,\
            item_orders.cancelled_by_id as cancelled_by_id,\
            item_orders.created_at as created_at,\
            item_orders.updated_at as updated_at,\
            item_orders.deleted_at as deleted_at,\
            store.id as id,\
            store.name as name,\
            store.slug as slug,\
            store.owner_name as owner_name,\
            store.shopkeeper_name as shopkeeper_name,\
            store.image as image,\
            store.address_line_1 as address_line_1,\
            store.address_line_2 as address_line_2,\
            store.address_line_2 as address_line_2,\
            store.store_latitude as store_latitude,\
            store.store_longitude as store_longitude,\
            store.pay_later as pay_later,\
            store.delivery_mode as delivery_mode,\
            store.delivery_start_time as delivery_start_time,\
            store.delivery_end_time as delivery_end_time,\
            store.radius as radius,\
            store.status as status,\
            store.created_at as created_at,\
            store.updated_at as updated_at,\
            store.deleted_at as deleted_at,\
            item_orders.id as item_order_id,\
            item_orders.cancelled_by_role as cancelled_by_role\
            FROM item_orders\
            join store on item_orders.store_id = store.id \
            WHERE item_orders.user_id = :user_id and\
            order_created is not Null and item_orders.status = 1\
            ORDER by item_orders.id DESC'

        )
        # 'SELECT item_orders.order_total as order_total, \
        # ')

        print("user_id:-", user_id)

        result = db.engine.execute(
            sql, {
                'user_id': user_id
            })
        order_list = []
        for row in result:
            recordObject = {
                'id': row[49],
                'user_id': user_id,
                'order_total': row[0],
                'slug': str(row[1]),
                'store_id': str(row[2]),
                'coupon_id': str(row[3]),
                'order_total_discount': str(row[4]),
                'final_order_total': str(row[5]),
                'delivery_fee': str(row[6]),
                'grand_order_total': str(row[7]),
                #'initial_paid': str(row[8]),
                'order_created': str(row[9]) if row[9] else None,
                'order_confirmed': str(row[10]) if row[10] else None,
                'ready_to_pack': str(row[11]) if row[11] else None,
                'order_paid': str(row[12]) if row[12] else None,
                'order_pickedup': str(row[13]) if row[13] else None,
                'order_delivered': str(row[14]) if row[14] else None,
                'user_address_id': str(row[15]) ,
                'delivery_date': str(row[16]) if row[16] else None,
                'delivery_slot_id': str(row[17]),
                'da_id': str(row[18]),
                'status': str(row[19]),
                'merchant_transfer_at': str(row[20]),
                'merchant_txnid': str(row[21]),
                'txnid': str(row[22]),
                'gateway': str(row[23]),
                'transaction_status': str(row[24]),
                'cancelled_by': str(row[25]),
                'cancelled_by_role': str(row[50]),
                'created_at': str(row[26]) if row[26] != None else None,
                'updated_at': str(row[27]) if row[27] != None else None,
                'deleted_at': str(row[28]) if row[28] != None else None,
                'store_data': [
                    {
                        'id': str(row[29]),
                        'name': str(row[30]),
                        'slug': str(row[31]),
                        'owner_name': str(row[32]),
                        'shopkeeper_name': str(row[33]),
                        'image': str(row[34]),
                        'address_line_1': str(row[35]),
                        'address_line_2': str(row[36]),
                        'store_latitude': str(row[37]),
                        'store_longitude': str(row[38]),
                        'pay_later': str(row[39]),
                        'delivery_mode': str(row[40]),
                        'delivery_start_time': str(row[41]) if row[41] else None,
                        'delivery_end_time': str(row[42]) if row[42] else None,
                        'radius': str(row[43]),
                        'status': str(row[44]),
                        'created_at': str(row[45]) if row[45] != None else None,
                        'updated_at': str(row[46]) if row[46] != None else None,
                        'deleted_at': str(row[47]) if row[47] != None else None,
                    }
                ]

                # 'order_total': row[1],

            }
            order_list.append(recordObject)

        #
        finalResult = []
        for key, value in groupby(order_list):
            finalResult.append(list(value))
        finalResult_without_array = []
        for i in range(len(finalResult)):
            finalResult_without_array.append(finalResult[i][0])
        apiResponce = ApiResponse(
            True, 'User Cart Data Fetched', finalResult_without_array, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500

def get_orders_pagination(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        logging.info(f"getting the order for user {resp['data']}")
        user_id = user['id']
        page_no = None
        item_per_page = 15
        #item_orders = None

    
        try:
            page_no = int(data['page'])

        except:
            page_no = 1

        # try:
        #     item_per_page = int(data['item_per_page'])
        # except:
        #     item_per_page = 15

        if page_no < 1 :
            logging.info("Page Number Can't be Negetive")
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        

        try:
            search_string = data['search_string']
            logging.info(f"search string :- {data['search_string']}")

            if search_string != None:

                id = search_string
                id = re.search(r"\d+(\.\d+)?", id)

                try:
                    id = int(id.group(0))
                    search_string = id

                except:
                    search_string = None

        except:
            search_string = None


        if search_string:


            #searchString = data['search_string']
            search = f'{search_string}%'
            # search = "%{}%".format(searchString)
            item_orders = ItemOrder.query.filter_by(user_id= user_id).filter(cast(ItemOrder.id,String).like(search)).filter(ItemOrder.order_created != None).order_by(ItemOrder.id.desc()).paginate(page_no, item_per_page, False)
            logging.info(item_orders)
        else:
            item_orders = ItemOrder.query.filter_by(user_id=user_id).filter(ItemOrder.order_created != None).order_by(ItemOrder.id.desc()).paginate(
                page_no, item_per_page, False)
            logging.info(item_orders)
            # if not item_orders.items:
            #     error = ApiResponse(False, 'No order is available', None,
            #                         None)
            #     return (error.__dict__), 400

        # if not item_orders:
        #     item_orders = ItemOrder.query.filter_by(user_id=user_id).filter(ItemOrder.order_created != None).paginate(
        #         page_no, item_per_page, False)
        #     if not item_orders.items:
        #         error = ApiResponse(False, 'No order is available', None,
        #                             None)
        #         return (error.__dict__), 400

        order_list = []
        for item_order in item_orders.items:
            store = Store.query.filter(Store.id== item_order.store_id).filter(Store.deleted_at==None).first()
            logging.info(store)
            recordObject = {
                'id': str(item_order.id),
                'user_id': str(user_id),
                'order_total': str(item_order.order_total),
                'slug': str(item_order.slug),
                'store_id': str(item_order.store_id),
                'coupon_id': str(item_order.coupon_id),
                'order_total_discount': str(item_order.order_total_discount),
                'final_order_total': str(item_order.final_order_total),
                'delivery_fee': str(item_order.delivery_fee),
                'grand_order_total': str(item_order.grand_order_total),
                #'initial_paid': str(item_order.initial_paid),
                'order_created': str(item_order.order_created) if item_order.order_created else None,
                'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                'order_paid': str(item_order.order_paid) if item_order.order_paid else None,
                'order_pickedup': str(item_order.order_pickedup) if item_order.order_pickedup else None,
                'order_delivered': str(item_order.order_delivered) if item_order.order_delivered else None,
                'user_address_id': str(item_order.user_address_id),
                'delivery_date': str(item_order.delivery_date) if item_order.delivery_date else None,
                'delivery_slot_id': str(item_order.delivery_slot_id),
                'da_id': str(item_order.da_id),
                'status': str(item_order.status),
                'merchant_transfer_at': str(item_order.merchant_transfer_at) if item_order.merchant_transfer_at else None,
                'merchant_txnid': str(item_order.merchant_txnid),
                'txnid': str(item_order.txnid),
                'gateway': str(item_order.gateway),
                'transaction_status': str(item_order.transaction_status),
                'cancelled_by': str(item_order.cancelled_by_id),
                'cancelled_by_role':str(item_order.cancelled_by_role),
                'created_at': str(item_order.created_at) if item_order.created_at != None else None,
                'updated_at': str(item_order.updated_at) if item_order.updated_at != None else None,
                'deleted_at': str(item_order.deleted_at) if item_order.deleted_at != None else None,
                'store_data':{
                    'id': store.id,
                    'name': store.name,
                    'slug': store.slug,
                    'owner_name': store.owner_name,
                    'shopkeeper_name': store.shopkeeper_name,
                    'image': store.image,
                    'address_line_1': store.address_line_1,
                    'address_line_2': store.address_line_2,
                    'store_latitude': store.store_latitude,
                    'store_longitude': store.store_longitude,
                    'pay_later': store.pay_later,
                    'delivery_mode': store.delivery_mode,
                    'delivery_start_time': str(store.delivery_start_time) if store.delivery_start_time != None else None,
                    'delivery_end_time': str(store.delivery_end_time) if store.delivery_end_time != None else None,
                    'radius':store.radius,
                    'status':store.status


                }
            }
            order_list.append(recordObject)
        return_obj = {
            'page': item_orders.page,
            'total_pages': item_orders.pages,
            'has_next_page': item_orders.has_next,
            'has_prev_page': item_orders.has_prev,
            'prev_page': item_orders.prev_num,
            'next_page': item_orders.next_num,
            'prev_page_url': None,
            'next_page_url': None,
            'current_page_url': None,
            'items_per_page': item_orders.per_page,
            'items_current_page': len(order_list),
            'total_items': item_orders.total,
            'items': order_list
        }

        logging.info(f"List of All Menu Categories by Store ID:- {return_obj}")
        apiResponce = ApiResponse(True,
                                  'List of All Menu Categories by Store ID',
                                  return_obj, None)

        return (apiResponce.__dict__), 200
    except Exception as e:
        logging.info(f"User Data Can not be fetched:- {str(e)}")
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500

################################# get order by Id writen by Rajesh #####################

def get_orders_by_id_new(data):
    try:

        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        logging.info(f"user_id :- { resp['data']['id']}")
        id = data['order_id']
        logging.info(f"order_id:- {data['order_id']}")
        id = re.search(r"\d+(\.\d+)?", id)

        try:
            id = int(id.group(0))

        except:
            error = ApiResponse(False, "Error Occured", None,
                                "Given Order Id is Wrong")
            return (error.__dict__), 400

        sql = text('SELECT item_orders.id as item_order_id,\
                                item_orders.order_total as order_total,\
                                item_orders.slug as slug,\
                                item_orders.store_id as store_id,\
                                item_orders.coupon_id as coupon_id,\
                                item_orders.order_total_discount as order_total_discount,\
                                item_orders.final_order_total as final_order_total,\
                                item_orders.delivery_fee as delivery_fee,\
                                item_orders.grand_order_total as grand_order_total,\
                                item_orders.initial_paid as initial_paid,\
                                item_orders.order_created as order_created,\
                                item_orders.order_confirmed as order_confirmed,\
                                item_orders.ready_to_pack as ready_to_pack, \
                                item_orders.order_paid as order_paid, \
                                item_orders.order_pickedup as order_pickedup,\
                                item_orders.order_delivered as order_delivered,\
                                item_orders.user_address_id as user_address_id,\
                                item_orders.delivery_date as delivery_date, \
                                item_orders.delivery_slot_id as delivery_slot_id, \
                                item_orders.da_id as da_id, \
                                item_orders.status as status,\
                                item_orders.merchant_transfer_at as merchant_transfer_at,\
                                item_orders.merchant_txnid as merchant_txnid,\
                                item_orders.txnid as txnid,\
                                item_orders.gateway as gateway,\
                                item_orders.transaction_status as transaction_status,\
                                item_orders.cancelled_by_id as cancelled_by,\
                                item_orders.created_at as created_at,\
                                item_orders.updated_at as updated_at,\
                                item_orders.deleted_at as deleted_at,\
                                item_orders.user_id as user_id,\
                                item_order_lists.id as item_order_list_id,\
                                item_order_lists.item_order_id as item_order_id,\
                                item_order_lists.store_item_id as store_item_id,\
                                item_order_lists.store_item_variable_id as store_item_variable_id,\
                                item_order_lists.quantity as quantity,\
                                item_order_lists.product_packaged as product_packaged,\
                                item_order_lists.removed_by as removed_by,\
                                item_order_lists.created_at as created_at,\
                                item_order_lists.updated_at as updated_at,\
                                item_order_lists.deleted_at as deleted_at,\
                                item_order_lists.product_name as product_name,\
                                item_order_lists.product_brand_name as brand_name,\
                                item_order_lists.product_image as image,\
                                item_order_lists.product_mrp as product_mrp,\
                                item_order_lists.product_selling_price as product_selling_price,\
                                item_order_lists.product_quantity as product_quantity,\
                                item_order_lists.product_quantity_unit as product_quantity_unit,\
                                store.id as store_id,\
                                store.name as store_name,\
                                store.slug as store_slug,\
                                store.owner_name as store_owner_name,\
                                store.shopkeeper_name as store_shopkeeper_name,\
                                store.image as store_image,\
                                store.address_line_1 as store_address_line_1,\
                                store.address_line_2 as store_address_line_2,\
                                store.store_latitude as store_latitude,\
                                store.store_longitude as store_longitude,\
                                store.pay_later as pay_later,\
                                store.delivery_mode as delivery_mode,\
                                store.delivery_start_time as delivery_start_time,\
                                store.delivery_end_time as delivery_end_time,\
                                store.radius as radius,\
                                store.status as status,\
                                store.created_at as created_at,\
                                store.updated_at as updated_at,\
                                store.deleted_at as deleted_at,\
                                item_orders.cancelled_by_role as cancelled_by_role\
                                FROM item_orders\
                                join item_order_lists on item_orders.id = item_order_lists.item_order_id\
                                join store_item on item_order_lists.store_item_id = store_item.id\
                                join store_item_variable on item_order_lists.store_item_variable_id = store_item_variable.id\
                                join store on item_orders.store_id = store.id\
                                WHERE item_orders.id = :id\
                                and item_orders.deleted_at IS NULL\
                                and item_order_lists.deleted_at IS NULL and\
                                item_orders.order_created IS not NULL\
                                ORDER by item_orders.id DESC'
                   )
        
        item_orders = ItemOrder.query.filter_by(
            id=id).filter_by(deleted_at=None).first()
        logging.info(item_orders)
        if not item_orders:
            logging.info("Given Order Id is Wrong")
            error = ApiResponse(False, "Error Occured", None,
                                "Given Order Id is Wrong")
            return (error.__dict__), 400

        if item_orders.deleted_at != None:
            logging.info("Order is Deleted")
            error = ApiResponse(False, "Order is Deleted", None,
                                "Given Order Id is Deleted")
            return (error.__dict__), 400

        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=item_orders.id).filter_by(deleted_at=None)
        logging.info(item_order_lists)
        if item_order_lists:
            item_order_lists_object = []
            for item_order_list in item_order_lists:
                data = {
                    "item_order_list_id": item_order_list.id,
                    "item_order_id": item_order_list.item_order_id,
                    "store_item_id": item_order_list.store_item_id,
                    "store_item_variable_id": item_order_list.store_item_variable_id,
                    "quantity": item_order_list.quantity,
                    "product_packaged": item_order_list.product_packaged,
                    "removed_by": item_order_list.removed_by,
                    "created_at": str(item_order_list.created_at) if item_order_list.created_at != None else None,
                    "updated_at": str(item_order_list.updated_at) if item_order_list.updated_at != None else None,
                    "deleted_at": str(item_order_list.deleted_at) if item_order_list.deleted_at != None else None,
                    "product_name": item_order_list.product_name,
                    "product_brand_name": item_order_list.product_brand_name,
                    "product_image": item_order_list.product_image,
                    "product_mrp": item_order_list.product_mrp,
                    "product_selling_price": item_order_list.product_selling_price,
                    "product_quantity": item_order_list.product_quantity,
                    "product_quantity_unit": item_order_list.product_quantity_unit
                }
                item_order_lists_object.append(data)

        store = Store.query.filter_by(
            id=item_orders.store_id).filter_by(deleted_at=None).first()
        logging.info(store)
        user_addres = UserAddress.query.filter_by(
            id=item_orders.user_address_id).first()
        logging.info(user_addres)
        if not user_addres:
            logging.info("Order is Not Valid")
            error = ApiResponse(False, "Order is Not Valid", None,
                                "No address found for the order")
            return (error.__dict__), 400

        coupon = Coupon.query.filter_by(id=item_orders.coupon_id).first()
        logging.info(coupon)
        # if coupon is not applied
        if not coupon:
            coupon_code = ""
            coupon_desc = ""
        else:
            coupon_code = coupon.code
            coupon_desc = coupon.description
        result = db.engine.execute(sql, {'id': id})

        fetchCartDetails = []
        empty_dict = {}

        # for row in result:
        #     store_id = row[3]
        #     break
        taxes = StoreTaxes.query.filter_by(
            store_id=store.id).filter_by(deleted_at=None).all()
        logging.info(taxes)
        tax_object = []

        for tax in taxes:

            item_order_tax = ItemOrderTax.query.filter_by(
                item_order_id=id).filter_by(tax_id=tax.id).first()

            if not item_order_tax:
                continue

            if item_order_tax.tax_type == 1:
                taxtype = "Percentage"
            else:
                taxtype = "Flat"

            tax_data = {
                'tax_id': item_order_tax.id,
                'tax_name': item_order_tax.tax_name,
                'tax_type': taxtype,
                'amount': item_order_tax.amount,
                'calculated': item_order_tax.calculated,
            }

            tax_object.append(tax_data)

        tax_details = {
            'total_tax': item_orders.total_tax,
            'tax_details': tax_object
        }


        for row in result:
            # print(row)
            store_item_variable_new = StoreItemVariable.query.filter_by(id=row[34]).filter_by(deleted_at=None).first()
            logging.info(store_item_variable_new)
            quantity_unit = QuantityUnit.query.filter_by(id=store_item_variable_new.quantity_unit).filter_by(deleted_at=None).first()
            if row[0] in list(empty_dict.keys()):
                # for i in range(len(fetchCartDetails)):

                if fetchCartDetails[0]['cart_id'] == row[0]:
                    fetchCartDetails[0]['item_order_list_data'].append({
                        "item_order_lists_id": row[31],  # store_item.id
                        'item_order_id': row[32],
                        'store_item_id': row[33],
                        'store_item_variable_id': row[34],
                        'quantity': row[35],
                        'product_packaged': row[36],
                        'removed_by': row[37],
                        # 'store_id': row[2],
                        "created_at": str(row[38]) if row[38] != None else None,
                        "updated_at": str(row[39]) if row[39] != None else None,
                        "deleted_at": str(row[40]) if row[40] != None else None,
                        "product_name": row[41],
                        "brand_name": row[42],
                        "product_image": row[43],
                        "product_mrp": row[44],
                        "product_selling_price": row[45],
                        "product_quantity": row[46],
                        "product_quantity_unit": quantity_unit.name,
                        "product_quantity_short_name": quantity_unit.short_name
                    })

            else:
                empty_dict[row[0]] = row[1]
                recordObject = {
                    'cart_id': row[0],
                    'order_total': row[1],
                    'user_id': row[30],
                    'slug': row[2],
                    'store_id': row[3],
                    'coupon_code': coupon_code,
                    'coupon_description': coupon_desc,
                    'order_total_discount': row[5],
                    'final_order_total': row[6],
                    'delivery_fee': row[7],
                    'grand_order_total': row[8],
                    #'initial_paid': row[9],
                    'order_created': str(row[10]) if row[10] else None,
                    'order_confirmed': str(row[11]) if row[11] else None,
                    'ready_to_pack': str(row[12]) if row[12] else None,
                    'order_paid': row[13],
                    'order_pickedup': str(row[14]) if row[14] else None,
                    'order_delivered': str(row[15]) if row[15] else None,
                    'user_address_id': row[16],
                    'delivery_date': str(row[17]) if row[17] != None else None,
                    'delivery_slot_id': str(row[18]),
                    'da_id': row[19],
                    'status': row[20],
                    'merchant_transfer_at': str(row[21]),
                    'merchant_txnid': row[22],
                    'txnid': row[23],
                    'gateway': row[24],
                    'transaction_status': row[25],
                    'cancelled_by': row[26],
                    'cancelled_by_role': row[67],
                    'created_at': str(row[27]) if row[27] != None else None,
                    'updated_at': str(row[28]) if row[28] != None else None,
                    'deleted_at': str(row[29]) if row[29] != None else None,
                    'tax': tax_details,
                    'user_address': {
                        "address1": user_addres.address1,
                        "address2": user_addres.address2,
                        "address3": user_addres.address3,
                        "landmark": user_addres.landmark,
                        "phone_no": user_addres.phone,
                        "latitude": user_addres.latitude,
                        "longitude": user_addres.longitude

                    },
                    'item_order_list_data': [
                        {
                            "item_order_lists_id": row[31],  # store_item.id
                            'item_order_id': row[32],
                            'store_item_id': row[33],
                            'store_item_variable_id': row[34],
                            'quantity': row[35],
                            'product_packaged': row[36],
                            'removed_by': row[37],
                            # 'store_id': row[2],
                            "created_at": str(row[38]) if row[38] != None else None,
                            "updated_at": str(row[39]) if row[39] != None else None,
                            "deleted_at": str(row[40]) if row[40] != None else None,
                            "product_name": row[41],
                            "brand_name": row[42],
                            "image": row[43],
                            "product_mrp": row[44],
                            "product_selling_price": row[45],
                            "product_quantity": row[46],
                            "product_quantity_unit": quantity_unit.name,
                            "product_quantity_short_name": quantity_unit.short_name
                        }
                    ],
                    "store_data": [
                        {
                            "store_id": row[48],
                            "store_name": row[49],
                            "store_slug": row[50],
                            "store_owner_name": row[51],
                            "store_shopkeeper_name": row[52],
                            "store_image": row[53],
                            "store_address_line_1": row[54],
                            "store_address_line_2": row[55],
                            "store_latitude": row[56],
                            "store_longitude": row[57],
                            "pay_later": row[58],
                            "delivery_mode": row[59],
                            "delivery_start_time": str(row[60]) if row[60] != None else None,
                            "delivery_end_time": str(row[61]) if row[61] != None else None,
                            "radius": row[62],
                            "status": row[63],
                            "created_at": str(row[64]) if row[64] != None else None,
                            "updated_at": str(row[65]) if row[65] != None else None,
                            "deleted_at": str(row[66]) if row[66] != None else None,
                        }
                    ],

                }

            fetchCartDetails.append((recordObject))
        fetchCartDetails = [i for j, i in enumerate(
            fetchCartDetails) if i not in fetchCartDetails[:j]]
        # fetchCartDetails = sorted(fetchCartDetails, key=itemgetter('store_id'))
        finalResult = []

        for key, value in groupby(fetchCartDetails):
            finalResult.append(list(value))
        finalResult_without_array = []
        if len(finalResult) > 0:
            for i in range(len(finalResult[0])):
                finalResult_without_array.append(finalResult[i][0])
            #True, 'User order fetched', finalResult_without_array, None)
        logging.info(f"user order fetched {finalResult_without_array}")
        apiResponce = ApiResponse(
            True, 'User order fetched', finalResult_without_array, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User order can not fetched', None,
                            str(e))
        return (error.__dict__), 500

def get_orders_by_id(data):
    try:

        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        id = data['order_id']
        id = re.search(r"\d+(\.\d+)?", id)

        try:
            id = int(id.group(0))

        except:
            error = ApiResponse(False, "Error Occured", None,
                                "Given Order Id is Wrong")
            return (error.__dict__), 400
        
        item_orders = ItemOrder.query.filter_by(
            id=id).filter_by(deleted_at=None).first()
        if not item_orders:
            error = ApiResponse(False, "Error Occured", None,
                                "Given Order Id is Wrong")
            return (error.__dict__), 400

        if item_orders.deleted_at != None:
            error = ApiResponse(False, "Order is Deleted", None,
                                "Given Order Id is Deleted")
            return (error.__dict__), 400

        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=item_orders.id).filter_by(deleted_at=None)
        if item_order_lists:
            item_order_lists_object = []
            for item_order_list in item_order_lists:

                data = {
                    "item_order_list_id": item_order_list.id,
                    "item_order_id": item_order_list.item_order_id,
                    "store_item_id": item_order_list.store_item_id,
                    "store_item_variable_id": item_order_list.store_item_variable_id,
                    "quantity": item_order_list.quantity,
                    "product_packaged": item_order_list.product_packaged,
                    "removed_by": item_order_list.removed_by,
                    "created_at": str(item_order_list.created_at) if item_order_list.created_at != None else None,
                    "updated_at": str(item_order_list.updated_at) if item_order_list.updated_at != None else None,
                    "deleted_at": str(item_order_list.deleted_at) if item_order_list.deleted_at != None else None,
                    "product_name": item_order_list.product_name,
                    "product_brand_name": item_order_list.product_brand_name,
                    "product_image": item_order_list.product_image,
                    "product_mrp": item_order_list.product_mrp,
                    "product_selling_price": item_order_list.product_selling_price,
                    "product_quantity": item_order_list.product_quantity,
                    "product_quantity_unit": item_order_list.product_quantity_unit
                }
                item_order_lists_object.append(data)

        store = Store.query.filter_by(
            id=item_orders.store_id).filter_by(deleted_at=None).first()
        user_addres = UserAddress.query.filter_by(
            id=item_orders.user_address_id).first()
        if not user_addres:
            error = ApiResponse(False, "Order is Not Valid", None,
                                "No address found for the order")
            return (error.__dict__), 400

        coupon = Coupon.query.filter_by(id=item_orders.coupon_id).first()
        # if coupon is not applied
        if not coupon:
            coupon_code = ""
            coupon_desc = ""
        else:
            coupon_code = coupon.code
            coupon_desc = coupon.description
        
        fetchCartDetails = []
        

        

        tax_object = []

        item_order_taxes = ItemOrderTax.query.filter_by(
            item_order_id=id).filter_by(deleted_at = None)

        for item_order_tax in item_order_taxes:
            
            if item_order_tax.tax_type == 1:
                taxtype = "Percentage"
            else:
                taxtype = "Flat"

            tax_data = {
                'tax_id': item_order_tax.id,
                'tax_name': item_order_tax.tax_name,
                'tax_type': taxtype,
                'amount': item_order_tax.amount,
                'calculated': item_order_tax.calculated,
            }

            tax_object.append(tax_data)

        tax_details = {
            'total_tax': item_orders.total_tax,
            'tax_details': tax_object
        }
        
        record_object = {
                'item_order_list_data':item_order_lists_object,
                'cart_id':item_orders.id,
                'order_total': item_orders.order_total,
                'user_id': item_orders.user_id,
                'slug': item_orders.slug,
                'store_id': item_orders.store_id,
                'coupon_code': coupon_code,
                'coupon_description': coupon_desc,
                'order_total_discount': item_orders.order_total_discount,
                'final_order_total': item_orders.final_order_total,
                'delivery_fee': item_orders.delivery_fee,
                'grand_order_total': item_orders.grand_order_total,
                #'initial_paid': item_orders.initial_paid,
                'order_created': str(item_orders.order_created),
                'order_confirmed': str(item_orders.order_confirmed),
                'ready_to_pack' : item_orders.ready_to_pack,
                'order_paid': item_orders.order_paid,
                'order_pickedup': item_orders.order_pickedup,
                'order_delivered': item_orders.order_delivered,
                'user_address_id' :item_orders.user_address_id,
                'delivery_date' : str(item_orders.delivery_date) if item_orders.delivery_date !=None else None,
                'delivery_slot_id': item_orders.delivery_slot_id,
                'da_id' : item_orders.da_id,
                'status': item_orders.status,
                'merchant_transfer_at' : item_orders.merchant_transfer_at,
                'merchant_txnid': item_orders.merchant_txnid,
                'txnid': item_orders.txnid,
                'gateway': item_orders.gateway,
                'transaction_status': item_orders.transaction_status,
                'cancelled_by_id' : item_orders.cancelled_by_id,
                'cancelled_by_role': item_orders.cancelled_by_role,
                'created_at' : str(item_orders.created_at) if item_orders.created_at != None else None,
                'updated_at' : str(item_orders.updated_at) if item_orders.updated_at != None else None,
                'deleted_at' : str(item_orders.deleted_at) if item_orders.deleted_at != None else None,
                'tax': tax_details,
                'user_address': {
                        "address1": user_addres.address1,
                        "address2": user_addres.address2,
                        "address3": user_addres.address3,
                        "landmark": user_addres.landmark,
                        "phone_no": user_addres.phone,
                        "latitude": user_addres.latitude,
                        "longitude": user_addres.longitude

                    },
                
                "store_data": [
                        {
                            "store_id": store.id,
                            "store_name": store.name,
                            "store_slug": store.slug,
                            "store_owner_name": store.owner_name,
                            "store_shopkeeper_name": store.shopkeeper_name,
                            "store_image": store.image,
                            "store_address_line_1": store.address_line_1,
                            "store_address_line_2": store.address_line_2,
                            "store_latitude": store.store_latitude,
                            "store_longitude": store.store_longitude,
                            "pay_later": store.pay_later,
                            "delivery_mode": store.delivery_mode,
                            "delivery_start_time": str(store.delivery_start_time) if store.delivery_start_time != None else None,
                            "delivery_end_time": str(store.delivery_end_time) if store.delivery_end_time != None else None,
                            "radius": store.radius,
                            "status": store.status,
                            "created_at": str(store.created_at) if store.created_at != None else None,
                            "updated_at": str(store.updated_at) if store.updated_at != None else None,
                            "deleted_at": str(store.deleted_at) if store.deleted_at != None else None,
                        }
                    ],
            }
        fetchCartDetails.append(record_object)

        apiResponce = ApiResponse(
            True, 'User order fetched', fetchCartDetails, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User order can not fetched', None,
                            str(e))
        return (error.__dict__), 500

def place_order(data):
    try:
        # user = Auth.get_logged_in_user(request)
        # user_id = user.id
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        current_time = datetime.datetime.utcnow()
        # address = data['address_id']
        id = data['id']
        id = re.search(r"\d+(\.\d+)?", id)
        id = int(id.group(0))

        # inserting the data while placing the order
        item_orders = ItemOrder.query.filter_by(id=id).filter_by(
            order_created=None).filter_by(deleted_at=None).first()
        if not item_orders:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"order_id {data['id']} does not exist")
            return (apiResponce.__dict__), 400

        if item_orders.user_id != user_id:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"unauthorized user for placing the order {data['id']}")
            return (apiResponce.__dict__), 400

        if item_orders.order_created:
            apiResponce = ApiResponse(
                False, 'Order is Allready Placed')
            return (apiResponce.__dict__), 400
        
        store = Store.query.filter_by(id=item_orders.store_id).filter_by(status=1).filter_by(deleted_at=None).first()
        if not store:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"store {store.name} not exist")
            return (apiResponce.__dict__), 400
        
        if store_open_status(store) != 1:
            apiResponce = ApiResponse(
                False, f'Store {store.name} is close now', None)
            return (apiResponce.__dict__), 400
        
        user = item_orders.user
        
        # updating the snap of Item order list
        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=id).filter_by(deleted_at=None).all()
        if not item_order_lists:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"cart is empty for cart id {data['id']}")
            return (apiResponce.__dict__), 400
        for item in item_order_lists:
            store_item = StoreItem.query.filter_by(
                id=item.store_item_id).filter_by(deleted_at=None).first()
            store_item_variable = StoreItemVariable.query.filter_by(
                id=item.store_item_variable_id).filter_by(deleted_at=None).first()
            item.product_selling_price = store_item_variable.selling_price
            item.product_mrp = store_item_variable.mrp
            item.product_quantity_unit = store_item_variable.quantity_unit
            item.product_name = store_item.name
            item.product_brand_name = store_item.brand_name
            item.product_image = store_item.image
            item.product_quantity = store_item_variable.quantity
            item.updated_at = current_time

            try:
                db.session.add(item)
                db.session.commit()
            except Exception as e:
                db.session.rollback()
                error = ApiResponse(False, "Database Server Error", None,
                                    f"Database Name: Error while updating the item_order_lists Error: {str(e)}")
                return error.__dict__, 500
        # item_orders.user_address_id = address

        calculate_order_total(item_orders)

        item_orders.order_created = current_time
        item_orders.status = 1

        try:
            db.session.add(item_orders)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Server Error", None,
                                f"Database Name: Error while updating the item_orders Error: {str(e)}")
            return error.__dict__, 500
        noti_temp = NotificationTemplates.query.filter_by(name='order_placed').filter_by(deleted_at=None).first()
        notification_data = {
            'template_name': 'order_placed',
            'order_id': data['id'],
            'store_name' : store.name,
            'amount' : item_orders.grand_order_total
            # 'user_email': resp['data']['email'],
            # 'user_name': resp['data']['name'],
            # 'template_name': noti_temp.name,
            # 'type': noti_temp.t_type,
            # 'order_id': str(id)
                
        }
        
           
        CreateNotification.gen_notification_v2(user,notification_data)
        fetch_item_order_details = []
        # for row in result:
        recordObject = {
            'id': item_orders.id,
            "user_id": item_orders.user_id,
            "slug": item_orders.slug,
            "store_id": item_orders.store_id,
            "order_total": item_orders.order_total,
            "coupon_id": item_orders.coupon_id,
            "order_total_discount": item_orders.order_total_discount,
            "final_order_total": item_orders.final_order_total,
            "delivery_fee": item_orders.delivery_fee,
            "grand_order_total": item_orders.grand_order_total,
            # "initial_paid": item_orders.initial_paid,
            "order_created": str(item_orders.order_created) if item_orders.order_created != None else None,
            "order_confirmed": str(item_orders.order_confirmed) if item_orders.order_confirmed != None else None,
            "ready_to_pack": if_date(item_orders.ready_to_pack),
            "order_paid": item_orders.order_paid,
            "order_pickedup": if_date(item_orders.order_pickedup),
            "order_delivered": if_date(item_orders.order_delivered),
            "user_address_id": item_orders.user_address_id,
            "delivery_date": if_date(item_orders.delivery_date),
            "delivery_slot_id": item_orders.delivery_slot_id,
            "da_id": item_orders.da_id,
            "status": item_orders.status,
            "merchant_transfer_at": item_orders.merchant_transfer_at,
            "merchant_txnid": item_orders.merchant_txnid,
            "txnid": item_orders.txnid,
            # "odoo_order_id": row[25],
            "gateway": item_orders.gateway,
            "transaction_status": item_orders.transaction_status,
            "cancelled_by": item_orders.cancelled_by_id,
            "cancelled_by_role": item_orders.cancelled_by_role,
            #"created_at": str(item_orders.created_at) if item_orders.created_at != None else None,
            #"updated_at": str(item_orders.updated_at) if item_orders.updated_at != None else None,
            #"deleted_at": str(item_orders.deleted_at) if item_orders.deleted_at != None else None
        }
        fetch_item_order_details.append((recordObject))
        if not len(fetch_item_order_details):
            apiResponce = ApiResponse(
                True, 'Item order not able to fetch', None)
            return (apiResponce.__dict__), 400
        finalResult = []
        for key, value in groupby(fetch_item_order_details):
            finalResult.append(list(value))
        finalResult_without_array = []
        for i in range(len(finalResult)):
            finalResult_without_array.append(finalResult[i][0])

        apiResponce = ApiResponse(
            True, 'Order Was Placed Successfully', finalResult_without_array, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Order not placed', None,
                            str(e))
        return (error.__dict__), 500

def place_order_payu(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = resp['data']['id']
        # address = data['address_id']
        id = data['id']
        id = re.search(r"\d+(\.\d+)?", id)
        id = int(id.group(0))

        # inserting the data while placing the order
        item_orders = ItemOrder.query.filter_by(id=id).filter_by(
            order_created=None).filter_by(deleted_at=None).first()
        
        if not item_orders:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"order_id {data['id']} does not exist")
            return (apiResponce.__dict__), 400

        
        if item_orders.user_id != user_id:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"unauthorized user for placing the order {data['id']}")
            return (apiResponce.__dict__), 400
        
        if item_orders.order_created:
            apiResponce = ApiResponse(
                False, 'Order is Allready Placed')
            return (apiResponce.__dict__), 400
        
        store = Store.query.filter_by(id=item_orders.store_id).filter_by(status=1).filter_by(deleted_at=None).first()
        
        if not store:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"store {store.name} not exist")
            return (apiResponce.__dict__), 400
        
        # if store_open_status(store) != 1:
        #     apiResponce = ApiResponse(
        #         False, f'Store {store.name} is close now', None)
        #     return (apiResponce.__dict__), 400
        
        # updating the snap of Item order list
        
        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=id).filter_by(deleted_at=None).all()
        
        if not item_order_lists:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"cart is empty for cart id {data['id']}")
            return (apiResponce.__dict__), 400
        
        calculate_order_total(item_orders)

        api_data = {
            'cart_id' : item_orders.id,
            'amount': item_orders.grand_order_total,
            'firstname': user['name'],
            'email' : user['email'],
            'phone': user['phone'],
            'productinfo' : data['id']
        }
        return_data = Payment_Util.create_payment(api_data)
        
        apiresponse = ApiResponse(True,"",return_data, None)

        return apiresponse.__dict__, 200
    
    except Exception as e:
        error = ApiResponse(False, 'Order not placed', None,
                            str(e))
        return (error.__dict__), 500

def check_order_payu(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        current_time = datetime.datetime.utcnow()
        # address = data['address_id']
        id = data['productinfo']
        id = re.search(r"\d+(\.\d+)?", id)
        id = int(id.group(0))

        # inserting the data while placing the order
        item_orders = ItemOrder.query.filter_by(id=id).filter_by(
            order_created=None).filter_by(deleted_at=None).first()
        
        if not item_orders:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"order_id {data['productinfo']} does not exist")
            return (apiResponce.__dict__), 400

        if item_orders.user_id != user_id:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"unauthorized user for placing the order {data['productinfo']}")
            return (apiResponce.__dict__), 400

        if item_orders.order_created:
            apiResponce = ApiResponse(
                False, 'Order is Allready Placed')
            return (apiResponce.__dict__), 400
        
        
        status, transaction_id = Payment_Util.get_succes(data)
        
        if status == 1:
            message = "Transaction Allready Verified"
            output_data = {
                "txnid": data['txnid'],
                "status": data['status'],
                "amount": data['amount'],
            }
            apiresponse = ApiResponse(False, message, output_data)
            
            return apiresponse.__dict__ , 400
        
        if status == 2:
            message = "Transaction amount not matched"
            output_data = {
                "txnid": data['txnid'],
                "status": data['status'],
                "amount": data['amount'],
            }
            apiresponse = ApiResponse(False, message, output_data)
            
            return apiresponse.__dict__ , 400
       
        if status == 3:
            message = "Transaction hash not matched"
            output_data = {
                "txnid": data['txnid'],
                "status": data['status'],
                "amount": data['amount'],
            }
            apiresponse = ApiResponse(False, message, output_data)
            
            return apiresponse.__dict__ , 400
        
        elif status != 200:
            message = "Invalid Transaction. Please try again."
        
            output_data = {
                "txnid": data['txnid'],
                "status": data['status'],
                "amount": data['amount'],
            }
            apiresponse = ApiResponse(False, message, output_data)
            
            return apiresponse.__dict__ , 400
        
        message =f"Thank You. Your order status is {data['status']} Your Transaction ID for this transaction is {data['txnid']} We have received a payment of Rs. {data['amount']} our order will soon be shipped."
        
        
        # updating the snap of Item order list
        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=id).filter_by(deleted_at=None).all()
    
        
        for item in item_order_lists:
            store_item = StoreItem.query.filter_by(
                id=item.store_item_id).filter_by(deleted_at=None).first()
            store_item_variable = StoreItemVariable.query.filter_by(
                id=item.store_item_variable_id).filter_by(deleted_at=None).first()
            item.product_selling_price = store_item_variable.selling_price
            item.product_mrp = store_item_variable.mrp
            item.product_quantity_unit = store_item_variable.quantity_unit
            item.product_name = store_item.name
            item.product_brand_name = store_item.brand_name
            item.product_image = store_item.image
            item.product_quantity = store_item_variable.quantity
            item.updated_at = current_time

            save_db(item)

        item_orders.order_created = current_time
        item_orders.transaction_id = transaction_id
        item_orders.txnid = data['txnid']
        item_orders.gateway = data['PG_TYPE']
        item_orders.transaction_status = data['status']
        item_orders.status = 1
        item_orders.order_paid = datetime.datetime.utcnow()
        save_db(item_orders)
        
        store = item_orders.store
        user = item_orders.user
        notification_data = {

            'template_name': 'order_placed',
            'order_id': data['productinfo'],
            'store_name' : store.name,
            'amount' : item_orders.grand_order_total
                
        }
        CreateNotification.gen_notification_v2(user, notification_data)
        
        store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()
        
        if store_merchant:
            merchant = store_merchant.merchant
            notification_data = {

                'template_name': 'order_placed',
                'order_id': data['productinfo'],
                'store_name' : store.name,
                'amount' : item_orders.grand_order_total,
                'user_name' : user.name
                    
            }
            CreateNotification.gen_notification_v2(merchant, notification_data)
        

        apiResponce = ApiResponse(
            True, 'Order Was Placed Successfully')
        return (apiResponce.__dict__), 200

        
        
    except Exception as e:
        error = ApiResponse(False, 'Order not placed', None,
                            str(e))
        return (error.__dict__), 500
    
def cancel_order_customer(data):
    try:

        item_order_id = data['order_id']
        try:
            id = re.search(r"\d+(\.\d+)?", item_order_id)
            id = int(id.group(0))

        except Exception as e:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
            return (apiResponce.__dict__), 400

        item_order_id = id
        item_order = ItemOrder.query.filter_by(id=item_order_id).filter(
            ItemOrder.deleted_at == None).first()
        
        store = item_order.store
        user = item_order.user
        
        if item_order:
            if item_order.order_created:

                if item_order.status != 10:

                    if item_order.status != 11:

                        if not item_order.order_pickedup:

                            resp, status = Auth.get_logged_in_user(request)
                            user = resp['data']

                            if item_order.user_id == user['id']:

                                item_order_lists = ItemOrderLists.query.filter_by(
                                    item_order_id=item_order_id).filter_by(deleted_at=None).filter_by(status=1).all()

                                for item in item_order_lists:

                                    item.status = 11
                                    item.updated_at = datetime.datetime.utcnow()
                                    store_item_var = StoreItemVariable.query.filter_by(
                                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                                    store_item_var.stock += item.quantity
                                    save_db(store_item_var,
                                            'Store Item Variable')
                                    
                                    # item.deleted_at = datetime.datetime.utcnow()

                                    try:
                                        db.session.add(item)
                                        db.session.commit()

                                    except Exception as e:
                                        db.session.rollback()
                                        error = ApiResponse(
                                            False, 'Error Occured', None, "ItemOrderList Database error: "+str(e))
                                        return (error.__dict__), 500

                                item_order.status = 11
                                item_order.updated_at = datetime.datetime.utcnow()
                                # item_order.deleted_at = datetime.datetime.utcnow()
                                # item_order.cancelled_by = user['id']
                                item_order.canceled_by_id = user['id']
                                item_order.canceled_by_role = user['role']

                                try:

                                    db.session.add(item_order)
                                    db.session.commit()

                                except Exception as e:
                                    db.session.rollback()
                                    error = ApiResponse(
                                        False, 'Error Occured', None, "ItemOrders Database error: "+str(e))
                                    return (error.__dict__), 500

                                # noti_temp = NotificationTemplates.query.filter_by(name='cancel_order').filter_by(
                                #     deleted_at=None).first()
                                
                                notification_data = {
                                    'template_name': 'cancel_order',
                                    'order_id': data['order_id'],
                                    'store_name' : store.name,
                                    'amount' : item_order.grand_order_total
                                }
                                # notification_data = {

                                #     'user_email': resp['data']['email'],
                                #     'user_name': resp['data']['name'],
                                #     'template_name': noti_temp.name,
                                #     'type': noti_temp.t_type,
                                #     'order_id': str(id)
                                #     # 'key1': '12345'
                                # }
                                   
                                CreateNotification.gen_notification_v2(user,notification_data)

                                apiresponse = ApiResponse(
                                    True, "Order Canceled Successfully", None, None)
                                return apiresponse.__dict__, 200

                            else:
                                # blacklist merchant or not?
                                # token = request.headers.get('Authorization')
                                # blacklist_token = BlacklistToken(token=token)
                                # try:
                                #     # insert the token
                                #     db.session.add(blacklist_token)
                                #     db.session.commit()
                                # except:
                                #     db.session.rollback()

                                apiresponse = ApiResponse(
                                    False, "User has no access to cancel this order", None, 'User id and order item user is different')
                                return apiresponse.__dict__, 400

                        else:
                            apiresponse = ApiResponse(False, "Order is picked up , Can't cancel it now",
                                                      None, f'Order is allready picked up at {item_order.order_pickedup}')
                            return apiresponse.__dict__, 400

                    else:
                        apiresponse = ApiResponse(
                            False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order is Rejected", None, "'Order Status code is Rejected'")
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Either Order id Wrong or Order is not created yet')
            return apiresponse.__dict__, 400

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def merchant_place_order(data):
    try:
        # user = Auth.get_logged_in_user(request)
        # user_id = user.id
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = resp['data']['id']
        current_time = datetime.datetime.utcnow()
        # address = data['address_id']
        order_id = data['cart_id']

        # inserting the data while placing the order
        item_orders = ItemOrder.query.filter_by(id=order_id).filter_by(user_id=user_id).filter_by(
            walk_in_order=1).filter_by(order_created=None).filter_by(deleted_at=None).first()
        if not item_orders:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"order_id {data['store_id']} does not exist")
            return (apiResponce.__dict__), 400

        store = Store.query.filter_by(id=item_orders.store_id).filter_by(status=1).filter_by(deleted_at=None)
        if not store:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"store {store.name} not exist")
            return (apiResponce.__dict__), 400

        stores = Store.query.filter_by(merchant_id=merchant['id']).filter_by(deleted_at=None).filter_by(status=1).all()

        store_ids = []

        if not stores.merchant_id == user['id']:
            apiresponse = ApiResponse(False, "Merchant has no access to view this order",
                                      None, 'Merchant store_id and order item store_id is different')
            return apiresponse.__dict__, 400

        # updating the snap of Item order list
        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=item_orders.id).filter_by(deleted_at=None).all()
        if not item_order_lists:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f"cart is empty for cart id {order_id}")
            return (apiResponce.__dict__), 400

        #check items is present or not
        out_of_stock_items = ""
        for item in item_order_lists:
            store_item = StoreItem.query.filter_by(
                id=item.store_item_id).filter_by(deleted_at=None).first()
            item_variable = StoreItemVariable.query.filter_by(id = item.store_item_variable_id).first()
            if item_variable.stock < item.quantity:
                if item_variable.stock == 0:
                    out_of_stock_items = out_of_stock_items + f"O{store_item.name} is  Out Stock, "
                else:
                    out_of_stock_items = out_of_stock_items + f"Only {item_variable.stock} number of {store_item.name} is available in inventory where as {item.quantity} ordered, "
        
        if out_of_stock_items != "":
            msg = out_of_stock_items[:-1]
            error = ApiResponse(
                    False, msg, None)
            return error.__dict__, 400

        for item in item_order_lists:
            store_item = StoreItem.query.filter_by(
                id=item.store_item_id).filter_by(deleted_at=None).first()
            store_item_variable = StoreItemVariable.query.filter_by(
                id=item.store_item_variable_id).filter_by(deleted_at=None).first()
            item.product_selling_price = store_item_variable.selling_price
            item.product_mrp = store_item_variable.mrp
            item.product_quantity_unit = store_item_variable.quantity_unit
            item.product_name = store_item.name
            item.product_brand_name = store_item.brand_name
            item.product_image = store_item.image
            item.product_quantity = store_item_variable.quantity
            item.updated_at = current_time

            store_item_variable.stock -= item.quantity
            save_db(store_item_variable, 'Store Item Variable')
            
            
            try:
                db.session.add(item)
                db.session.commit()
            except Exception as e:
                db.session.rollback()
                error = ApiResponse(False, "Database Server Error", None,
                                    f"Database Name: Error while updating the item_order_lists Error: {str(e)}")
                return error.__dict__, 500
        # item_orders.user_address_id = address

        calculate_order_total(item_orders)

        item_orders.order_created = current_time
        item_orders.order_confirmed = current_time
        item_orders.ready_to_pack = current_time
        item_orders.order_pickedup = current_time
        item_orders.order_delivered = current_time
        item_orders.order_paid = current_time
        item_orders.status = 1
        try:
            db.session.add(item_orders)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Server Error", None,
                                f"Database Name: Error while updating the item_orders Error: {str(e)}")
            return error.__dict__, 500

        fetch_item_order_details = []
        # for row in result:
        recordObject = {
            'id': item_orders.id,
            "user_id": item_orders.user_id,
            "slug": item_orders.slug,
            "store_id": item_orders.store_id,
            "order_total": item_orders.order_total,
            "coupon_id": item_orders.coupon_id,
            "order_total_discount": item_orders.order_total_discount,
            "final_order_total": item_orders.final_order_total,
            "delivery_fee": item_orders.delivery_fee,
            "grand_order_total": item_orders.grand_order_total,
            # "initial_paid": item_orders.initial_paid,
            "order_created": if_date(item_orders.order_created),
            "order_confirmed": if_date(item_orders.order_confirmed),
            "ready_to_pack": if_date(item_orders.ready_to_pack),
            "order_paid": if_date(item_orders.order_paid),
            "order_pickedup": if_date(item_orders.order_pickedup),
            "order_delivered": if_date(item_orders.order_delivered),
            "user_address_id": if_date(item_orders.user_address_id),
            "delivery_date": if_date(item_orders.delivery_date),
            "delivery_slot_id": item_orders.delivery_slot_id,
            "da_id": item_orders.da_id,
            "status": item_orders.status,
            # "merchant_transfer_at": item_orders.merchant_transfer_at,
            # "merchant_txnid": item_orders.merchant_txnid,
            # "txnid": item_orders.txnid,
            # "gateway": item_orders.gateway,
            # "transaction_status": item_orders.transaction_status,
            "cancelled_by": item_orders.cancelled_by_id,
            "cancelled_by_role": item_orders.cancelled_by_role,
            "created_at": str(item_orders.created_at) if item_orders.created_at != None else None,
            "updated_at": str(item_orders.updated_at) if item_orders.updated_at != None else None,
            "deleted_at": str(item_orders.deleted_at) if item_orders.deleted_at != None else None
        }
        fetch_item_order_details.append((recordObject))
        if not len(fetch_item_order_details):
            apiResponce = ApiResponse(
                True, 'Item order not able to fetch', None)
            return (apiResponce.__dict__), 400
        finalResult = []
        for key, value in groupby(fetch_item_order_details):
            finalResult.append(list(value))
        finalResult_without_array = []
        for i in range(len(finalResult)):
            finalResult_without_array.append(finalResult[i][0])

            
        apiResponce = ApiResponse(
            True, 'Order Was Placed Successfully', finalResult_without_array, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Order not placed', None,
                            str(e))
        return (error.__dict__), 500

# merchant orders related functions

def get_orders_merchant():
    try:
        resp, status = Auth.get_logged_in_user(request)
        merchant = resp['data']
        try:
            page_no = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        try:
            query = request.args.get('id')
        except Exception:
            query = None

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no == 0:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        stores = Store.query.filter_by(
            merchant_id=merchant['id']).filter_by(deleted_at=None).all()

        store_ids = []

        if stores:
            for store in stores:
                store_ids.append(store.id)

            if query:
                    query = f'{query}%'
                    item_orders = ItemOrder.query.filter(cast(ItemOrder.id, String).like(query)).filter(ItemOrder.store_id.in_(store_ids)).filter(ItemOrder.order_created != None).filter(ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)
            else:
                item_orders = ItemOrder.query.filter(ItemOrder.store_id.in_(store_ids)).filter(ItemOrder.order_created != None).filter(
                ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)

            if item_orders:
                item_order_object = []
                for item_order in item_orders.items:
                    if item_order.walk_in_order==None or item_order.walk_in_order==0:
                        user = User.query.filter_by(
                            id=item_order.user_id).first()
                    else:
                        user = Merchant.query.filter_by(
                            id=item_order.user_id).first()
                    store = Store.query.filter_by(
                        id=item_order.store_id).first()
                    #user = User.query.filter_by(id = item_order.user_id).first()
                    # user = User.query.filter_by(
                    #     id=item_order.user_id).first()

                    if item_order.da_id == 1:
                        self_delivery = 1
                    else:
                        self_delivery = 0

                        
                    data = {
                        'order_id': item_order.id,
                        'slug': item_order.slug,
                        # 'user_id': item_order.user_id,
                        'user_name': user.name,
                        'order_total': item_order.order_total,
                        # 'slug': item_order.slug,
                        'store_id': item_order.store_id,
                        'store_name': store.name,
                        'order_total_discount': item_order.order_total_discount,
                        # 'final_order_total': item_order.final_order_total,
                        'delivery_fee': item_order.delivery_fee,
                        # 'grand_order_total': item_order.grand_order_total,
                        # #'initial_paid': item_order.initial_paid,
                        'order_created': str(item_order.order_created) if item_order.order_created else None,
                        'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                        'ready_to_pack':  str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                        'order_paid':  str(item_order.order_paid) if item_order.order_paid else None,
                        'order_pickedup':  str(item_order.order_pickedup) if item_order.order_pickedup else None,
                        'order_delivered':  str(item_order.order_delivered) if item_order.order_delivered else None,
                        # 'delivery_date':str(item_order.delivery_date),
                        # 'user_address_id': item_order.user_address_id,
                        # 'delivery_slot_id': item_order.delivery_slot_id,
                        # 'da_id': item_order.da_id,
                        'walkin_order': item_order.walk_in_order,
                        'self_delivery': self_delivery,
                        'status': item_order.status,
                        # 'merchant_transfer_at': item_order.merchant_transfer_at,
                        # 'merchant_txnid': item_order.merchant_txnid,
                        # 'txnid': item_order.txnid,
                        # 'gateway': item_order.gateway,
                        # 'transaction_status': item_order.transaction_status,
                        # 'cancelled_by': item_order.cancelled_by,
                        # 'created_at': str(item_order.created_at),
                        'updated_at': str(item_order.updated_at) if item_order.updated_at != None else None,
                        # 'deleted_at': str(item_order.deleted_at),
                    }
                    item_order_object.append(data)

                return_obj = {
                    'page': item_orders.page,
                    'total_pages': item_orders.pages,
                    'has_next_page': item_orders.has_next,
                    'has_prev_page': item_orders.has_prev,
                    'prev_page': item_orders.prev_num,
                    'next_page': item_orders.next_num,
                    'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.Merchant Order_show_orders', page=item_orders.prev_num) if item_orders.has_prev else None,
                    'next_page_url': ENDPOINT_PREFIX + url_for(f'api.Merchant Order_show_orders', page=item_orders.next_num) if item_orders.has_next else None,
                    'current_page_url': ENDPOINT_PREFIX + url_for(f'api.Merchant Order_show_orders', page=page_no),
                    'items_per_page': item_orders.per_page,
                    'items_current_page': len(item_orders.items),
                    'total_items': item_orders.total,
                    'items': item_order_object
                }

                apiresponse = ApiResponse(
                    True, "Data Loaded Succesfully", return_obj, None)
                return apiresponse.__dict__, 200

            else:
                apiresponse = ApiResponse(True, "No Data Found", None, None)
                return apiresponse.__dict__, 200
        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Store is not linked with merchant id')
            return apiresponse.__dict__, 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def get_order_details_merchant(data):
    try:

        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if item_order:
            if item_order.order_created:

                resp, status = Auth.get_logged_in_user(request)
                merchant = resp['data']

                stores = Store.query.filter_by(
                    id=item_order.store_id).filter_by(deleted_at=None).filter_by(merchant_id=merchant['id']).first()

                if stores.merchant_id == merchant['id']:

                    item_order_lists = ItemOrderLists.query.filter_by(
                        item_order_id=data['item_order_id']).filter_by(deleted_at=None).order_by(ItemOrderLists.id).all()

                    if item_order_lists:
                        item_order_list_object = []

                        for item in item_order_lists:

                            # store_item_variable = StoreItemVariable.query.filter_by(id = item.store_item_variable_id).first()

                            # if not store_item_variable:
                            #     apiResponce = ApiResponse(
                            #         False, f'store item variable {item.store_item_variable_id} not available', None,
                            #         f'store item variable {item.store_item_variable_id} not available')
                            #     return (apiResponce.__dict__), 400

                            # store_item = StoreItem.query.filter_by(id = item.store_item_id).filter_by(deleted_at = None).first()

                            # if not store_item:
                            #     apiResponce = ApiResponse(
                            #         False, f'store item {item.store_item_id} not available', None,
                            #         f'store item {item.store_item_id} not available')
                            #     return (apiResponce.__dict__), 400

                            quantity_unit = QuantityUnit.query.filter_by(
                                id=item.product_quantity_unit).first()

                            if not quantity_unit:
                                apiResponce = ApiResponse(
                                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                                return (apiResponce.__dict__), 400

                            orderd_item = {
                                'id': item.id,
                                'store_item_name': item.product_name,
                                'store_item_brand_name': item.product_brand_name,
                                'store_item_image': item.product_image,
                                'store_item_variable_quantity': item.product_quantity,
                                'quantity_unit_name': quantity_unit.name,
                                'quantity_unit_short_name': quantity_unit.short_name,
                                'quantity_unit_conversion': quantity_unit.conversion,
                                'quantity_unit_type_details': quantity_unit.type_details,
                                'store_item_variable_mrp': item.product_mrp,
                                'store_item_variable_selling_price': item.product_selling_price,
                                'item_total_cost': item.product_selling_price * item.quantity,
                                'product_packaged': item.product_packaged,
                                'quantity': item.quantity,
                                'removed_by': item.removed_by,
                                'status': item.status,
                            }
                            item_order_list_object.append(orderd_item)

                        tax_object = []
                        
                        item_order_taxes = ItemOrderTax.query.filter_by(
                            item_order_id=item_order.id).filter_by(deleted_at = None).all()

                        for item_order_tax in item_order_taxes:
                            if item_order_tax.tax_type == 1:
                                taxtype = "Percentage"
                            else:
                                taxtype = "Flat"

                            tax_data = {
                                'tax_id': item_order_tax.id,
                                'tax_name': item_order_tax.tax_name,
                                'tax_type': taxtype,
                                'amount': item_order_tax.amount,
                                'calculated': item_order_tax.calculated,
                            }

                            tax_object.append(tax_data)

                        tax_details = {
                            'total_tax': item_order.total_tax,
                            'tax_details': tax_object
                        }
                        store = Store.query.filter_by(
                            id=item_order.store_id).first()

                        if item_order.walk_in_order == 1:
                            user = Merchant.query.filter_by(
                                id=item_order.user_id).first()
                        else:
                            user = User.query.filter_by(
                                id=item_order.user_id).first()

                        self_delivery = 0
                        if item_order.da_id == 1:
                            self_delivery = 1

                        coupon_name = None
                        if item_order.coupon_id:
                            coupon = item_order.coupon
                            coupon_name = coupon.code
                        
                        data = {
                            'order_id': item_order.id,
                            'slug': item_order.slug,
                            # 'user_id': item_order.user_id,
                            'user_name': user.name,
                            'order_total': item_order.order_total,
                            # 'slug': item_order.slug,
                            'store_id': item_order.store_id,
                            'store_name': store.name,
                            'self_delivery': self_delivery,
                            'coupon_name': coupon_name,
                            'order_total_discount': item_order.order_total_discount,
                            'final_order_total': item_order.final_order_total,
                            'delivery_fee': item_order.delivery_fee,
                            'grand_order_total': item_order.grand_order_total,
                            # #'initial_paid': item_order.initial_paid,
                            'order_created': if_date(item_order.order_created),
                            'order_confirmed': if_date(item_order.order_confirmed),
                            'ready_to_pack':  if_date(item_order.ready_to_pack),
                            'order_paid':  if_date(item_order.order_paid),
                            'order_pickedup':  if_date(item_order.order_pickedup),
                            'order_delivered':  if_date(item_order.order_delivered),
                            'delivery_date': if_date(item_order.delivery_date),
                            # 'user_address_id': item_order.user_address_id,
                            # 'delivery_slot_id': item_order.delivery_slot_id,
                            # 'da_id': item_order.da_id,
                            'walkin_order': item_order.walk_in_order,
                            'status': item_order.status,
                            # 'merchant_transfer_at': item_order.merchant_transfer_at,
                            # 'merchant_txnid': item_order.merchant_txnid,
                            # 'txnid': item_order.txnid,
                            # 'gateway': item_order.gateway,
                            # 'transaction_status': item_order.transaction_status,
                            # 'cancelled_by': item_order.cancelled_by,
                            # 'created_at': str(item_order.created_at),
                            'updated_at': if_date(item_order.updated_at),
                            # 'deleted_at': str(item_order.deleted_at),
                            'items': item_order_list_object,
                            'tax': tax_details
                        }

                        apiresponse = ApiResponse(
                            True, "Data Loaded Succesfully", data, None)
                        return apiresponse.__dict__, 200

                    else:
                        apiresponse = ApiResponse(
                            True, "No Data Found", None, None)
                        return apiresponse.__dict__, 200

                else:
                    # blacklist merchant or not?
                    # token = request.headers.get('Authorization')
                    # blacklist_token = BlacklistToken(token=token)
                    # try:
                    #     # insert the token
                    #     db.session.add(blacklist_token)
                    #     db.session.commit()
                    # except:
                    #     db.session.rollback()

                    apiresponse = ApiResponse(False, "Merchant has no access to view this order",
                                              None, 'Merchant store_id and order item store_id is different')
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def merchant_update_order(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        merchant_id = user['id']
        req_body = data.json
        item_order_list_id = req_body['item_order_list_id']
        item_order_id = req_body['item_order_id']
        # store_item_id = req_body['store_item_id']
        # store_item_variable_id = req_body['store_item_variable_id']
        # action = int(req_body['action'])
        quantity = int(req_body['quantity'])
        order = ItemOrder.query.filter_by(id=item_order_id).filter_by(deleted_at = None).first()

        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
        # merchant_store_ids = StoreMerchant.query.filter_by(
        #     merchant_id=merchant_id).all()
        item = ItemOrderLists.query.filter_by(id=item_order_list_id).first()
        # selling_price = StoreItemVariable.query.filter_by(id=store_item_variable_id).first().selling_price

        merchant_id_order = order.store.merchant_id

        if not merchant_id_order == merchant_id_order:
            error = ApiResponse(False, "Unauthorized Merchant", None, "")
            return error.__dict__, 401

        if order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        if order.ready_to_pack:
            error = ApiResponse(False, "Order Already Ready to Pack",
                                None, "Order Already Ready to Pack")
            return error.__dict__, 400

        if order.coupon_id or order.order_total_discount:
            error = ApiResponse(
                False, "Order has Coupons Applied", None, "Order has Coupons")
            return error.__dict__, 200

        if not item.item_order_id == item_order_id:
            error = ApiResponse(
                False, "Details don't match the database", None, "Details do not match")
            return error.__dict__, 400

        # if not user['role'] == 'merchant':
        #     if user['role'] == 'admin':
        #         error = ApiResponse(False,"Admin Can't Partial Edit Orders",None,"Unauthorized Access")
        #         return error.__dict__, 403
        #     if user['role'] == 'super_admin':
        #         error = ApiResponse(False,"Super Admin Can't Partial Edit Orders",None,"Unauthorized Access")
        #         return error.__dict__, 403

        if not order.order_created:
            error = ApiResponse(False, "Order not found",
                                None, "Order is not created")
            return error.__dict__, 400

        # r = 0
        # for entry in merchant_store_ids:
        #     if order.store_id == entry.store_id:
        #         r = 1

        # if not r == 1:
            

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "")
            return error.__dict__, 400

        # if action == 0:
        #     response = ApiResponse(True,"Item Successfully Updated",None,None)
        #     return response.__dict__, 200

        if quantity > item.quantity:
            response = ApiResponse(
                False, "Merchant Cannot increase Quantity", None, None)
            return response.__dict__, 400

        if quantity < 0:
            response = ApiResponse(
                False, "Quantity Cannot be Negative", None, None)
            return response.__dict__, 400

        if quantity == 0:
            item.status = 10
            item.updated_at = datetime.datetime.utcnow()
            item.removed_by = user['id']

        if item.quantity > quantity:
            item.quantity = quantity
            item.updated_at = datetime.datetime.utcnow()

        try:
            db.session.add(item)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: ItemOrderList Error: {str(e)}")
            return error.__dict__, 500

        order_total, final_order_total, grand_order_total = calculate_order_total(
            order)
        active_item_count = get_count(ItemOrderLists.query.filter_by(
            status=1).filter_by(item_order_id=order.id))

        #print(active_item_count)

        if active_item_count == 0:
            order.status = 10

        order.order_total = order_total
        order.final_order_total = final_order_total
        order.grand_order_total = grand_order_total
        order.updated_at = datetime.datetime.utcnow()

        try:
            db.session.add(order)
            db.session.commit()
        except Exception as e:
            db.session.rollback()

            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: ItemOrderList Error: {str(e)}")
            return error.__dict__, 500

        user = order.user
        store = order.store
        
        notification_data = {
            'store_name': store.name,
            'template_name': 'order_update',
            'order_id': str(order.id)
                
        }
           
        CreateNotification.gen_notification_v2(user, notification_data)
        
        response = ApiResponse(True, "Item Successfully Updated", None, None)
        return response.__dict__, 200

    
    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__, 500

def merchant_accept_order(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        req_body = data.json

        item_order_id = req_body['item_order_id']

        order = ItemOrder.query.filter_by(id=item_order_id).filter_by(deleted_at = None).first()

        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        if order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        merchant_id = order.store.merchant_id


        if not merchant_id == user['id']:
            error = ApiResponse(
                False, "Unauthorized Merchant", None, "Store id not in Merchant Stores")
            return error.__dict__, 401

        item_order_lists = ItemOrderLists.query.filter_by(item_order_id = item_order_id).filter_by(deleted_at = None).all()
        out_of_stock_items = ""
        for item_order_list in item_order_lists:
            item_variable = StoreItemVariable.query.filter_by(id = item_order_list.store_item_variable_id).first()
            if item_variable.stock < item_order_list.quantity:
                out_of_stock_items = out_of_stock_items + f"Only {item_variable.stock} number of {item_order_list.product_name} is available in inventory where as {item_order_list.quantity} ordered, "
        
        if out_of_stock_items != "":
            msg = out_of_stock_items[:-1]
            error = ApiResponse(
                    False, msg, None)
            return error.__dict__, 400

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be accepted in it's current state", None, "Order Status != 1")
            return error.__dict__, 400

        if order.order_confirmed:
            error = ApiResponse(False, "Order Already Confirmed",
                                None, "Order Already Confirmed")
            return error.__dict__, 400

        order.order_confirmed = datetime.datetime.utcnow()
        order.updated_at = datetime.datetime.utcnow()
        order.status = 1
        items = ItemOrderLists.query.filter_by(item_order_id=order.id).filter_by(
            deleted_at=None).filter_by(status=1).all()

        for item in items:
            store_item_var = StoreItemVariable.query.filter_by(
                id=item.store_item_variable_id).filter_by(deleted_at=None).first()
            store_item_var.stock -= item.quantity
            save_db(store_item_var, 'Store Item Variable')
            
        try:
            db.session.add(order)
            db.session.commit()
            order = ItemOrder.query.filter_by(id=item_order_id).first()

            if order.order_confirmed:
                
                user = order.user
                store = order.store
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_accept',
                    'order_id': str(order.id),
                    'role': 'Merchant'
                        
                }

                notification = Process(
                    target = CreateNotification.gen_notification_v2(user, notification_data),
                    daemon=True
                ) 

                notification.start()
                
                
                response = ApiResponse(
                    True, "Order Accepted Successfully", None, None)
                return response.__dict__, 200

            error = ApiResponse(
                False, "Unable to write to database", None, "Unable to write to database")
            return error.__dict__, 500

        except Exception as e:
            db.session.rollback()
            db.session.commit()
            error = ApiResponse(False, "Some Error Occured!", None, str(e))
            return error.__dict__, 500
        
        
    except Exception as e:
        error = ApiResponse(False, "Some Error Occured!", None, str(e))
        return error.__dict__, 500

def merchant_order_ready_to_pack(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        req_body = data.json

        item_order_id = req_body['item_order_id']

        order = ItemOrder.query.filter_by(id=item_order_id).filter_by(deleted_at = None).first()
        
        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        if order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        merchant_id_order = order.store.merchant_id

        if user['role'] == "merchant":

            if not merchant_id_order == user['id']:
                error = ApiResponse(False, "Unauthorized Merchant", None, "")
                return error.__dict__, 401

        if not order.order_created:
            error = ApiResponse(False, "Order Not Yet Created",
                                None)
            return error.__dict__, 400

        if not order.order_confirmed:
            error = ApiResponse(False, "Order Not Yet Confirmed",
                                None)
            return error.__dict__, 400
        
        if order.ready_to_pack:
            error = ApiResponse(False, "Order is Allready Ready to Pack",
                                None)
            return error.__dict__, 400

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "Order Status != 1")
            return error.__dict__, 400

        order.ready_to_pack = datetime.datetime.utcnow()
        order.updated_at = datetime.datetime.utcnow()
        order.status = 1

        try:
            db.session.add(order)
            db.session.commit()
            order = ItemOrder.query.filter_by(id=item_order_id).first()

            if order.ready_to_pack:
                
                user = order.user
                store = order.store
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_ready_to_pack',
                    'order_id': str(order.id)
                        
                }
                   
                CreateNotification.gen_notification_v2(user, notification_data)
                
                response = ApiResponse(True, "Order Ready to Pack", None, None)
                return response.__dict__, 200

            error = ApiResponse(
                False, "Unable to write to database", None, "Unable to write to database")
            return error.__dict__, 500

        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Error Occured!", None, str(e))
            return error.__dict__, 500
    except Exception as e:
        error = ApiResponse(False, "Some Error Occured!", None, str(e))
        return error.__dict__, 500

def reject_order_merchant(data):
    try:

        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if item_order:
            if item_order.walk_in_order == 1:
                error = ApiResponse(
                    False, "Can't change Walk in Order Status", None)
                return error.__dict__, 400

            if item_order.order_created:

                if not item_order.order_confirmed:

                    if item_order.status != 11:

                        if item_order.status != 10:

                            resp, status = Auth.get_logged_in_user(request)
                            merchant = resp['data']
                            stores = Store.query.filter_by(
                                merchant_id=merchant['id']).filter_by(deleted_at=None).filter_by(status=1).all()

                            store_id = []
                            for store in stores:
                                store_id.append(store.id)

                            if item_order.store_id in store_id:

                                item_order_lists = ItemOrderLists.query.filter_by(
                                    item_order_id=data['item_order_id'])

                                for item in item_order_lists:

                                    item.status = 10
                                    item.updated_at = datetime.datetime.utcnow()
                                    # item.deleted_at = datetime.datetime.utcnow()
                                    item.removed_by = merchant['id']

                                    save_db(item)
                                    
                                    store_item_var = StoreItemVariable.query.filter_by(
                                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                                    store_item_var.stock += item.quantity
                                    
                                    save_db(store_item_var)

                                item_order.status = 10
                                item_order.removed_by_role = "merchant"
                                item_order.removed_by_id = merchant['id']
                                item_order.updated_at = datetime.datetime.utcnow()
                                # item_order.deleted_at = datetime.datetime.utcnow()
                                # item_order.canceled_by = merchant['id']

                                try:

                                    db.session.add(item_order)
                                    db.session.commit()

                                except Exception as e:
                                    db.session.rollback()
                                    error = ApiResponse(
                                        False, 'Error Occured', None, "ItemOrders Database error: "+str(e))
                                    return (error.__dict__), 500

                                user = item_order.user
                                store = item_order.store
                                
                                notification_data = {
                                    'store_name': store.name,
                                    'template_name': 'order_reject',
                                    'order_id': str(item_order.id),
                                    'role' : 'Merchant',
                                        
                                }
                                   
                                CreateNotification.gen_notification_v2(user, notification_data)
        
                                apiresponse = ApiResponse(
                                    True, "Order Rejected Successfuly", None, None)
                                return apiresponse.__dict__, 200

                            else:
                                # blacklist merchant or not?
                                # token = request.headers.get('Authorization')
                                # blacklist_token = BlacklistToken(token=token)
                                # try:
                                #     # insert the token
                                #     db.session.add(blacklist_token)
                                #     db.session.commit()
                                # except:
                                #     db.session.rollback()

                                apiresponse = ApiResponse(
                                    False, "Merchant has no access to view this order", None, 'Merchant store_id and order item store_id is different')
                                return apiresponse.__dict__, 400

                        else:
                            apiresponse = ApiResponse(
                                False, "Order is Allready Rejected", None, "'Order Status code is Rejected'")
                            return apiresponse.__dict__, 400
                    else:
                        apiresponse = ApiResponse(
                            False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order Allready Accepted", None, "Order Allready Accepted")
                    return apiresponse.__dict__, 400
            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def cancel_order_merchant(data):
    try:

        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if item_order:
            if item_order.walk_in_order == 1:
                error = ApiResponse(
                    False, "Can't change Walk in Order Status", None)
                return error.__dict__, 400

            if item_order.order_created:

                if item_order.status != 10:

                    if item_order.order_confirmed:

                        if item_order.status != 11:

                            if not item_order.order_pickedup:

                                resp, status = Auth.get_logged_in_user(request)
                                user = resp['data']

                                merchant = False
                                admin = False

                                if user['role'] == 'merchant':
                                    stores = Store.query.filter_by(
                                        merchant_id=user['id']).filter_by(deleted_at=None).all()

                                    store_id = []
                                    for store in stores:
                                        store_id.append(store.id)

                                    if item_order.store_id in store_id:
                                        merchant = True

                                elif user['role'] == 'super_admin' or user['role'] == 'admin':
                                    admin = True

                                if merchant or admin:

                                    item_order_lists = ItemOrderLists.query.filter_by(
                                        item_order_id=data['item_order_id']).filter_by(deleted_at=None).filter_by(status=1).all()

                                    for item in item_order_lists:

                                        item.status = 11
                                        item.updated_at = datetime.datetime.utcnow()
                                        store_item_var = StoreItemVariable.query.filter_by(
                                            id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                                        store_item_var.stock += item.quantity
                                        save_db(store_item_var,
                                                'Store Item Variable')
                                        
                                        # item.deleted_at = datetime.datetime.utcnow()

                                        try:
                                            db.session.add(item)
                                            db.session.commit()

                                        except Exception as e:
                                            db.session.rollback()
                                            error = ApiResponse(
                                                False, 'Error Occured', None, "ItemOrderList Database error: "+str(e))
                                            return (error.__dict__), 500

                                    item_order.status = 11
                                    item_order.updated_at = datetime.datetime.utcnow()
                                    # item_order.deleted_at = datetime.datetime.utcnow()
                                    # item_order.cancelled_by = user['id']
                                    item_order.canceled_by_id = user['id']
                                    item_order.canceled_by_role = user['role']

                                    try:

                                        db.session.add(item_order)
                                        db.session.commit()

                                    except Exception as e:
                                        db.session.rollback()
                                        error = ApiResponse(
                                            False, 'Error Occured', None, "ItemOrders Database error: "+str(e))
                                        return (error.__dict__), 500

                                    notification_data = {
                                    'store_name': store.name,
                                    'template_name': 'order_cancel',
                                    'order_id': str(item_order.id),
                                    'role' : 'Merchant'
                                    
                                    }
                                    
                                    CreateNotification.gen_notification_v2(user, notification_data)
                                    
                                    apiresponse = ApiResponse(
                                        True, "Order Canceled Successfully", None, None)
                                    return apiresponse.__dict__, 200

                                else:
                                    # blacklist merchant or not?
                                    # token = request.headers.get('Authorization')
                                    # blacklist_token = BlacklistToken(token=token)
                                    # try:
                                    #     # insert the token
                                    #     db.session.add(blacklist_token)
                                    #     db.session.commit()
                                    # except:
                                    #     db.session.rollback()

                                    apiresponse = ApiResponse(
                                        False, "Merchant has no access to view this order", None, 'Merchant store_id and order item store_id is different')
                                    return apiresponse.__dict__, 400

                            else:
                                apiresponse = ApiResponse(
                                    False, "Order is picked up , Can't cancel it now", None, f'Order is allready picked up at {item_order.order_pickedup}')
                                return apiresponse.__dict__, 400

                        else:
                            apiresponse = ApiResponse(
                                False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                            return apiresponse.__dict__, 400

                    else:
                        apiresponse = ApiResponse(
                            False, "Order is not Accepted Yet", None, "Order is not confirmed")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order is Allready Rejected", None, "'Order Status code is Rejected'")
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Either Order id Wrong or Order is not created yet')
            return apiresponse.__dict__, 400

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def pick_up_order_merchant(data):
    try:
        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if not item_order:
            apiresponse = ApiResponse(False, "Order Not Found", None, None)
            return apiresponse.__dict__, 400

        if item_order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        if item_order.da_id != 1:
            apiresponse = ApiResponse(
                False, "Merchant Can't change the Status of the Order", None, None)
            return apiresponse.__dict__, 400

        if not item_order.order_created:
            apiresponse = ApiResponse(
                False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400

        if item_order.status == 10:
            apiresponse = ApiResponse(
                False, "Order is Rejected", None, "'Order Status code is Rejected'")
            return apiresponse.__dict__, 400

        if item_order.status == 11:
            apiresponse = ApiResponse(
                False, "Order is Canceled", None, "'Order Status code is Canceled'")
            return apiresponse.__dict__, 400

        if not item_order.order_confirmed:
            apiresponse = ApiResponse(
                False, "Order is not Accepted Yet", None, "Order is not confirmed")
            return apiresponse.__dict__, 400

        if not item_order.ready_to_pack:
            apiresponse = ApiResponse(
                False, "Order is not Ready to Pack Yet", None, "Order is not Ready to Pack Yet")
            return apiresponse.__dict__, 400

        if item_order.order_pickedup:
            apiresponse = ApiResponse(False, "Order is allready picked up", None,
                                      f'Order is allready picked up at {item_order.order_pickedup}')
            return apiresponse.__dict__, 400

        if item_order.order_delivered:
            apiresponse = ApiResponse(False, "Order is allready Delivered", None,
                                      f'Order is allready delivered at {item_order.order_delivered}')
            return apiresponse.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        stores = Store.query.filter_by(
            id=item_order.store_id).filter_by(deleted_at=None).first()

        if not stores.merchant_id == user['id']:
            apiresponse = ApiResponse(False, "Merchant has no access to view this order",
                                      None, 'Merchant store_id and order item store_id is different')
            return apiresponse.__dict__, 400

        item_order.order_pickedup = datetime.datetime.utcnow()
        item_order.updated_at = datetime.datetime.utcnow()

        save_db(item_order, "ItemOrder")
        

        user = item_order.user
        store = item_order.store
        
        notification_data = {
            'store_name': store.name,
            'template_name': 'order_picked_up',
            'order_id': str(item_order.id)
                
        }
        
        CreateNotification.gen_notification_v2(user, notification_data)
                
        apiresponse = ApiResponse(
            True, "Order Status Changed to Picked Up", None, None)
        return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def delivered_order_merchant(data):
    try:
        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if not item_order:
            apiresponse = ApiResponse(False, "Order Not Found", None, None)
            return apiresponse.__dict__, 400

        if item_order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        if item_order.da_id != 1:
            apiresponse = ApiResponse(
                False, "Merchant Can't change the Status of the Order", None, None)
            return apiresponse.__dict__, 400

        if not item_order.order_created:
            apiresponse = ApiResponse(
                False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400

        if item_order.status == 10:
            apiresponse = ApiResponse(
                False, "Order is Rejected", None, "'Order Status code is Rejected'")
            return apiresponse.__dict__, 400

        if item_order.status == 11:
            apiresponse = ApiResponse(
                False, "Order is Canceled", None, "'Order Status code is Canceled'")
            return apiresponse.__dict__, 400

        if not item_order.order_confirmed:
            apiresponse = ApiResponse(
                False, "Order is not Accepted Yet", None, "Order is not confirmed")
            return apiresponse.__dict__, 400

        if not item_order.ready_to_pack:
            apiresponse = ApiResponse(
                False, "Order is not Ready to Pack Yet", None, "Order is not Ready to Pack Yet")
            return apiresponse.__dict__, 400

        if not item_order.order_pickedup:
            apiresponse = ApiResponse(False, "Order is not picked up", None,
                                      f'Order is not picked up at {item_order.order_pickedup}')
            return apiresponse.__dict__, 400

        if item_order.order_delivered:
            apiresponse = ApiResponse(False, "Order is allready Delivered", None,
                                      f'Order is allready delivered at {item_order.order_delivered}')
            return apiresponse.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        stores = Store.query.filter_by(
            id=item_order.store_id).filter_by(deleted_at=None).first()

        if not stores.merchant_id == user['id']:
            apiresponse = ApiResponse(False, "Merchant has no access to view this order",
                                      None, 'Merchant store_id and order item store_id is different')
            return apiresponse.__dict__, 400

        item_order.order_delivered = datetime.datetime.utcnow()
        item_order.updated_at = datetime.datetime.utcnow()
        item_order.delivery_date = datetime.datetime.utcnow()

        save_db(item_order, "ItemOrder")
        
        
        user = item_order.user
        store = item_order.store
        
        notification_data = {
            'store_name': store.name,
            'template_name': 'order_delivered',
            'order_id': str(item_order.id)
                
        }
        
        CreateNotification.gen_notification_v2(user, notification_data)
        
        apiresponse = ApiResponse(
            True, "Order Status Changed to Delivered", None, None)
        return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500


## Supervisor Order related functions

def get_orders_supervisor():
    try:
        resp, status = Auth.get_logged_in_user(request)
        supervisor = resp['data']

        cities = UserCities.query.filter_by(user_id=supervisor['id']).filter_by(
            role='supervisor').filter_by(deleted_at=None).all()
        try:
            page_no = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        try:
            query = request.args.get('id')
        except Exception:
            query = ""

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        id = []

        for city in cities:
            id.append(city.city_id)

        stores = Store.query.filter(Store.city_id.in_(
            id)).filter_by(deleted_at=None).all()

        if stores:

            store_ids = []
            for store in stores:
                store_ids.append(store.id)

            if query:
                    query = f'{query}%'
                    item_orders = ItemOrder.query.filter(cast(ItemOrder.id, String).like(query)).filter(ItemOrder.store_id.in_(store_ids)).filter(ItemOrder.order_created != None).filter(ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)
            else:
                item_orders = ItemOrder.query.filter(ItemOrder.store_id.in_(store_ids)).filter(ItemOrder.order_created != None).filter(
                ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)


            if item_orders:
                item_order_object = []
                for item_order in item_orders.items:

                    store = Store.query.filter_by(
                        id=item_order.store_id).first()


                    if item_order.walk_in_order==None or item_order.walk_in_order==0:
                        user = User.query.filter_by(
                            id=item_order.user_id).first()
                    else:
                        user = Merchant.query.filter_by(
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
                        # #'initial_paid': item_order.initial_paid,
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
                        # 'merchant_txnid': item_order.merchant_txnid,
                        # 'txnid': item_order.txnid,
                        # 'gateway': item_order.gateway,
                        # 'transaction_status': item_order.transaction_status,
                        # 'cancelled_by': item_order.cancelled_by,
                        # 'created_at': str(item_order.created_at),
                        'updated_at': if_date(item_order.updated_at),
                        # 'deleted_at': str(item_order.deleted_at),
                    }
                    item_order_object.append(data)

                return_obj = {
                    'page': item_orders.page,
                    'total_pages': item_orders.pages,
                    'has_next_page': item_orders.has_next,
                    'has_prev_page': item_orders.has_prev,
                    'prev_page': item_orders.prev_num,
                    'next_page': item_orders.next_num,
                    'prev_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor Order_get_orders', page=item_orders.prev_num) if item_orders.has_prev else None,
                    'next_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor Order_get_orders', page=item_orders.next_num) if item_orders.has_next else None,
                    'current_page_url': ENDPOINT_PREFIX + url_for('api.Supervisor Order_get_orders', page=page_no),
                    'items_per_page': item_orders.per_page,
                    'items_current_page': len(item_orders.items),
                    'total_items': item_orders.total,
                    'items': item_order_object
                }

                apiresponse = ApiResponse(
                    True, "Data Loaded Succesfully", return_obj, None)
                return apiresponse.__dict__, 200

            else:
                apiresponse = ApiResponse(True, "No Data Found", None, None)
                return apiresponse.__dict__, 200
        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Store is not linked with supervisor id')
            return apiresponse.__dict__, 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def get_order_details_supervisor(data):
    try:
        item_order = ItemOrder.query.filter_by(id=data['order_id']).filter(
            ItemOrder.deleted_at == None).first()

        if item_order:
            if item_order.order_created:

                resp, status = Auth.get_logged_in_user(request)
                supervisor = resp['data']
                cities = UserCities.query.filter_by(user_id=supervisor['id']).filter_by(
                    deleted_at=None).filter_by(role='supervisor').all()

                city_ids = []
                for city in cities:
                    city_ids.append(city.city_id)

                store = Store.query.filter_by(id=item_order.store_id).filter(
                    Store.city_id.in_(city_ids)).filter_by(deleted_at=None).first()

                if store.id == item_order.store_id:

                    item_order_lists = ItemOrderLists.query.filter_by(
                        item_order_id=data['order_id']).filter_by(deleted_at=None).order_by(ItemOrderLists.id).all()

                    if item_order_lists:
                        item_order_list_object = []

                        for item in item_order_lists:

                            # store_item_variable = StoreItemVariable.query.filter_by(id = item.store_item_variable_id).first()

                            # if not store_item_variable:
                            #     apiResponce = ApiResponse(
                            #         False, f'store item variable {item.store_item_variable_id} not available', None,
                            #         f'store item variable {item.store_item_variable_id} not available')
                            #     return (apiResponce.__dict__), 400

                            # store_item = StoreItem.query.filter_by(id = item.store_item_id).filter_by(deleted_at = None).first()

                            # if not store_item:
                            #     apiResponce = ApiResponse(
                            #         False, f'store item {item.store_item_id} not available', None,
                            #         f'store item {item.store_item_id} not available')
                            #     return (apiResponce.__dict__), 400

                            quantity_unit = QuantityUnit.query.filter_by(
                                id=item.product_quantity_unit).first()

                            if not quantity_unit:
                                apiResponce = ApiResponse(
                                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                                return (apiResponce.__dict__), 400

                            orderd_item = {
                                'id': item.id,
                                'store_item_name': item.product_name,
                                'store_item_brand_name': item.product_brand_name,
                                'store_item_image': item.product_image,
                                'store_item_variable_quantity': item.product_quantity,
                                'quantity_unit_name': quantity_unit.name,
                                'quantity_unit_short_name': quantity_unit.short_name,
                                'quantity_unit_conversion': quantity_unit.conversion,
                                'quantity_unit_type_details': quantity_unit.type_details,
                                'store_item_variable_mrp': item.product_mrp,
                                'store_item_variable_selling_price': item.product_selling_price,
                                'item_total_cost': item.product_selling_price * item.quantity,
                                'product_packaged': item.product_packaged,
                                'quantity': item.quantity,
                                'removed_by': item.removed_by,
                                'status': item.status,
                            }
                            item_order_list_object.append(orderd_item)

                        tax_object = []

                        item_order_taxes = ItemOrderTax.query.filter_by(
                            item_order_id=item_order.id).filter_by(deleted_at = None).all()

                        for item_order_tax in item_order_taxes:
                            
                            if item_order_tax.tax_type == 1:
                                taxtype = "Percentage"
                            else:
                                taxtype = "Flat"

                            tax_data = {
                                'tax_id': item_order_tax.id,
                                'tax_name': item_order_tax.tax_name,
                                'tax_type': taxtype,
                                'amount': item_order_tax.amount,
                                'calculated': item_order_tax.calculated,
                            }

                            tax_object.append(tax_data)

                        tax_details = {
                            'total_tax': item_order.total_tax,
                            'tax_details': tax_object
                        }
                        store = Store.query.filter_by(
                            id=item_order.store_id).first()
                        user = User.query.filter_by(
                            id=item_order.user_id).first()
                        
                        coupon_name = None
                        if item_order.coupon_id:
                            coupon = item_order.coupon
                            coupon_name = coupon.name
                        
                        data = {
                            'order_id': item_order.id,
                            'slug': item_order.slug,
                            # 'user_id': item_order.user_id,
                            'user_name': user.name,
                            'order_total': item_order.order_total,
                            # 'slug': item_order.slug,
                            'store_id': item_order.store_id,
                            'store_name': store.name,
                            'coupon_name': coupon_name,
                            'order_total_discount': item_order.order_total_discount,
                            'final_order_total': item_order.final_order_total,
                            'delivery_fee': item_order.delivery_fee,
                            'grand_order_total': item_order.grand_order_total,
                            # #'initial_paid': item_order.initial_paid,
                            'order_created': if_date(item_order.order_created) ,
                            'order_confirmed': if_date(item_order.order_confirmed),
                            'ready_to_pack':  if_date(item_order.ready_to_pack),
                            'order_paid':  if_date(item_order.order_paid),
                            'order_pickedup':  if_date(item_order.order_pickedup),
                            'order_delivered':  if_date(item_order.order_delivered),
                            'delivery_date': if_date(item_order.delivery_date),
                            # 'user_address_id': item_order.user_address_id,
                            # 'delivery_slot_id': item_order.delivery_slot_id,
                            # 'da_id': item_order.da_id,
                            'walkin_order': item_order.walk_in_order,
                            'status': item_order.status,
                            # 'merchant_transfer_at': item_order.merchant_transfer_at,
                            # 'merchant_txnid': item_order.merchant_txnid,
                            # 'txnid': item_order.txnid,
                            # 'gateway': item_order.gateway,
                            # 'transaction_status': item_order.transaction_status,
                            # 'cancelled_by': item_order.cancelled_by,
                            # 'created_at': str(item_order.created_at),
                            'updated_at': if_date(item_order.updated_at),
                            # 'deleted_at': str(item_order.deleted_at),
                            'items': item_order_list_object,
                            'tax': tax_details
                        }

                        apiresponse = ApiResponse(
                            True, "Data Loaded Succesfully", data, None)
                        return apiresponse.__dict__, 200

                    else:
                        apiresponse = ApiResponse(
                            True, "No Data Found", None, None)
                        return apiresponse.__dict__, 200

                else:
                    # blacklist merchant or not?
                    # token = request.headers.get('Authorization')
                    # blacklist_token = BlacklistToken(token=token)
                    # try:
                    #     # insert the token
                    #     db.session.add(blacklist_token)
                    #     db.session.commit()
                    # except:
                    #     db.session.rollback()

                    apiresponse = ApiResponse(False, "Supervisor has no access to view this order",
                                              None, 'Supervisor store_id and order item store_id is different')
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def supervisor_accept_order(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        supervisor = resp['data']
        cities = UserCities.query.filter_by(user_id=supervisor['id']).filter_by(
            role='supervisor').filter_by(deleted_at=None).all()

        id = []

        for city in cities:
            id.append(city.city_id)

        stores = Store.query.filter(Store.city_id.in_(
            id)).filter_by(deleted_at=None).all()

        if stores:
            order = ItemOrder.query.filter_by(id=data['order_id']).filter(ItemOrder.order_created != None).filter_by(
                deleted_at=None).filter_by(order_confirmed=None).filter_by(status=1).first()

            if order:
                
                item_order_lists = ItemOrderLists.query.filter_by(item_order_id = order.id).filter_by(deleted_at = None).all()
                out_of_stock_items = ""
                for item_order_list in item_order_lists:
                    item_variable = StoreItemVariable.query.filter_by(id = item_order_list.store_item_variable_id).first()
                    if item_variable.stock < item_order_list.quantity:
                        out_of_stock_items = out_of_stock_items + f"Only {item_variable.stock} number of {item_order_list.product_name} is available in inventory where as {item_order_list.quantity} ordered, "
                
                if out_of_stock_items != "":
                    msg = out_of_stock_items[:-1]
                    error = ApiResponse(
                            False, msg, None)
                    return error.__dict__, 400

                if order.walk_in_order == 1:
                    error = ApiResponse(
                        False, "Can't change Walk in Order Status", None)
                    return error.__dict__, 400

                order.order_confirmed = datetime.datetime.utcnow()
                order.updated_at = datetime.datetime.utcnow()
                order.status = 1
                save_db(order, "Order")
                

                item_order_lists = ItemOrderLists.query.filter_by(
                    user_id=data['user_id']).filter_by(deleted_at=None).all()

                for item in item_order_lists:
                    store_item_var = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                    store_item_var.stock -= item.quantity
                    save_db(store_item_var, 'Store Item Variable')
                
                #user
                user = order.user
                store = order.store
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_accept',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(user, notification_data)
                
                #merchant
                
                store = order.store
                store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_by = None).first()
                
                merchant = store_merchant.merchant
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_accept',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(merchant, notification_data)
                
                apiresponse = ApiResponse(
                    True, "Order Accepted Successfully", None, None)
                return apiresponse.__dict__, 200

            apiresponse = ApiResponse(
                False, "Order can't be modified in it's current state.", None, 'Store is not linke')
            return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Store is not linked with supervisor id')
            return apiresponse.__dict__, 400

    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured", None, str(e))
        return apiresponse.__dict__, 500

def supervisor_reject_order(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        supervisor = resp['data']
        cities = UserCities.query.filter_by(user_id=supervisor['id']).filter_by(
            role='supervisor').filter_by(deleted_at=None).all()

        id = []

        for city in cities:
            id.append(city.city_id)

        stores = Store.query.filter(Store.city_id.in_(
            id)).filter_by(deleted_at=None).all()

        if stores:
            order = ItemOrder.query.filter_by(id=data['order_id']).filter(ItemOrder.order_created != None).filter_by(
                deleted_at=None).filter_by(order_confirmed=None).filter_by(status=1).filter_by(order_confirmed=None).first()

            if order:
                if order.walk_in_order == 1:
                    error = ApiResponse(
                        False, "Can't change Walk in Order Status", None)
                    return error.__dict__, 400

                order.status = 10
                order.removed_by_role = "supervisor"
                order.removed_by_role_id = supervisor['id']
                order.updated_at = datetime.datetime.utcnow()
                save_db(order, "Order")
                
                item_order_lists = ItemOrderLists.query.filter_by(item_order_id = order.id).filter_by(deleted_at=None).all()
                
                for item in item_order_lists:
                    item.status = 10
                    item.updated_at = datetime.datetime.utcnow()
                    store_item_var = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                    store_item_var.stock += item.quantity
                    save_db(item)
                    save_db(store_item_var)
                    
                #user
                user = order.user
                store = order.store
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_reject',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(user, notification_data)
                
                #merchant
                
                store = order.store
                store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_by = None).first()
                
                merchant = store_merchant.merchant
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_reject',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(merchant, notification_data)
                
                apiresponse = ApiResponse(
                    True, "Order Accepted Successfully", None, None)
                return apiresponse.__dict__, 200

            apiresponse = ApiResponse(
                False, "Order can't be rejected in it's current state.", None, 'Store is not linke')
            return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Store is not linked with supervisor id')
            return apiresponse.__dict__, 400

    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured", None, str(e))
        return apiresponse.__dict__, 500

def supervisor_cancel_order(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        supervisor = resp['data']
        cities = UserCities.query.filter_by(user_id=supervisor['id']).filter_by(
            role='supervisor').filter_by(deleted_at=None).all()

        id = []

        for city in cities:
            id.append(city.city_id)

        stores = Store.query.filter(Store.city_id.in_(
            id)).filter_by(deleted_at=None).all()

        if stores:
            order = ItemOrder.query.filter_by(id=data['order_id']).filter(ItemOrder.order_created != None).filter_by(
                deleted_at=None).filter(ItemOrder.order_confirmed != None).filter_by(status=1).first()

            if order:

                if order.walk_in_order == 1:
                    error = ApiResponse(
                        False, "Can't change Walk in Order Status", None)
                    return error.__dict__, 400

                if not order.order_deliverd:
                    apiresponse = ApiResponse(False, "Order Delivered can not be cancelled in it now.",
                                              None, "Order can't be cancelled in it's current state.")
                    return apiresponse.__dict__, 400

                order.status = 11
                order.canceled_by_role = "supervisor"
                order.canceled_by_id = supervisor['id']
                order.updated_at = datetime.datetime.utcnow()
                save_db(order, "Order")
                

                item_order_lists = ItemOrderLists.query.filter_by(item_order_id = order.id).filter_by(deleted_at=None).all()

                for item in item_order_lists:

                    item.status = 11
                    item.updated_at = datetime.datetime.utcnow()
                    store_item_var = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                    store_item_var.stock += item.quantity
                    save_db(item)
                    save_db(store_item_var, 'Store Item Variable')
                    

                #user
                user = order.user
                store = order.store
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_cancel',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(user, notification_data)
                
                #merchant
                
                store = order.store
                store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_by = None).first()
                
                merchant = store_merchant.merchant
                
                notification_data = {
                    'store_name': store.name,
                    'template_name': 'order_cancel',
                    'order_id': str(order.id),
                    'role': 'Supervisor'
                        
                }
                   
                CreateNotification.gen_notification_v2(merchant, notification_data)
                
                apiresponse = ApiResponse(
                    True, "Order Cancelled Successfully", None, None)
                return apiresponse.__dict__, 200

            apiresponse = ApiResponse(False, "Order can't be cancelled in it's current state.",
                                      None, "Order can't be cancelled in it's current state.")
            return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Store is not linked with supervisor id')
            return apiresponse.__dict__, 400

    except Exception as e:
        apiresponse = ApiResponse(False, "Error Occured", None, str(e))
        return apiresponse.__dict__, 500
 
## Admin orders related functions

def show_all_order_admin():
    try:
        resp, status = Auth.get_logged_in_user(request)
        merchant = resp['data']
        try:
            page_no = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        try:
            query = request.args.get('id')
        except Exception:
            query = ""

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400

        if query:
            query = f'{query}%'
            item_orders = ItemOrder.query.filter(cast(ItemOrder.id, String).like(query)).filter(ItemOrder.order_created != None).filter(ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)
        else:
            item_orders = ItemOrder.query.filter(ItemOrder.order_created != None).filter(ItemOrder.deleted_at == None).order_by(ItemOrder.order_created.desc()).paginate(page_no, item_per_page, False)

        if item_orders:
            item_order_object = []

            for item_order in item_orders.items:

                store = Store.query.filter_by(id=item_order.store_id).first()
                if item_order.walk_in_order == None or item_order.walk_in_order == 0:
                    user = User.query.filter_by(
                        id=item_order.user_id).first()
                else:
                    user = Merchant.query.filter_by(
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
                    # #'initial_paid': item_order.initial_paid,
                    'order_created': str(item_order.order_created) if item_order.order_created else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                    'ready_to_pack':  str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                    'order_paid':  str(item_order.order_paid) if item_order.order_paid else None,
                    'order_pickedup':  str(item_order.order_pickedup) if item_order.order_pickedup else None,
                    'order_delivered':  str(item_order.order_delivered) if item_order.order_delivered else None,
                    # 'delivery_date':str(item_order.delivery_date),
                    # 'user_address_id': item_order.user_address_id,
                    # 'delivery_slot_id': item_order.delivery_slot_id,
                    # 'da_id': item_order.da_id,
                    'walkin_order': item_order.walk_in_order,
                    'status': item_order.status,
                    # 'merchant_transfer_at': item_order.merchant_transfer_at,
                    # 'merchant_txnid': item_order.merchant_txnid,
                    # 'txnid': item_order.txnid,
                    # 'gateway': item_order.gateway,
                    # 'transaction_status': item_order.transaction_status,
                    # 'cancelled_by': item_order.cancelled_by,
                    # 'created_at': str(item_order.created_at),
                    'updated_at': str(item_order.updated_at) if item_order.updated_at else None,
                    # 'deleted_at': str(item_order.deleted_at),
                }
                item_order_object.append(data)

            return_obj = {
                'page': item_orders.page,
                'total_pages': item_orders.pages,
                'has_next_page': item_orders.has_next,
                'has_prev_page': item_orders.has_prev,
                'prev_page': item_orders.prev_num,
                'next_page': item_orders.next_num,
                'prev_page_url': ENDPOINT_PREFIX + url_for('api.Superadmin Order_show_orders', page=item_orders.prev_num) if item_orders.has_prev else None,
                'next_page_url': ENDPOINT_PREFIX + url_for('api.Superadmin Order_show_orders', page=item_orders.next_num) if item_orders.has_next else None,
                'current_page_url': ENDPOINT_PREFIX + url_for('api.Superadmin Order_show_orders', page=page_no),
                'items_per_page': item_orders.per_page,
                'items_current_page': len(item_orders.items),
                'total_items': item_orders.total,
                'items': item_order_object
            }

            apiresponse = ApiResponse(
                True, "Data Loaded Succesfully", return_obj, None)
            return apiresponse.__dict__, 200

        else:
            apiresponse = ApiResponse(True, "No Data Found", None, None)
            return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def get_orders_by_id_admin(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        item_order_id = data['item_order_id']
        # try:
        #     id = re.search(r"\d+(\.\d+)?", item_order_id)
        #     id = int(id.group(0))

        # except Exception as e:
        #     apiResponce = ApiResponse(
        #     False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
        #     return (apiResponce.__dict__), 400
        # item_order_id = id

        item_order = ItemOrder.query.filter_by(
            id=item_order_id).filter_by(deleted_at=None).first()
        if not item_order.order_created:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, f'order id {item_order_id} not created yet')
            return (apiResponce.__dict__), 400

        #item_order = ItemOrder.query.filter(ItemOrder.id == item_order_id,ItemOrder.deleted_at == None).first()

        if item_order:
            # if item_order.user_id != user_id:
            #     apiResponce = ApiResponse(
            #         False, 'User have No access to See this Order', None, 'User_id not matched with Order User_id')
            #     return (apiResponce.__dict__), 401

            if item_order.order_created:

                # resp, status = Auth.get_logged_in_user(request)
                # merchant = resp['data']
                # store = StoreMerchant.query.filter_by(StoreMerchant.deleted_at == None).all()

                # if store.store_id == item_order.store_id:

                item_order_lists = ItemOrderLists.query.filter_by(
                    item_order_id=item_order_id).filter_by(deleted_at=None).order_by(ItemOrderLists.id).all()

                if item_order_lists:
                    item_order_list_object = []

                    for item in item_order_lists:

                        # store_item_variable = StoreItemVariable.query.filter_by(id = item.store_item_variable_id).first()

                        # if not store_item_variable:
                        #     apiResponce = ApiResponse(
                        #         False, f'store item variable {item.store_item_variable_id} not available', None,
                        #         f'store item variable {item.store_item_variable_id} not available')
                        #     return (apiResponce.__dict__), 400

                        # store_item = StoreItem.query.filter_by(id = item.store_item_id).filter_by(deleted_at = None).first()

                        # if not store_item:
                        #     apiResponce = ApiResponse(
                        #         False, f'store item {item.store_item_id} not available', None,
                        #         f'store item {item.store_item_id} not available')
                        #     return (apiResponce.__dict__), 400

                        quantity_unit = QuantityUnit.query.filter_by(
                            id=item.product_quantity_unit).first()

                        if not quantity_unit:
                            apiResponce = ApiResponse(
                                False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                                f'quantity unit {QuantityUnit} not available in QuantityUnit')
                            return (apiResponce.__dict__), 400

                        orderd_item = {
                            'id': item.id,
                            'store_item_name': item.product_name,
                            'store_item_brand_name': item.product_brand_name,
                            'store_item_image': item.product_image,
                            'store_item_variable_quantity': item.product_quantity,
                            'quantity_unit_name': quantity_unit.name,
                            'quantity_unit_short_name': quantity_unit.short_name,
                            'quantity_unit_conversion': quantity_unit.conversion,
                            'quantity_unit_type_details': quantity_unit.type_details,
                            'store_item_variable_mrp': item.product_mrp,
                            'store_item_variable_selling_price': item.product_selling_price,
                            'item_total_cost': item.product_selling_price * item.quantity,
                            'product_packaged': item.product_packaged,
                            'quantity': item.quantity,
                            'removed_by': item.removed_by,
                            'status': item.status,
                        }
                        item_order_list_object.append(orderd_item)

                    tax_object = []
                    item_order_taxes = ItemOrderTax.query.filter_by(
                            item_order_id=item_order.id).filter_by(deleted_at = None).all()

                    for item_order_tax in item_order_taxes:
                        if item_order_tax.tax_type == 1:
                            taxtype = "Percentage"
                        else:
                            taxtype = "Flat"

                        tax_data = {
                            'tax_id': item_order_tax.id,
                            'tax_name': item_order_tax.tax_name,
                            'tax_type': taxtype,
                            'amount': item_order_tax.amount,
                            'calculated': item_order_tax.calculated,
                        }

                        tax_object.append(tax_data)

                    tax_details = {
                        'total_tax': item_order.total_tax,
                        'tax_details': tax_object
                    }
                    store = Store.query.filter_by(
                        id=item_order.store_id).first()
                    user = User.query.filter_by(id=item_order.user_id).first()
                    user_address = UserAddress.query.filter_by(
                        id=item_order.user_address_id).first()
                    
                    
                    coupon_name = None
                    if item_order.coupon_id:
                        coupon = item_order.coupon
                        coupon_name = coupon.name
                        
                    data = {
                        'order_id': item_order.id,
                        'slug': item_order.slug,
                        # 'user_id': item_order.user_id,
                        'user_name': user.name,
                        "address_1": user_address.address1,
                        "address_2": user_address.address2,
                        "address_3": user_address.address3,
                        "landmark": user_address.landmark,
                        "phone": user_address.phone,
                        "latitude": user_address.latitude,
                        "longitude": user_address.longitude,
                        'order_total': item_order.order_total,
                        # 'slug': item_order.slug,
                        'store_id': item_order.store_id,
                        'store_name': store.name,
                        'coupon_name': coupon_name,
                        'order_total_discount': item_order.order_total_discount,
                        'final_order_total': item_order.final_order_total,
                        'delivery_fee': item_order.delivery_fee,
                        'grand_order_total': item_order.grand_order_total,
                        # #'initial_paid': item_order.initial_paid,
                        'order_created': str(item_order.order_created) if item_order.order_created else None,
                        'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                        'ready_to_pack':  str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                        'order_paid':  str(item_order.order_paid) if item_order.order_paid else None,
                        'order_pickedup':  str(item_order.order_pickedup) if item_order.order_pickedup else None,
                        'order_delivered':  str(item_order.order_delivered) if item_order.order_delivered else None,
                        'delivery_date': str(item_order.delivery_date) if item_order.delivery_date else None,
                        # 'user_address_id': item_order.user_address_id,
                        # 'delivery_slot_id': item_order.delivery_slot_id,
                        # 'da_id': item_order.da_id,
                        'walkin_order': item_order.walk_in_order,
                        'status': item_order.status,
                        # 'merchant_transfer_at': item_order.merchant_transfer_at,
                        # 'merchant_txnid': item_order.merchant_txnid,
                        # 'txnid': item_order.txnid,
                        # 'gateway': item_order.gateway,
                        # 'transaction_status': item_order.transaction_status,
                        # 'cancelled_by': item_order.cancelled_by,
                        # 'created_at': str(item_order.created_at),
                        'updated_at': str(item_order.updated_at) if item_order.updated_at else None,
                        # 'deleted_at': str(item_order.deleted_at),
                        'items': item_order_list_object,
                        'tax': tax_details
                    }

                    apiresponse = ApiResponse(
                        True, "Data Loaded Succesfully", data, None)
                    return apiresponse.__dict__, 200

                else:
                    apiresponse = ApiResponse(
                        True, "No Data Found", None, None)
                    return apiresponse.__dict__, 200

                # else:
                # #     #blacklist merchant or not?
                # #     # token = request.headers.get('Authorization')
                # #     # blacklist_token = BlacklistToken(token=token)
                # #     # try:
                # #     #     # insert the token
                # #     #     db.session.add(blacklist_token)
                # #     #     db.session.commit()
                # #     # except:
                # #     #     db.session.rollback()

                #     apiresponse = ApiResponse(False, "Merchant has no access to view this order", None , 'Merchant store_id and order item store_id is different')
                #     return apiresponse.__dict__ , 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def cancel_order_admin(data):
    try:

        item_order = ItemOrder.query.filter_by(id=data['item_order_id']).filter_by(deleted_at = None).first()

        if item_order:

            if item_order.walk_in_order == 1:
                error = ApiResponse(
                    False, "Can't change Walk in Order Status", None)
                return error.__dict__, 400

            if item_order.order_created:

                if item_order.status != 10:

                    if item_order.order_confirmed:

                        if item_order.status != 11:

                            resp, status = Auth.get_logged_in_user(request)
                            user = resp['data']

                            admin = False

                            if user['role'] == 'super_admin' or user['role'] == 'admin':
                                admin = True

                            if admin:

                                item_order_lists = ItemOrderLists.query.filter_by(
                                    item_order_id=data['item_order_id']).filter_by(deleted_at=None).all()

                                for item in item_order_lists:

                                    item.status = 11
                                    item.updated_at = datetime.datetime.utcnow()
                                    store_item_var = StoreItemVariable.query.filter_by(
                                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()
                                    store_item_var.stock += item.quantity
                                    save_db(store_item_var,
                                            'Store Item Variable')
                                    
                                    # item.deleted_at = datetime.datetime.utcnow()

                                    try:
                                        db.session.add(item)
                                        db.session.commit()

                                    except Exception as e:
                                        db.session.rollback()
                                        error = ApiResponse(
                                            False, 'Error Occured', None, "ItemOrderList Database error: "+str(e))
                                        return (error.__dict__), 500

                                item_order.status = 11
                                item_order.updated_at = datetime.datetime.utcnow()
                                # item_order.deleted_at = datetime.datetime.utcnow()
                                # item_order.canceled_by = user['id']
                                item_order.canceled_by_id = user['id']
                                item_order.canceled_by_role = user['role']

                                try:

                                    db.session.add(item_order)
                                    db.session.commit()

                                except Exception as e:
                                    db.session.rollback()
                                    error = ApiResponse(
                                        False, 'Error Occured', None, "ItemOrders Database error: "+str(e))
                                    return (error.__dict__), 500

                                
                                #merchant   
                                store = Store.query.filter_by(id= item_order.store_id).filter_by(deleted_at=None).first()                  
                                #store = item_order.store
                                store_merchant = Store.query.filter_by(id = store.id).filter_by(deleted_at = None).first()
                                merchant = Merchant.query.filter_by(id = store_merchant.merchant_id).first()
                                                                                                         
                                notification_data = {
                                    'store_name': store.name,
                                    'template_name': 'order_cancel',
                                    'order_id': str(item_order.id),
                                    'role': user['role'].capitalize()
                                }
                                CreateNotification.gen_notification_v2(merchant, notification_data)

                                #user
                                reciepent = item_order.user
                                notification_data = {
                                    'store_name': store.name,
                                    'template_name': 'order_cancel',
                                    'order_id': str(item_order.id),
                                    'role': user['role'].capitalize()
                                }
                                CreateNotification.gen_notification_v2(reciepent, notification_data)


                                apiresponse = ApiResponse(
                                    True, "Order Canceled Successfully", None, None)
                                return apiresponse.__dict__, 200

                            else:
                                # blacklist merchant or not?
                                # token = request.headers.get('Authorization')
                                # blacklist_token = BlacklistToken(token=token)
                                # try:
                                #     # insert the token
                                #     db.session.add(blacklist_token)
                                #     db.session.commit()
                                # except:
                                #     db.session.rollback()

                                apiresponse = ApiResponse(
                                    False, "Merchant has no access to view this order", None, 'Merchant store_id and order item store_id is different')
                                return apiresponse.__dict__, 400

                        else:
                            apiresponse = ApiResponse(
                                False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                            return apiresponse.__dict__, 400

                    else:
                        apiresponse = ApiResponse(
                            False, "Order is not Accepted Yet", None, "Order is not confirmed")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order is Allready Rejected", None, "'Order Status code is Rejected'")
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Either Order id Wrong or Order is not created yet')
            return apiresponse.__dict__, 400

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500


## USER LOGS

def get_supervisor_user_logs(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        if user['role'] == 'supervisor':

            search_string = data['search_number']
            # cities = UserCities.query.filter_by(user_id=user['id']).filter_by(
            #     role='supervisor').filter_by(deleted_at=None)
            #
            # id = []
            #
            # for city in cities:
            #     id.append(city.city_id)
            supervisor = Supervisor.query.filter_by(id=user_id).filter_by(deleted_at=None).first()

            if supervisor.id != user_id:
                error = ApiResponse(
                    False, "not a valid user to perform this action.", None)
                return error.__dict__, 400

            search_user = User.query.filter_by(phone=search_string).filter_by(deleted_at=None).first()
            if not search_user:
                error = ApiResponse(
                    False, f"no user found with {search_string}", None)
                return error.__dict__, 400
            user_address = UserAddress.query.filter_by(user_id=search_user.id).filter(
                UserAddress.city_id != None).filter_by(deleted_at=None)
            search_user_city = []
            for user_add in user_address:
                search_user_city.append(user_add.city_id)

            supervisor_cities = UserCities.query.filter_by(user_id=user_id).filter_by(deleted_at=None).filter_by(
                role='supervisor')
            if not supervisor_cities:
                error = ApiResponse(
                    False, f"no city_id found with {search_string}", None)
                return error.__dict__, 400

            supervisor_cities_id = []
            for supervisor_city in supervisor_cities:
                supervisor_cities_id.append(supervisor_city.city_id)

            check = any(item in search_user_city for item in supervisor_cities_id)
            if check is False:
                error = ApiResponse(
                    False, f"{search_string} not belong to the supervisor", None)
                return error.__dict__, 400

            # search_string = data['search_number']

            user_details = {
                "name": search_user.name,
                "phone_varified_at": str(search_user.phone_verified_at),
                "email": search_user.email,
                "role": search_user.role
            }
            search_user_id = search_user.id
            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created=None).filter_by(
                deleted_at=None)

            if not item_orders:
                error = ApiResponse(False, 'User Data Can not be fetched', None,
                                    'Cart Not Found')
                return (error.__dict__), 400
            cart_data = []
            for item_order in item_orders:

                store = Store.query.filter_by(
                    id=item_order.store_id).filter_by(deleted_at=None).first()
                if not store:
                    continue

                items = ItemOrderLists.query.filter_by(
                    item_order_id=item_order.id).filter_by(deleted_at=None).all()

                if not items:
                    continue
                cart_items = []
                for item in items:

                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).filter_by(deleted_at=None).first()

                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity_unit = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()

                    obj = {
                        'item_order_list_id': item.id,
                        'product_in_cart_quantity': item.quantity,
                        'item_brand_name': store_item.brand_name,
                        'item_brand_url': store_item.image,
                        'item_name': store_item.name,
                        'item_variable_id': item.store_item_variable_id,
                        'item_variable': {
                            'id': store_item_variable.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': store_item_variable.quantity,
                            'quantity_unit': quantity_unit.name,
                            'quantity_short_name': quantity_unit.short_name
                        }
                    }
                    cart_items.append(obj)
                cart_details = {
                    'id': item_order.store_id,
                    'item_order_id': item_order.id,
                    'order_total': item_order.order_total,
                    'final_order_total': item_order.final_order_total,
                    'grand_order_total': item_order.grand_order_total,
                    'item_order_list': cart_items
                }
                cart_data.append(cart_details)

            ################# for Deleted Items ###############################
            sessions = Session.query.filter_by(user_id=search_user_id).filter_by(deleted_at=None)
            session_details = []
            for session in sessions:
                session_details.append(str(session.session_start_time))

            ###########################order details##############################

            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter(
                ItemOrder.order_created != None).order_by(ItemOrder.id.desc())

            order_list = []
            for item_order in item_orders:
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                item_order_lists = ItemOrderLists.query.filter_by(item_order_id=item_order.id).filter_by(
                    deleted_at=None)
                item_object = []
                for item in item_order_lists:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                        item_object.append(data)

                store = Store.query.filter_by(id=item_order.store_id).first()
                response = {
                    'cart_id': item_order.id,
                    'store_name': store.name,
                    'store_id': store.id,
                    'COD': bool(store.pay_later),
                    'order_total': item_order.order_total,
                    'final_order_total': item_order.final_order_total,
                    'grand_order_total': item_order.grand_order_total,
                    'created_on': str(item_order.order_created) if item_order.order_created else None,
                    "remove_by": item_order.remove_by_role,
                    "cancel_by": item_order.cancelled_by_role,
                    "status": item_order.status,
                    'items': item_object,
                    'order_created': str(item_order.order_created) if item_order.order_created != None else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed != None else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack != None else None,
                    'order_paid': str(item_order.order_paid) if item_order.order_paid != None else None,
                    'order_picked': str(item_order.order_pickedup) if item_order.order_pickedup != None else None,
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered != None else None
                }
                order_list.append(response)

            record = []
            ################################### for cancel order ##############################
            cancel_item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created=None).filter(
                ItemOrder.deleted_at != None).order_by(ItemOrder.id.desc())
            cancel_order_list = []

            for item_order in cancel_item_orders:
                items = ItemOrderLists.query.filter_by(item_order_id=item_order.id).order_by(ItemOrderLists.id).all()
                item_object = []
                for item in items:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                        item_object.append(data)
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                recordObject = {
                    'id': item_order.id,
                    'user_id': user_id,
                    'order_total': item_order.order_total,
                    'slug': item_order.slug,
                    'store_id': item_order.store_id,
                    'coupon_id': item_order.coupon_id,
                    'order_total_discount': item_order.order_total_discount,
                    'final_order_total': item_order.final_order_total,
                    'delivery_fee': item_order.delivery_fee,
                    'grand_order_total': item_order.grand_order_total,
                    #'initial_paid': item_order.initial_paid,
                    'order_created': str(item_order.order_created) if item_order.order_created else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                    'order_paid': if_date(item_order.order_paid),
                    'order_pickedup': str(item_order.order_pickedup),
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered else None,
                    'user_address_id': item_order.user_address_id,
                    'delivery_date': str(item_order.delivery_date) if item_order.delivery_date else None,
                    'delivery_slot_id': item_order.delivery_slot_id,
                    'da_id': item_order.da_id,
                    'status': item_order.status,
                    'merchant_transfer_at': str(
                        item_order.merchant_transfer_at) if item_order.merchant_transfer_at else None,
                    'merchant_txnid':item_order.merchant_txnid,
                    'txnid': item_order.txnid,
                    'gateway': item_order.gateway,
                    'transaction_status': item_order.transaction_status,
                    'cancelled_by': item_order.cancelled_by_id,
                    'cancelled_by_role': item_order.cancelled_by_role,
                    'created_at': str(item_order.created_at) if item_order.created_at != None else None,
                    'updated_at': str(item_order.updated_at) if item_order.updated_at != None else None,
                    'deleted_at': str(item_order.deleted_at) if item_order.deleted_at != None else None,
                    'item_list': item_object,
                    'store_data': {
                        'id': store.id,
                        'name': store.name,
                        'slug': store.slug,
                        'owner_name': store.owner_name,
                        'shopkeeper_name': store.shopkeeper_name,
                        'image': store.image,
                        'address_line_1': store.address_line_1,
                        'address_line_2': store.address_line_2,
                        'store_latitude': store.store_latitude,
                        'store_longitude': store.store_longitude,
                        'pay_later': store.pay_later,
                        'delivery_mode': store.delivery_mode,
                        'delivery_start_time': str(
                            store.delivery_start_time) if store.delivery_start_time != None else None,
                        'delivery_end_time': str(store.delivery_end_time) if store.delivery_end_time != None else None,
                        'radius': store.radius,
                        'status': store.status
                    }
                }
                cancel_order_list.append(recordObject)

            recordObject = {
                'user_details': user_details,
                'cart_details': cart_data,
                'session_details': session_details,
                'order_details': order_list,
                'discarded_order_details': cancel_order_list

            }
            # for row in user:
            #     recordObject = {
            #         'user_details': user_details,
            #         'cart_details': cart_data
            #
            #     }
            record.append(recordObject)

            apiResponse = ApiResponse(True, "user log fetched successfully.", record, None)
            return apiResponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'something went wrong',
                            None, str(e))
        return (error.__dict__), 500

def get_user_logs(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        if user['role'] == 'supervisor':

            search_string = data['search_number']
            # cities = UserCities.query.filter_by(user_id=user['id']).filter_by(
            #     role='supervisor').filter_by(deleted_at=None)
            #
            # id = []
            #
            # for city in cities:
            #     id.append(city.city_id)
            supervisor = Supervisor.query.filter_by(id=user_id).filter_by(deleted_at=None).first()

            if supervisor.id != user_id:
                error = ApiResponse(
                    False, "not a valid user to perform this action.", None)
                return error.__dict__, 400

            search_user = User.query.filter_by(phone=search_string).filter_by(deleted_at=None).first()
            if not search_user:
                error = ApiResponse(
                    False, f"no user found with {search_string}", None)
                return error.__dict__, 400
            user_address = UserAddress.query.filter_by(user_id=search_user.id).filter(UserAddress.city_id!=None).filter_by(deleted_at=None)
            search_user_city = []
            for user_add in user_address:
                search_user_city.append(user_add.city_id)

            supervisor_cities = UserCities.query.filter_by(user_id=user_id).filter_by(deleted_at=None).filter_by(role='supervisor')
            if not supervisor_cities:
                error = ApiResponse(
                    False, f"no city_id found with {search_string}", None)
                return error.__dict__, 400

            supervisor_cities_id = []
            for supervisor_city in supervisor_cities:
                supervisor_cities_id.append(supervisor_city.city_id)

            check = any(item in search_user_city for item in supervisor_cities_id)
            if check is False:
                error = ApiResponse(
                    False, f"{search_string} not belong to the supervisor", None)
                return error.__dict__, 400

            # search_string = data['search_number']

            user_details = {
                "name": search_user.name,
                "phone_varified_at": str(search_user.phone_verified_at),
                "email": search_user.email,
                "role": search_user.role
            }
            search_user_id = search_user.id
            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created=None).filter_by(
                deleted_at=None)

            if not item_orders:
                error = ApiResponse(False, 'User Data Can not be fetched', None,
                                    'Cart Not Found')
                return (error.__dict__), 400
            cart_data = []
            for item_order in item_orders:

                store = Store.query.filter_by(
                    id=item_order.store_id).filter_by(deleted_at=None).first()
                if not store:
                    continue

                items = ItemOrderLists.query.filter_by(
                    item_order_id=item_order.id).filter_by(deleted_at=None).all()

                if not items:
                    continue
                cart_items = []
                for item in items:

                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).filter_by(deleted_at=None).first()

                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity_unit = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()

                    obj = {
                        'item_order_list_id': item.id,
                        'product_in_cart_quantity': item.quantity,
                        'item_brand_name': store_item.brand_name,
                        'item_brand_url': store_item.image,
                        'item_name': store_item.name,
                        'item_variable_id': item.store_item_variable_id,
                        'item_variable': {
                            'id': store_item_variable.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': store_item_variable.quantity,
                            'quantity_unit': quantity_unit.name,
                            'quantity_short_name': quantity_unit.short_name
                        }
                    }
                    cart_items.append(obj)
                cart_details = {
                    'id': item_order.store_id,
                    'item_order_id': item_order.id,
                    'order_total': item_order.order_total,
                    'final_order_total': item_order.final_order_total,
                    'grand_order_total': item_order.grand_order_total,
                    'item_order_list': cart_items
                }
                cart_data.append(cart_details)

            ################# for Deleted Items ###############################
            sessions = Session.query.filter_by(user_id=search_user_id).filter_by(deleted_at=None)
            session_details = []
            for session in sessions:
                session_details.append(str(session.session_start_time))

            ###########################order details##############################

            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter(
                ItemOrder.order_created != None).order_by(ItemOrder.id.desc())

            order_list = []
            for item_order in item_orders:
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                item_order_lists = ItemOrderLists.query.filter_by(item_order_id=item_order.id).filter_by(
                    deleted_at=None)
                item_object = []
                for item in item_order_lists:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                        item_object.append(data)

                store = Store.query.filter_by(id=item_order.store_id).first()
                response = {
                    'cart_id': item_order.id,
                    'store_name': store.name,
                    'store_id': store.id,
                    'COD': bool(store.pay_later),
                    'order_total': item_order.order_total,
                    'final_order_total': item_order.final_order_total,
                    'grand_order_total': item_order.grand_order_total,
                    'created_on': str(item_order.order_created) if item_order.order_created else None,
                    "remove_by": item_order.remove_by_role,
                    "cancel_by": item_order.cancelled_by_role,
                    "status": item_order.status,
                    'items': item_object,
                    'order_created': str(item_order.order_created) if item_order.order_created != None else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed != None else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack != None else None,
                    'order_paid': str(item_order.order_paid) if item_order.order_paid != None else None,
                    'order_picked': str(item_order.order_pickedup) if item_order.order_pickedup != None else None,
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered != None else None
                }
                order_list.append(response)

            record = []
            ################################### for cancel order ##############################
            cancel_item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created=None).filter(
                ItemOrder.deleted_at != None).order_by(ItemOrder.id.desc())
            cancel_order_list = []

            for item_order in cancel_item_orders:
                items = ItemOrderLists.query.filter_by(item_order_id=item_order.id).order_by(ItemOrderLists.id).all()
                item_object = []
                for item in items:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                        item_object.append(data)
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                recordObject = {
                    'id': item_order.id,
                    'user_id': user_id,
                    'order_total': item_order.order_total,
                    'slug': item_order.slug,
                    'store_id': item_order.store_id,
                    'coupon_id': item_order.coupon_id,
                    'order_total_discount': item_order.order_total_discount,
                    'final_order_total': item_order.final_order_total,
                    'delivery_fee': item_order.delivery_fee,
                    'grand_order_total': item_order.grand_order_total,
                    ##'initial_paid': item_order.initial_paid,
                    'order_created': str(item_order.order_created) if item_order.order_created else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                    'order_paid': if_date(item_order.order_paid),
                    'order_pickedup': str(item_order.order_pickedup),
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered else None,
                    'user_address_id': item_order.user_address_id,
                    'delivery_date': str(item_order.delivery_date) if item_order.delivery_date else None,
                    'delivery_slot_id': item_order.delivery_slot_id,
                    'da_id': item_order.da_id,
                    'status': item_order.status,
                    'merchant_transfer_at': str(item_order.merchant_transfer_at) if item_order.merchant_transfer_at else None,
                    'merchant_txnid': item_order.merchant_txnid,
                    'txnid': item_order.txnid,
                    'gateway': item_order.gateway,
                    'transaction_status': item_order.transaction_status,
                    'cancelled_by': item_order.cancelled_by_id,
                    'cancelled_by_role': item_order.cancelled_by_role,
                    'created_at': str(item_order.created_at) if item_order.created_at != None else None,
                    'updated_at': str(item_order.updated_at) if item_order.updated_at != None else None,
                    'deleted_at': str(item_order.deleted_at) if item_order.deleted_at != None else None,
                    'item_list': item_object,
                    'store_data': {
                        'id': store.id,
                        'name': store.name,
                        'slug': store.slug,
                        'owner_name': store.owner_name,
                        'shopkeeper_name': store.shopkeeper_name,
                        'image': store.image,
                        'address_line_1': store.address_line_1,
                        'address_line_2': store.address_line_2,
                        'store_latitude': store.store_latitude,
                        'store_longitude': store.store_longitude,
                        'pay_later': store.pay_later,
                        'delivery_mode': store.delivery_mode,
                        'delivery_start_time': str(
                            store.delivery_start_time) if store.delivery_start_time != None else None,
                        'delivery_end_time': str(store.delivery_end_time) if store.delivery_end_time != None else None,
                        'radius': store.radius,
                        'status': store.status
                    }
                }
                cancel_order_list.append(recordObject)

            recordObject = {
                'user_details': user_details,
                'cart_details': cart_data,
                'session_details': session_details,
                'order_details': order_list,
                'discarded_order_details': cancel_order_list

            }
            # for row in user:
            #     recordObject = {
            #         'user_details': user_details,
            #         'cart_details': cart_data
            #
            #     }
            record.append(recordObject)

            apiResponse = ApiResponse(True, "user log fetched successfully.", record, None)
            return apiResponse.__dict__, 200

        if user['role'] == "super_admin":
            search_string = data['search_string']
            super_admin = SuperAdmin.query.filter_by(id=user_id).filter_by(deleted_at=None).first()
            if super_admin.id != user_id:
                error = ApiResponse(
                    False, "not a valid user to perform this action.", None)
                return error.__dict__, 400

            user = User.query.filter_by(phone=search_string).filter_by(deleted_at=None).first()
            if not user:
                error = ApiResponse(
                    False, f"no user found with {search_string}", None)
                return error.__dict__, 400
            user_details = {
                "name": user.name,
                "phone_varified_at": str(user.phone_verified_at),
                "email": user.email,
                "role": user.role
            }
            search_user_id = user.id
            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created=None).filter_by(deleted_at=None)

            if not item_orders:
                error = ApiResponse(False, 'User Data Can not be fetched', None,
                                    'Cart Not Found')
                return (error.__dict__), 400
            cart_data = []
            for item_order in item_orders:

                store = Store.query.filter_by(
                    id=item_order.store_id).filter_by(deleted_at=None).first()
                if not store:
                    continue

                items = ItemOrderLists.query.filter_by(
                    item_order_id=item_order.id).filter_by(deleted_at=None).all()

                if not items:
                    continue
                cart_items = []
                for item in items:

                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).filter_by(deleted_at=None).first()

                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity_unit = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()

                    obj = {
                        'item_order_list_id': item.id,
                        'product_in_cart_quantity': item.quantity,
                        'item_brand_name': store_item.brand_name,
                        'item_brand_url': store_item.image,
                        'item_name': store_item.name,
                        'item_variable_id': item.store_item_variable_id,
                        'item_variable': {
                            'id': store_item_variable.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': store_item_variable.quantity,
                            'quantity_unit': quantity_unit.name,
                            'quantity_short_name': quantity_unit.short_name,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                    }
                    cart_items.append(obj)
                cart_details = {
                    'id': item_order.store_id,
                    'store_name': store.name,
                    'item_order_id': item_order.id,
                    'order_total': item_order.order_total,
                    'final_order_total': item_order.final_order_total,
                    'grand_order_total': item_order.grand_order_total,
                    'item_order_list': cart_items
                }
                cart_data.append(cart_details)

            ################# for Deleted Items ###############################
            sessions = Session.query.filter_by(user_id=search_user_id).filter_by(deleted_at=None)
            session_details = []
            for session in sessions:
                session_details.append(str(session.session_start_time))

            ###########################order details##############################

            item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter(
                ItemOrder.order_created != None).order_by(ItemOrder.id.desc())

            order_list = []
            for item_order in item_orders:
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                item_order_lists = ItemOrderLists.query.filter_by(item_order_id=item_order.id).filter_by(deleted_at=None)
                item_object = []
                for item in item_order_lists:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue
                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price' : store_item_variable.selling_price*item.quantity
                        }
                        item_object.append(data)

                store = Store.query.filter_by(id=item_order.store_id).first()
                response = {
                    'cart_id': item_order.id,
                    'store_name': store.name,
                    'store_id': store.id,
                    'COD': bool(store.pay_later),
                    'order_total': item_order.order_total,
                    'final_order_total':item_order.final_order_total,
                    'grand_order_total':item_order.grand_order_total,
                    'created_on': str(item_order.order_created),
                    "remove_by": item_order.remove_by_role,
                    "cancel_by": item_order.cancelled_by_role,
                    "status": item_order.status,
                    'items': item_object,
                    'order_created': str(item_order.order_created) if item_order.order_created != None else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed != None else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack != None else None,
                    'order_paid': str(item_order.order_paid) if item_order.order_paid != None else None,
                    'order_picked': str(item_order.order_pickedup) if item_order.order_pickedup != None else None,
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered != None else None
                }
                order_list.append(response)

            record = []
            ################################### for cancel order ##############################
            cancel_item_orders = ItemOrder.query.filter_by(user_id=search_user_id).filter_by(order_created = None).filter(ItemOrder.deleted_at != None).order_by(ItemOrder.id.desc())
            cancel_order_list = []

            for item_order in cancel_item_orders:
                items = ItemOrderLists.query.filter_by(item_order_id=item_order.id).order_by(ItemOrderLists.id).all()
                item_object = []
                for item in items:
                    store_item = StoreItem.query.filter_by(
                        id=item.store_item_id).first()
                    if not store_item:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    store_item_variable = StoreItemVariable.query.filter_by(
                        id=item.store_item_variable_id).filter_by(deleted_at=None).first()

                    if not store_item_variable:
                        item.deleted_at = datetime.datetime.utcnow()
                        continue

                    quantity = QuantityUnit.query.filter_by(
                        id=store_item_variable.quantity_unit).first()
                    if store_item_variable:
                        data = {
                            'id': item.id,
                            'product_mrp': store_item_variable.mrp,
                            'product_selling_price': store_item_variable.selling_price,
                            'quantity': item.quantity,
                            'item_variable_quantity': store_item_variable.quantity,
                            'item_variable_quantity_name': quantity.name,
                            'item_variable_quantity_short_name': quantity.short_name,
                            'item_brand_name': store_item.brand_name,
                            'item_image': store_item.image,
                            'item_name': store_item.name,
                            'item_variable_id': item.store_item_variable_id,
                            'store_item_id': item.store_item_id,
                            'item_price': store_item_variable.selling_price * item.quantity
                        }
                        item_object.append(data)
                store = Store.query.filter(Store.id == item_order.store_id).filter(Store.deleted_at == None).first()
                recordObject = {
                    'id': item_order.id,
                    'user_id': user_id,
                    'order_total': item_order.order_total,
                    'slug': item_order.slug,
                    'store_id': item_order.store_id,
                    'coupon_id': item_order.coupon_id,
                    'order_total_discount': item_order.order_total_discount,
                    'final_order_total': item_order.final_order_total,
                    'delivery_fee': item_order.delivery_fee,
                    'grand_order_total': item_order.grand_order_total,
                    #'initial_paid': item_order.initial_paid,
                    'order_created': str(item_order.order_created) if item_order.order_created else None,
                    'order_confirmed': str(item_order.order_confirmed) if item_order.order_confirmed else None,
                    'ready_to_pack': str(item_order.ready_to_pack) if item_order.ready_to_pack else None,
                    'order_paid': if_date(item_order.order_paid),
                    'order_pickedup': str(item_order.order_pickedup),
                    'order_delivered': str(item_order.order_delivered) if item_order.order_delivered else None,
                    'user_address_id': item_order.user_address_id,
                    'delivery_date': str(item_order.delivery_date) if item_order.delivery_date else None,
                    'delivery_slot_id': item_order.delivery_slot_id,
                    'da_id': item_order.da_id,
                    'status': item_order.status,
                    'merchant_transfer_at': str(item_order.merchant_transfer_at) if item_order.merchant_transfer_at else None,
                    'merchant_txnid': item_order.merchant_txnid,
                    'txnid': item_order.txnid,
                    'gateway': item_order.gateway,
                    'transaction_status': item_order.transaction_status,
                    'cancelled_by': item_order.cancelled_by_id,
                    'cancelled_by_role': item_order.cancelled_by_role,
                    'created_at': str(item_order.created_at) if item_order.created_at != None else None,
                    'updated_at': str(item_order.updated_at) if item_order.updated_at != None else None,
                    'deleted_at': str(item_order.deleted_at) if item_order.deleted_at != None else None,
                    'item_list': item_object,
                    'store_data': {
                        'id': store.id,
                        'name': store.name,
                        'slug': store.slug,
                        'owner_name': store.owner_name,
                        'shopkeeper_name': store.shopkeeper_name,
                        'image': store.image,
                        'address_line_1': store.address_line_1,
                        'address_line_2': store.address_line_2,
                        'store_latitude': store.store_latitude,
                        'store_longitude': store.store_longitude,
                        'pay_later': store.pay_later,
                        'delivery_mode': store.delivery_mode,
                        'delivery_start_time': str(
                            store.delivery_start_time) if store.delivery_start_time != None else None,
                        'delivery_end_time': str(store.delivery_end_time) if store.delivery_end_time != None else None,
                        'radius': store.radius,
                        'status': store.status
                    }
                }
                cancel_order_list.append(recordObject)

            recordObject = {
                'user_details': user_details,
                'cart_details': cart_data,
                'session_details': session_details,
                'order_details': order_list,
                'discarded_order_details': cancel_order_list

            }
            # for row in user:
            #     recordObject = {
            #         'user_details': user_details,
            #         'cart_details': cart_data
            #
            #     }
            record.append(recordObject)

            apiResponse = ApiResponse(True, "user log fetched successfully.", record[0], None)
            return apiResponse.__dict__, 200





    except Exception as e:
        error = ApiResponse(False, 'something went wrong',
                            None, str(e))
        return (error.__dict__), 500

## DISTRIBUTOR MODULE

def get_orders_distributor():
    """
    Returns all hub orders associated with the user (Distributor/Delivery Associate
    
    Return type: __dict__, Integer)
    """
    try:
        resp, status = Auth.get_logged_in_user(request)
        distributor = resp['data']        

        try:
            page_no = int(request.args.get('page'))
        except:
            page_no = 1
        try:
            item_per_page = int(request.args.get('item_per_page'))
        except:
            item_per_page = 10

        try:
            query = request.args.get('id')
        except Exception:
            query = None

        if item_per_page not in config.item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if page_no < 1:
            apiresponse = ApiResponse(False, "Wrong Page Number", None, None)
            return apiresponse.__dict__, 400
        
        if distributor['role'] == 'super_admin':
            hubs = Hub.query.filter_by(deleted_at = None).all()
        
        elif distributor['role'] == 'distributor':
            hubs = Hub.query.filter_by(
                distributor_id=distributor['id']).filter_by(deleted_at=None).all()
    
        elif distributor['role'] == 'delivery_associate':
            hub_das = HubDA.query.filter_by(
                delivery_associate_id=distributor['id']).filter_by(deleted_at=None).all()

            da_ids = []
            for hub in hub_das:
                da_ids.append(hub.delivery_associate_id)

            if not distributor['id'] in da_ids:
                apiResponce = ApiResponse(False, 'Delivery Associate has No access to See Hubs')
                return (apiResponce.__dict__), 403
            
            hub_id = []
            for hub in hub_das:
                hub_id.append(hub.hub_id)

            hubs = Hub.query.filter(Hub.id.in_(hub_id)).filter_by(deleted_at=None).filter_by(status=1).all()


        elif distributor['role'] == 'merchant':
            if query:
                query = f'{query}%'
                hub_orders = HubOrders.query.filter(cast(HubOrders.id, String).like(query)).filter(HubOrders.merchant_id == distributor['id']).filter(HubOrders.order_created != None).filter(HubOrders.deleted_at == None).order_by(HubOrders.order_created.desc()).paginate(page_no, item_per_page, False)
            else:
                hub_orders = HubOrders.query.filter(HubOrders.merchant_id == distributor['id']).filter(HubOrders.order_created != None).filter(
                HubOrders.deleted_at == None).order_by(HubOrders.order_created.desc()).paginate(page_no, item_per_page, False)

            if hub_orders.items:
                hub_order_object = []
                for hub_order in hub_orders.items:
                    
                    user = Merchant.query.filter_by(
                        id=hub_order.merchant_id).first()
                    
                    hub = Hub.query.filter_by(
                        id=hub_order.hub_id).first()

                    store = hub_order.store
                    store_city = store.city
                    #user = User.query.filter_by(id = item_order.user_id).first()
                    # user = User.query.filter_by(
                    #     id=item_order.user_id).first()

                    # if hub_order.da_id == 1:
                    #     self_delivery = 1
                    # else:
                    #     self_delivery = 0

                    data = {
                        'order_id': hub_order.id,
                        'merchant_name': user.name,
                        'merchant_store_name': store.name,
                        'merchant_store_city': store_city.name,
                        'order_total': hub_order.order_total,
                        # 'slug': hub_order.slug,
                        'hub_slug': hub.slug,
                        'hub_name': hub.name,
                        # 'coupon_id': hub_order.coupon_id,
                        # 'order_total_discount': hub_order.order_total_discount,
                        # 'final_order_total': hub_order.final_order_total,
                        # 'delivery_fee': hub_order.delivery_fee,
                        # 'grand_order_total': hub_order.grand_order_total,
                        # #'initial_paid': hub_order.initial_paid,
                        'order_created': str(hub_order.order_created) if hub_order.order_created else None,
                        'order_confirmed': str(hub_order.order_confirmed) if hub_order.order_confirmed else None,
                        'assigned_to_da':  str(hub_order.assigned_to_da) if hub_order.assigned_to_da else None,
                        # 'order_paid':  str(hub_order.order_paid) if hub_order.order_paid else None,
                        'order_pickedup':  str(hub_order.order_pickedup) if hub_order.order_pickedup else None,
                        'order_delivered':  str(hub_order.order_delivered) if hub_order.order_delivered else None,
                        'payment_status': hub_order.payment_status,
                        # 'delivery_date':str(hub_order.delivery_date),
                        # 'user_address_id': hub_order.user_address_id,
                        # 'delivery_slot_id': hub_order.delivery_slot_id,
                        # 'da_id': hub_order.da_id,
                        # 'walkin_order': hub_order.walk_in_order,
                        # 'self_delivery': self_delivery,
                        'status': hub_order.status,
                        # 'merchant_transfer_at': hub_order.merchant_transfer_at,
                        # 'merchant_txnid': hub_order.merchant_txnid,
                        # 'txnid': hub_order.txnid,
                        # 'gateway': hub_order.gateway,
                        # 'transaction_status': hub_order.transaction_status,
                        # 'cancelled_by': hub_order.cancelled_by,
                        # 'created_at': str(hub_order.created_at),
                        'updated_at': str(hub_order.updated_at) if hub_order.updated_at != None else None,
                        # 'deleted_at': str(hub_order.deleted_at)
                    }
                    hub_order_object.append(data)

                return_obj = {
                    'page': hub_orders.page,
                    'total_pages': hub_orders.pages,
                    'has_next_page': hub_orders.has_next,
                    'has_prev_page': hub_orders.has_prev,
                    'prev_page': hub_orders.prev_num,
                    'next_page': hub_orders.next_num,
                    'items_per_page': hub_orders.per_page,
                    'items_current_page': len(hub_orders.items),
                    'total_items': hub_orders.total,
                    'items': hub_order_object
                }

                apiresponse = ApiResponse(
                    True, "Data Loaded Succesfully", return_obj, None)
                return apiresponse.__dict__, 200

            else:
                apiresponse = ApiResponse(True, "No Orders Found", None, None)
                return apiresponse.__dict__, 200

    
        elif distributor['role'] == 'supervisor':
            supervisor_cities = UserCities.query.filter_by(user_id = distributor['id']).filter_by(deleted_at = None).all()
            city_ids = []
            for supervisor_city in supervisor_cities:
                city_ids.append(supervisor_city.city_id)

            hub = Hub.query.filter(Hub.city_id.in_(city_ids)).filter_by(deleted_at = None).all()
        
        else:
            apiresponse = ApiResponse(False, "User has no access", None, None)
            return apiresponse.__dict__, 403

        hub_ids = []

        if hubs:
            for hub in hubs:
                hub_ids.append(hub.id)

            if query:
                    query = f'{query}%'
                    hub_orders = HubOrders.query.filter(cast(HubOrders.id, String).like(query)).filter(HubOrders.hub_id.in_(hub_ids)).filter(HubOrders.order_created != None).filter(HubOrders.deleted_at == None).order_by(HubOrders.order_created.desc()).paginate(page_no, item_per_page, False)
            else:
                hub_orders = HubOrders.query.filter(HubOrders.hub_id.in_(hub_ids)).filter(HubOrders.order_created != None).filter(
                HubOrders.deleted_at == None).order_by(HubOrders.order_created.desc()).paginate(page_no, item_per_page, False)

            if hub_orders:
                hub_order_object = []
                for hub_order in hub_orders.items:
                    
                    user = Merchant.query.filter_by(
                        id=hub_order.merchant_id).first()
                    
                    hub = Hub.query.filter_by(
                        id=hub_order.hub_id).first()

                    store = hub_order.store
                    store_city = store.city
                    #user = User.query.filter_by(id = item_order.user_id).first()
                    # user = User.query.filter_by(
                    #     id=item_order.user_id).first()

                    # if hub_order.da_id == 1:
                    #     self_delivery = 1
                    # else:
                    #     self_delivery = 0

                    data = {
                        'order_id': hub_order.id,
                        'merchant_name': user.name,
                        'merchant_store_name': store.name,
                        'merchant_store_city': store_city.name,
                        'order_total': hub_order.order_total,
                        # 'slug': hub_order.slug,
                        'hub_slug': hub.slug,
                        'hub_name': hub.name,
                        # 'coupon_id': hub_order.coupon_id,
                        # 'order_total_discount': hub_order.order_total_discount,
                        # 'final_order_total': hub_order.final_order_total,
                        # 'delivery_fee': hub_order.delivery_fee,
                        # 'grand_order_total': hub_order.grand_order_total,
                        # #'initial_paid': hub_order.initial_paid,
                        'order_created': str(hub_order.order_created) if hub_order.order_created else None,
                        'order_confirmed': str(hub_order.order_confirmed) if hub_order.order_confirmed else None,
                        'assigned_to_da':  str(hub_order.assigned_to_da) if hub_order.assigned_to_da else None,
                        'merchant_confirmed': str(hub_order.merchant_confirmed) if hub_order.merchant_confirmed else None,
                        # 'order_paid':  str(hub_order.order_paid) if hub_order.order_paid else None,
                        'order_pickedup':  str(hub_order.order_pickedup) if hub_order.order_pickedup else None,
                        'order_delivered':  str(hub_order.order_delivered) if hub_order.order_delivered else None,
                        'payment_status': hub_order.payment_status,
                        # 'delivery_date':str(hub_order.delivery_date),
                        # 'user_address_id': hub_order.user_address_id,
                        # 'delivery_slot_id': hub_order.delivery_slot_id,
                        # 'da_id': hub_order.da_id,
                        # 'walkin_order': hub_order.walk_in_order,
                        # 'self_delivery': self_delivery,
                        'status': hub_order.status,
                        # 'merchant_transfer_at': hub_order.merchant_transfer_at,
                        # 'merchant_txnid': hub_order.merchant_txnid,
                        # 'txnid': hub_order.txnid,
                        # 'gateway': hub_order.gateway,
                        # 'transaction_status': hub_order.transaction_status,
                        # 'cancelled_by': hub_order.cancelled_by,
                        # 'created_at': str(hub_order.created_at),
                        'updated_at': str(hub_order.updated_at) if hub_order.updated_at != None else None,
                        # 'deleted_at': str(hub_order.deleted_at),
                    }
                    hub_order_object.append(data)

                return_obj = {
                    'page': hub_orders.page,
                    'total_pages': hub_orders.pages,
                    'has_next_page': hub_orders.has_next,
                    'has_prev_page': hub_orders.has_prev,
                    'prev_page': hub_orders.prev_num,
                    'next_page': hub_orders.next_num,
                    'items_per_page': hub_orders.per_page,
                    'items_current_page': len(hub_orders.items),
                    'total_items': hub_orders.total,
                    'items': hub_order_object
                }

                apiresponse = ApiResponse(
                    True, "Data Loaded Succesfully", return_obj, None)
                return apiresponse.__dict__, 200

            else:
                apiresponse = ApiResponse(True, "No Orders Found", None, None)
                return apiresponse.__dict__, 200
        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Hub is not linked with distributor id')
            return apiresponse.__dict__, 400
    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def get_order_details_distributor(data):
    """
    Returns the details of a specific order associated with the logged in user
    
    Parameters: json data
    Return type: __dict__, Integer
    """
    try:

        hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter(
            HubOrders.deleted_at == None).first()

        if hub_order:
            if hub_order.order_created:

                resp, status = Auth.get_logged_in_user(request)
                distributor = resp['data']

                hub = Hub.query.filter_by(
                    id=hub_order.hub_id).filter_by(deleted_at=None).first()
                city_ids = []

                if distributor['role'] == 'supervisor':
                    supervisor_cities = UserCities.query.filter_by(user_id = distributor['id']).filter_by(deleted_at = None).all()
                    
                    for supervisor_city in supervisor_cities:
                        city_ids.append(supervisor_city.city_id)


                if distributor['role'] == 'super_admin' or (distributor['role'] == 'distributor' and hub.distributor_id == distributor['id']) or (distributor['role'] == 'merchant' and hub_order.merchant_id == distributor['id']) or (distributor['role'] == 'supervisor' and hub.city_id in city_ids):

                    hub_order_lists = HubOrderLists.query.filter_by(
                        hub_order_id=data['hub_order_id']).filter_by(deleted_at=None).order_by(HubOrderLists.id).all()

                    if hub_order_lists:
                        hub_order_list_object = []

                        for item in hub_order_lists:

                            quantity_unit = QuantityUnit.query.filter_by(
                                id=item.product_quantity_unit).first()

                            if not quantity_unit:
                                apiResponce = ApiResponse(
                                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                                return (apiResponce.__dict__), 400

                            orderd_item = {
                                'id': item.id,
                                'item_name': item.product_name,
                                'item_brand_name': item.product_brand_name,
                                'item_image': item.product_image,
                                'item_variable_quantity': item.product_quantity,
                                'quantity_unit_name': quantity_unit.name,
                                'quantity_unit_short_name': quantity_unit.short_name,
                                'quantity_unit_conversion': quantity_unit.conversion,
                                'quantity_unit_type_details': quantity_unit.type_details,
                                'item_variable_mrp': item.product_mrp,
                                'item_variable_selling_price': item.product_selling_price,
                                'item_total_cost': item.product_selling_price * item.quantity if item.product_selling_price else None,
                                'quantity': item.quantity,
                                # 'removed_by_id': item.removed_by_id,
                                'status': item.status,
                            }
                            hub_order_list_object.append(orderd_item)

                        tax_object = []
                        
                        hub_order_taxes = HubOrderTax.query.filter_by(
                            hub_order_id=hub_order.id).filter_by(deleted_at = None).all()

                        for hub_order_tax in hub_order_taxes:
                                if hub_order_tax.tax_type == 1:
                                    taxtype = "Percentage"
                                else:
                                    taxtype = "Flat"

                                tax_data = {
                                    'tax_id': hub_order_tax.id,
                                    'tax_name': hub_order_tax.tax_name,
                                    'tax_type': taxtype,
                                    'amount': hub_order_tax.amount,
                                    'calculated': hub_order_tax.calculated,
                                }

                                tax_object.append(tax_data)

                        tax_details = {
                            'total_tax': hub_order.total_tax,
                            'tax_details': tax_object
                        }
                        hub = hub.query.filter_by(
                            id=hub_order.hub_id).first()

                        
                        user = Merchant.query.filter_by(
                            id=hub_order.merchant_id).first()

                        store = hub_order.store
                        store_city = store.city
                        store_address = {
                            'address_line_1' : store.address_line_1,
                            'address_line_2' : store.address_line_2, 
                            'store_latitude' : store.store_latitude, 
                            'store_longitude' : store.store_longitude
                        }
                        # self_delivery = 0
                        # if hub_order.da_id == 1:
                        #     self_delivery = 1
                        
                        da_object= None
                        if hub_order.assigned_to_da and hub_order.da_id:
                            da = hub_order.delivery_associate
                            da_object = {
                                'id' : da.id,
                                'name' : da.name,
                                'image' : da.image
                            }
                        
                        
                        data = {
                            'order_id': hub_order.id,
                            'slug': hub_order.slug,
                            # 'user_id': hub_order.user_id,
                            'merchant_name': user.name,
                            'merchant_store_name' : store.name,
                            'merchant_store_city' : store_city.name,
                            'merchant_store_address': store_address,
                            'order_total': hub_order.order_total,
                            # 'slug': hub_order.slug,
                            'hub_slug': hub.slug,
                            'hub_name': hub.name,
                            'delivery_fee': hub_order.delivery_fee,
                            'grand_order_total': hub_order.grand_order_total,
                            # #'initial_paid': hub_order.initial_paid,
                            'order_created': str(hub_order.order_created) if hub_order.order_created else None,
                            'order_confirmed': str(hub_order.order_confirmed) if hub_order.order_confirmed else None,
                            'merchant_confirmed': str(hub_order.merchant_confirmed) if hub_order.merchant_confirmed else None,
                            'assigned_to_da':  str(hub_order.assigned_to_da) if hub_order.assigned_to_da else None,
                            'order_pickedup':  str(hub_order.order_pickedup) if hub_order.order_pickedup else None,
                            'order_delivered':  str(hub_order.order_delivered) if hub_order.order_delivered else None,
                            'delivery_date': str(hub_order.delivery_date) if hub_order.delivery_date else None ,
                            # 'user_address_id': hub_order.user_address_id,
                            # 'delivery_slot_id': hub_order.delivery_slot_id,
                            # 'da_id': hub_order.da_id,
                            'status': hub_order.status,
                            'payment_status': hub_order.payment_status,
                            'total_paid': hub_order.total_paid,
                            'due_payment': hub_order.due_payment,
                            # 'merchant_transfer_at': hub_order.merchant_transfer_at,
                            # 'merchant_txnid': hub_order.merchant_txnid,
                            # 'txnid': hub_order.txnid,
                            # 'gateway': hub_order.gateway,
                            # 'transaction_status': hub_order.transaction_status,
                            # 'cancelled_by': hub_order.cancelled_by,
                            # 'created_at': str(hub_order.created_at),
                            'updated_at': str(hub_order.updated_at) if hub_order.updated_at != None else None,
                            # 'deleted_at': str(hub_order.deleted_at),
                            'items': hub_order_list_object,
                            'tax': tax_details,
                            'delivery_associate' : da_object
                        }

                        apiresponse = ApiResponse(
                            True, "Data Loaded Succesfully", data, None)
                        return apiresponse.__dict__, 200

                    else:
                        apiresponse = ApiResponse(
                            True, "No Data Found", None, None)
                        return apiresponse.__dict__, 200


                elif distributor['role'] == 'delivery_associate':
                    hub_das = HubDA.query.filter_by(delivery_associate_id=distributor['id']).filter_by(deleted_at=None).all()

                    hub_id = []
                    for hub in hub_das:
                        hub_id.append(hub.hub_id)
                    
                    hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter_by(deleted_at=None).filter_by(status=1).first()

                    if not hub_order.hub_id in hub_id:
                        apiResponce = ApiResponse(
                                    False, f'DA has no access to this order', None,
                                    f'DA Permissions not satisfied')
                        return (apiResponce.__dict__), 400



                    hub_order_lists = HubOrderLists.query.filter_by(
                        hub_order_id=data['hub_order_id']).filter_by(deleted_at=None).all()

                    if hub_order_lists:
                        hub_order_list_object = []

                        for item in hub_order_lists:

                            quantity_unit = QuantityUnit.query.filter_by(
                                id=item.product_quantity_unit).first()

                            if not quantity_unit:
                                apiResponce = ApiResponse(
                                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                                return (apiResponce.__dict__), 400

                            orderd_item = {
                                'id': item.id,
                                'item_name': item.product_name,
                                'item_brand_name': item.product_brand_name,
                                'item_image': item.product_image,
                                'item_variable_quantity': item.product_quantity,
                                'quantity_unit_name': quantity_unit.name,
                                'quantity_unit_short_name': quantity_unit.short_name,
                                'quantity_unit_conversion': quantity_unit.conversion,
                                'quantity_unit_type_details': quantity_unit.type_details,
                                'item_variable_mrp': item.product_mrp,
                                'item_variable_selling_price': item.product_selling_price,
                                'item_total_cost': item.product_selling_price * item.quantity if item.product_selling_price else None,
                                'quantity': item.quantity,
                                # 'removed_by_id': item.removed_by_id,
                                'status': item.status,
                            }
                            hub_order_list_object.append(orderd_item)

                        # tax_object = []
                        
                        # hub_order_taxes = HubOrderTax.query.filter_by(
                        #     hub_order_id=hub_order.id).filter_by(deleted_at = None).all()

                        # for hub_order_tax in hub_order_taxes:
                        #         if hub_order_tax.tax_type == 1:
                        #             taxtype = "Percentage"
                        #         else:
                        #             taxtype = "Flat"

                        #         tax_data = {
                        #             'tax_id': hub_order_tax.id,
                        #             'tax_name': hub_order_tax.tax_name,
                        #             'tax_type': taxtype,
                        #             'amount': hub_order_tax.amount,
                        #             'calculated': hub_order_tax.calculated,
                        #         }

                        #         tax_object.append(tax_data)

                        # tax_details = {
                        #     'total_tax': hub_order.total_tax,
                        #     'tax_details': tax_object
                        # }
                        hub = hub.query.filter_by(
                            id=hub_order.hub_id).first()

                        
                        user = Merchant.query.filter_by(
                            id=hub_order.merchant_id).first()

                        store = hub_order.store
                        store_city = store.city
                        store_address = {
                            'address_line_1' : store.address_line_1,
                            'address_line_2' : store.address_line_2, 
                            'store_latitude' : store.store_latitude, 
                            'store_longitude' : store.store_longitude
                        }
                        # self_delivery = 0
                        # if hub_order.da_id == 1:
                        #     self_delivery = 1
                        
                        da_object= None
                        if hub_order.assigned_to_da and hub_order.da_id:
                            da = hub_order.delivery_associate
                            da_object = {
                                'id' : da.id,
                                'name' : da.name,
                                'image' : da.image
                            }
                        
                        
                        data = {
                            'order_id': hub_order.id,
                            'slug': hub_order.slug,
                            # 'user_id': hub_order.user_id,
                            'merchant_name': user.name,
                            'merchant_store_name' : store.name,
                            'merchant_store_city' : store_city.name,
                            'merchant_store_address': store_address,
                            'order_total': hub_order.order_total,
                            # 'slug': hub_order.slug,
                            'hub_slug': hub.slug,
                            'hub_name': hub.name,
                            'delivery_fee': hub_order.delivery_fee,
                            'grand_order_total': hub_order.grand_order_total,
                            # #'initial_paid': hub_order.initial_paid,
                            'order_created': str(hub_order.order_created) if hub_order.order_created else None,
                            'order_confirmed': str(hub_order.order_confirmed) if hub_order.order_confirmed else None,
                            'merchant_confirmed': str(hub_order.merchant_confirmed) if hub_order.merchant_confirmed else None,
                            'assigned_to_da':  str(hub_order.assigned_to_da) if hub_order.assigned_to_da else None,
                            'order_pickedup':  str(hub_order.order_pickedup) if hub_order.order_pickedup else None,
                            'order_delivered':  str(hub_order.order_delivered) if hub_order.order_delivered else None,
                            'delivery_date': str(hub_order.delivery_date) if hub_order.delivery_date else None ,
                            # 'user_address_id': hub_order.user_address_id,
                            # 'delivery_slot_id': hub_order.delivery_slot_id,
                            # 'da_id': hub_order.da_id,
                            'status': hub_order.status,
                            'payment_status': hub_order.payment_status,
                            'total_paid': hub_order.total_paid,
                            'due_payment': hub_order.due_payment,
                            # 'merchant_transfer_at': hub_order.merchant_transfer_at,
                            # 'merchant_txnid': hub_order.merchant_txnid,
                            # 'txnid': hub_order.txnid,
                            # 'gateway': hub_order.gateway,
                            # 'transaction_status': hub_order.transaction_status,
                            # 'cancelled_by': hub_order.cancelled_by,
                            # 'created_at': str(hub_order.created_at),
                            'updated_at': str(hub_order.updated_at) if hub_order.updated_at != None else None,
                            # 'deleted_at': str(hub_order.deleted_at),
                            'items': hub_order_list_object,
                            'delivery_associate' : da_object
                        }

                        apiresponse = ApiResponse(
                            True, "Data Loaded Succesfully", data, None)
                        return apiresponse.__dict__, 200

                    else:
                        apiresponse = ApiResponse(
                            True, "No Data Found", None, None)
                        return apiresponse.__dict__, 200
                else:
                    # blacklist merchant or not?
                    # token = request.headers.get('Authorization')
                    # blacklist_token = BlacklistToken(token=token)
                    # try:
                    #     # insert the token
                    #     db.session.add(blacklist_token)
                    #     db.session.commit()
                    # except:
                    #     db.session.rollback()

                    apiresponse = ApiResponse(False, "User has no access to view this order",
                                              None, 'User hub_id and order item hub_id is different')
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def distributor_quantity_update_order(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        distributor_id = user['id']
        req_body = data.json
        hub_order_list_id = req_body['hub_order_list_id']
        hub_order_id = req_body['hub_order_id']
        quantity = int(req_body['quantity'])
        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()

        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        item = HubOrderLists.query.filter_by(id=hub_order_list_id).filter_by(deleted_at = None).first()

        if not item:
            error = ApiResponse(
                False, "Item Not Found", None)
            return error.__dict__, 400

        hub = Hub.query.filter_by(id = order.hub_id).first()

        if hub.distributor_id != distributor_id:
            error = ApiResponse(False, "Unauthorized Distributor", None)
            return error.__dict__, 401
        
        if order.merchant_confirmed:
            error = ApiResponse(False, "Order is Confirmed by Merchant",
                                None)
            return error.__dict__, 400


        if not item.hub_order_id == hub_order_id:
            error = ApiResponse(
                False, "Details don't match the database", None, "Details do not match")
            return error.__dict__, 400

        if not order.order_created:
            error = ApiResponse(False, "Order not found",
                                None, "Order is not created")
            return error.__dict__, 400


        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "")
            return error.__dict__, 400


        if quantity > item.quantity:
            response = ApiResponse(
                False, "Distributor Cannot increase Quantity", None, None)
            return response.__dict__, 400

        if quantity < 0:
            response = ApiResponse(
                False, "Quantity Cannot be Negative", None, None)
            return response.__dict__, 400

        if quantity == 0:
            item.status = 10
            item.updated_at = datetime.datetime.utcnow()
            item.removed_by_id = user['id']
            item.removed_by_role = user['role']

        if item.quantity > quantity:
            item.quantity = quantity
            item.updated_at = datetime.datetime.utcnow()

        try:
            db.session.add(item)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: HubOrderList Error: {str(e)}")
            return error.__dict__, 500

        order_total, grand_order_total = calculate_hub_order_total(
            order)

        active_item_count = get_count(HubOrderLists.query.filter_by(
            status=1).filter_by(hub_order_id=order.id))

        if active_item_count == 0:
            order.status = 10

        order.order_total = order_total
        order.grand_order_total = grand_order_total
        order.updated_at = datetime.datetime.utcnow()

        try:
            db.session.add(order)
            db.session.commit()
        except Exception as e:
            db.session.rollback()

            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: HubOrderList Error: {str(e)}")
            return error.__dict__, 500
                                
        response = ApiResponse(True, "Item Successfully Updated", None, None)
        return response.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__, 500

def distributor_price_update_order(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        distributor_id = user['id']
        req_body = data.json
        hub_order_list_id = req_body['hub_order_list_id']
        hub_order_id = req_body['hub_order_id']
        selling_price = req_body['selling_price']
        mrp =  req_body['mrp']
        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()

        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        item = HubOrderLists.query.filter_by(id=hub_order_list_id).filter_by(deleted_at = None).first()

        if not item:
            error = ApiResponse(
                False, "Item Not Found", None)
            return error.__dict__, 400

        hub = Hub.query.filter_by(id = order.hub_id).first()

        if hub.distributor_id != distributor_id:
            error = ApiResponse(False, "Unauthorized Distributor", None)
            return error.__dict__, 401
        
        if order.merchant_confirmed:
            error = ApiResponse(False, "Order is Confirmed by Merchant",
                                None)
            return error.__dict__, 400

        if not item.hub_order_id == hub_order_id:
            error = ApiResponse(
                False, "Details don't match the database", None, "Details do not match")
            return error.__dict__, 400

        if not order.order_created:
            error = ApiResponse(False, "Order not found",
                                None, "Order is not created")
            return error.__dict__, 400

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "")
            return error.__dict__, 400

        if selling_price < 0 or mrp < 0:
            error = ApiResponse(
                False, "Price Cannot be Negetive", None)
            return error.__dict__, 400

        if selling_price > mrp:
            error = ApiResponse(
                False, "Selling Price Cannot be Greater than Mrp", None)
            return error.__dict__, 400

        if not item.product_selling_price and not item.product_mrp:
            msg ="Item Price Added Successfully"

        else:
            msg = "Item Price Updated Successfully"

        item.product_selling_price = selling_price
        item.product_mrp = mrp
        item.updated_at = datetime.datetime.utcnow()


        try:
            db.session.add(item)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: HubOrderList Error: {str(e)}")
            return error.__dict__, 500

        calculate_hub_order_total(order)


        try:
            db.session.add(order)
            db.session.commit()
        except Exception as e:
            db.session.rollback()

            error = ApiResponse(False, "Database Server Error",
                                None, f"Database Name: HubOrderList Error: {str(e)}")
            return error.__dict__, 500
        
        
        response = ApiResponse(True, msg, None, None)
        return response.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, "Internal Server Error", None, str(e))
        return error.__dict__, 500

def distributor_accept_order(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        req_body = data.json

        hub_order_id = req_body['hub_order_id']

        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()
        
        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400
            
        
        hub = Hub.query.filter_by(id = order.hub_id).first()

        if hub.distributor_id != user['id']:
            error = ApiResponse(False, "Unauthorized Distributor", None)
            return error.__dict__, 401

        hub_order_lists = HubOrderLists.query.filter_by(hub_order_id = hub_order_id).filter_by(deleted_at = None).all()
        
        no_price_set = ""
        
        for hub_order_list in hub_order_lists:
            
            if hub_order_list.product_selling_price == None and hub_order_list.product_mrp == None:
                no_price_set = no_price_set + f"Selling Price and MRP of {hub_order_list.product_name} is not given,"
            
            elif hub_order_list.product_selling_price == None:
                no_price_set = no_price_set + f"Selling Price of {hub_order_list.product_name} is not given,"
            
            elif hub_order_list.product_mrp == None:
                no_price_set = no_price_set + f"MRP of {hub_order_list.product_name} is not given,"

        if no_price_set != "":
            msg = no_price_set[:-1]
            error = ApiResponse(
                    False, msg, None)
            return error.__dict__, 400

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be accepted in it's current state", None, "Order Status != 1")
            return error.__dict__, 400

        if order.order_confirmed:
            error = ApiResponse(False, "Order Already Confirmed",
                                None, "Order Already Confirmed")
            return error.__dict__, 400

        order.order_confirmed = datetime.datetime.utcnow()
        order.updated_at = datetime.datetime.utcnow()
        order.status = 1
        
        save_db(order, "HubOrder")
        
        
        #Notification Part
        
        user = Merchant.query.filter_by(id = order.merchant_id).first()
        
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_accepted',
            'order_id': str(order.id)
                
        }
           
        CreateNotification.gen_notification_v2(user, notification_data)
        
        response = ApiResponse(
                    True, "Order Accepted Successfully", None, None)
        return response.__dict__, 200
        
    except Exception as e:
        error = ApiResponse(False, "Some Error Occured!", None, str(e))
        return error.__dict__, 500

def distributor_reject_order(data):
    try:

        hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter(
            HubOrders.deleted_at == None).first()

        if hub_order:

            if hub_order.order_created:

                if not hub_order.order_confirmed:

                    if hub_order.status != 11:

                        if hub_order.status != 10:

                            resp, status = Auth.get_logged_in_user(request)
                            distributor = resp['data']
                            hub = Hub.query.filter_by(
                                id=hub_order.hub_id).first()
                            

                            if hub.distributor_id == distributor['id']:

                                hub_order_lists = HubOrderLists.query.filter_by(
                                    hub_order_id=data['hub_order_id'])

                                for item in hub_order_lists:

                                    item.status = 10
                                    item.updated_at = datetime.datetime.utcnow()
                                    # item.deleted_at = datetime.datetime.utcnow()
                                    item.removed_by_id = distributor['id']
                                    item.removed_by_role = distributor['role']

                                    try:
                                        db.session.add(item)
                                        db.session.commit()

                                    except Exception as e:
                                        db.session.rollback()
                                        error = ApiResponse(
                                            False, 'Error Occured', None, "HubOrderList Database error: "+str(e))
                                        return (error.__dict__), 500

                                hub_order.status = 10
                                hub_order.removed_by_role = "distributor"
                                hub_order.removed_by_id = distributor['id']
                                hub_order.updated_at = datetime.datetime.utcnow()
                                # item_order.deleted_at = datetime.datetime.utcnow()
                                # item_order.canceled_by = distributor['id']

                                try:

                                    db.session.add(hub_order)
                                    db.session.commit()

                                except Exception as e:
                                    db.session.rollback()
                                    error = ApiResponse(
                                        False, 'Error Occured', None, "ItemOrders Database error: "+str(e))
                                    return (error.__dict__), 500
                                
                                user = hub_order.merchant
        
                                notification_data = {
                                    'hub_name': hub.name,
                                    'template_name': 'hub_order_reject',
                                    'order_id': str(hub_order.id)
                                        
                                }
                                   
                                CreateNotification.gen_notification_v2(user, notification_data)
                                
                                apiresponse = ApiResponse(
                                    True, "Order Rejected Successfuly", None, None)
                                return apiresponse.__dict__, 200

                            else:
                                # blacklist merchant or not?
                                # token = request.headers.get('Authorization')
                                # blacklist_token = BlacklistToken(token=token)
                                # try:
                                #     # insert the token
                                #     db.session.add(blacklist_token)
                                #     db.session.commit()
                                # except:
                                #     db.session.rollback()

                                apiresponse = ApiResponse(
                                    False, "Distributor has no access to view this order", None, 'Distributor store_id and order item store_id is different')
                                return apiresponse.__dict__, 400
                                

                        else:
                            apiresponse = ApiResponse(
                                False, "Order is Allready Rejected", None, "'Order Status code is Rejected'")
                            return apiresponse.__dict__, 400
                    else:
                        apiresponse = ApiResponse(
                            False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order Allready Accepted", None, "Order Allready Accepted")
                    return apiresponse.__dict__, 400
            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def distributor_cancel_order(data):
    try:

        hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter(
            HubOrders.deleted_at == None).first()

        if hub_order:

            if hub_order.order_created:

                if hub_order.status != 10:

                    if hub_order.order_confirmed:

                        if hub_order.status != 11:

                            if not hub_order.order_pickedup:

                                resp, status = Auth.get_logged_in_user(request)
                                user = resp['data']

                                distributor = False
                                admin = False
                                merchant = False

                                if user['role'] == 'distributor':
                                    hub = Hub.query.filter_by(
                                    id=hub_order.hub_id).first()

                                    if hub.distributor_id == user['id']:
                                        distributor = True

                                elif user['role'] == 'super_admin' or user['role'] == 'admin':
                                    admin = True
                                
                                elif user['role'] == merchant and hub_order.merchant_id == user['id']:
                                    merchant = True

                                if distributor or admin or merchant:

                                    hub_order_lists = HubOrderLists.query.filter_by(
                                        hub_order_id=data['hub_order_id']).filter_by(deleted_at=None).filter_by(status=1).all()

                                    for item in hub_order_lists:

                                        item.status = 11
                                        item.updated_at = datetime.datetime.utcnow()
                                        # item.deleted_at = datetime.datetime.utcnow()

                                        try:
                                            db.session.add(item)
                                            db.session.commit()

                                        except Exception as e:
                                            db.session.rollback()
                                            error = ApiResponse(
                                                False, 'Error Occured', None, "ItemOrderList Database error: "+str(e))
                                            return (error.__dict__), 500

                                    hub_order.status = 11
                                    hub_order.updated_at = datetime.datetime.utcnow()
                                    # hub_order.deleted_at = datetime.datetime.utcnow()
                                    # hub_order.cancelled_by = user['id']
                                    hub_order.canceled_by_id = user['id']
                                    hub_order.canceled_by_role = user['role']

                                    try:

                                        db.session.add(hub_order)
                                        db.session.commit()

                                    except Exception as e:
                                        db.session.rollback()
                                        error = ApiResponse(
                                            False, 'Error Occured', None, "HubOrders Database error: "+str(e))
                                        return (error.__dict__), 500
                                    
                                    if user['role'] == 'distributor':
                                        merchant = hub_order.merchant
                                        
                                        notification_data = {
                                            'hub_name': hub.name,
                                            'template_name': 'hub_order_cancel_merchant',
                                            'order_id': str(hub_order.id),
                                            'role': user['role'].capitalize()
                                        }
                                        CreateNotification.gen_notification_v2(merchant, notification_data)
                                    
                                    elif user['role'] == 'merchant':
                                        distributor = hub.distributor
                                                                                
                                        notification_data = {
                                            'hub_name': hub.name,
                                            'template_name': 'hub_order_cancel_distributor',
                                            'order_id': str(hub_order.id),
                                            'role': user['role'].capitalize()
                                        }
                                        CreateNotification.gen_notification_v2(distributor, notification_data)
                                     
                                    else:
                                        merchant = hub_order.merchant
                                        
                                        notification_data = {
                                            'hub_name': hub.name,
                                            'template_name': 'hub_order_cancel_merchant',
                                            'order_id': str(hub_order.id),
                                            'role': user['role'].capitalize()
                                        }
                                        CreateNotification.gen_notification_v2(merchant, notification_data)
                                        
                                        distributor = hub.distributor
                                                                                
                                        notification_data = {
                                            'hub_name': hub.name,
                                            'template_name': 'hub_order_cancel_distributor',
                                            'order_id': str(hub_order.id),
                                            'role': user['role'].capitalize()
                                        }
                                        CreateNotification.gen_notification_v2(distributor, notification_data)
                                                              
                                    if hub_order.assinged_to_da != None:
                                        da = hub_order.delivery_associate
                                    
                                        notification_data = {
                                            'hub_name': hub.name,
                                            'template_name': 'hub_order_cancel_da',
                                            'order_id': str(hub_order.id),
                                        }
                                        CreateNotification.gen_notification_v2(da, notification_data)
                                        
                                    apiresponse = ApiResponse(
                                        True, "Order Canceled Successfully", None, None)
                                    return apiresponse.__dict__, 200

                                else:
                                    # blacklist distributor or not?
                                    # token = request.headers.get('Authorization')
                                    # blacklist_token = BlacklistToken(token=token)
                                    # try:
                                    #     # insert the token
                                    #     db.session.add(blacklist_token)
                                    #     db.session.commit()
                                    # except:
                                    #     db.session.rollback()

                                    apiresponse = ApiResponse(
                                        False, "Distributor has no access to view this order", None, 'Distributor store_id and order item store_id is different')
                                    return apiresponse.__dict__, 400

                            else:
                                apiresponse = ApiResponse(
                                    False, "Order is picked up , Can't cancel it now", None, f'Order is allready picked up at {hub_order.order_pickedup}')
                                return apiresponse.__dict__, 400

                        else:
                            apiresponse = ApiResponse(
                                False, "Order is Allready Canceled", None, "Order Status code is 'Canceled'")
                            return apiresponse.__dict__, 400

                    else:
                        apiresponse = ApiResponse(
                            False, "Order is not Accepted Yet", None, "Order is not confirmed")
                        return apiresponse.__dict__, 400

                else:
                    apiresponse = ApiResponse(
                        False, "Order is Allready Rejected", None, "'Order Status code is Rejected'")
                    return apiresponse.__dict__, 400

            else:
                apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
                return apiresponse.__dict__, 400

        else:
            apiresponse = ApiResponse(
                False, "Error Occured", None, 'Either Order id Wrong or Order is not created yet')
            return apiresponse.__dict__, 400

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def distributor_order_assigin_to_da(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']
        req_body = data.json

        hub_order_id = req_body['hub_order_id']
        da_id = req_body['da_id']
        
        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()
        
        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400


        hub = Hub.query.filter_by(id = order.hub_id).first()

        if hub.distributor_id != user['id']:
            error = ApiResponse(False, "Unauthorized Distributor", None)
            return error.__dict__, 401

        if not order.order_created:
            error = ApiResponse(False, "Order Not Yet Created",
                                None)
            return error.__dict__, 400

        if not order.order_confirmed:
            error = ApiResponse(False, "Order Not Yet Confirmed",
                                None)
            return error.__dict__, 400

        if not order.merchant_confirmed:
            error = ApiResponse(False, "Order Not Confirmed by Merchant Yet",
                                None)
            return error.__dict__, 400

        if order.assigned_to_da:
            error = ApiResponse(False, "Order Allready Assiged to DA",
                                None)
            return error.__dict__, 400

        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "Order Status != 1")
            return error.__dict__, 400
        
        hub_da = HubDA.query.filter_by(delivery_associate_id = da_id).filter_by(hub_id = hub.id).filter_by(deleted_at = None).first()
        
        if not hub_da:
            error = ApiResponse(
                False, "DA not belong to this hub")
            return error.__dict__, 403
        
        
        da = hub_da.delivery_associate
        
        if not da or da.deleted_at:
            error = ApiResponse(
                False, "DA not Found", None)
            return error.__dict__, 400
        
        
        order.assigned_to_da = datetime.datetime.utcnow()
        order.da_id = da_id
        order.updated_at = datetime.datetime.utcnow()
        order.status = 1

        save_db(order, "HubOrder")
        
        
        #Notification 
        
        user = Merchant.query.filter_by(id = order.merchant_id).first()
        da = order.delivery_associate
        
        #user
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_assigned_merchant',
            'order_id': str(order.id),
            'da_name': da.name
                
        }
        CreateNotification.gen_notification_v2(user, notification_data)
        #da
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_assigned_da',
            'order_id': str(order.id),
                
        }
        CreateNotification.gen_notification_v2(da, notification_data)
        
        apiresponse = ApiResponse(
            True, f"Order Assigned to DA {da.name} Successfully", None, None)
        return apiresponse.__dict__, 200
        
        
    except Exception as e:
        error = ApiResponse(False, "Some Error Occured!", None, str(e))
        return error.__dict__, 500

def merchant_hub_order_confirm(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub_order_id = data['hub_order_id']
        confirmed = data['confirmed']
        
        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()
        
        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400


        hub = Hub.query.filter_by(id = order.hub_id).first()

        if order.merchant_id != user['id']:
            error = ApiResponse(False, "Unauthorized Merchant", None)
            return error.__dict__, 401

        if not order.order_created:
            error = ApiResponse(False, "Order Not Yet Created",
                                None)
            return error.__dict__, 400

        if not order.order_confirmed:
            error = ApiResponse(False, "Order Not Yet Confirmed",
                                None)
            return error.__dict__, 400
        
        if confirmed not in [0,1]:
            error = ApiResponse(False, "Wrong Status Code Provided",
                                None)
            return error.__dict__, 400
        
        if not order.status == 1:
            error = ApiResponse(
                False, "Order Can't be updated in it's current state", None, "Order Status != 1")
            return error.__dict__, 400
        
        if order.merchant_confirmed != None:
            error = ApiResponse(
                False, "Order Allready Confirmed by Merchant", None)
            return error.__dict__, 400
            
        if confirmed == 0:
            order.status = 10
            order.removed_by_id = user['id']
            order.removed_by_role = user['role']
        
        else:
            order.merchant_confirmed = datetime.datetime.utcnow()
            
        order.updated_at = datetime.datetime.utcnow()
            
        save_db(order)
        
        
        #Notification 
        
        user = hub.distributor
        status = "Confirmed" if confirmed == 1 else "Declined"
        #Distributor
        notification_data = {
            'hub_name': hub.name,
            'template_name': 'hub_order_merchant_confirm',
            'order_id': str(order.id),
            'status' : status
        }
        CreateNotification.gen_notification_v2(user, notification_data)
       
        apiresponse = ApiResponse(
            True, f"Order {status} Successfully", None, None)
        return apiresponse.__dict__, 200
    
    except Exception as e:
        error = ApiResponse(False, "Some Error Occured!", None, str(e))
        return error.__dict__, 500
        
def merchant_hub_order_items_delete(data):
    try:
        resp, status = Auth.get_logged_in_user(data)
        user = resp['data']

        item_ids = data['hub_order_list_ids']
        hub_order_id = data['hub_order_id']
        
        order = HubOrders.query.filter_by(id=hub_order_id).filter_by(deleted_at = None).first()
        
        if not order:
            error = ApiResponse(
                False, "Order Not Found", None)
            return error.__dict__, 400

        hub = Hub.query.filter_by(id = order.hub_id).first()

        if order.merchant_id != user['id']:
            error = ApiResponse(False, "Unauthorized Merchant", None)
            return error.__dict__, 401

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500
   
def delivery_associate_pick_up_order(data):
    """
    Changes status of a specific hub order associated with the user(Distributor/Delivery Associate) to picked up

    Parameters: json data
    Return type: __dict__, Integer
    """
    try:

        hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter(
            HubOrders.deleted_at == None).first()

        if not hub_order:
            apiresponse = ApiResponse(False, "Order Not Found", None, None)
            return apiresponse.__dict__, 400

        

        if not hub_order.order_created:
            apiresponse = ApiResponse(
                False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400

        if hub_order.status == 10:
            apiresponse = ApiResponse(
                False, "Order is Rejected", None, "'Order Status code is Rejected'")
            return apiresponse.__dict__, 400

        if hub_order.status == 11:
            apiresponse = ApiResponse(
                False, "Order is Canceled", None, "'Order Status code is Canceled'")
            return apiresponse.__dict__, 400

        if not hub_order.order_confirmed:
            apiresponse = ApiResponse(
                False, "Order is not Accepted Yet", None, "Order is not confirmed")
            return apiresponse.__dict__, 400

        if not hub_order.assigned_to_da:
            apiresponse = ApiResponse(
                False, "Order is not Ready to Pack Yet", None, "Order is not Ready to Pack Yet")
            return apiresponse.__dict__, 400

        if hub_order.order_pickedup:
            apiresponse = ApiResponse(False, "Order is allready picked up", None,
                                    f'Order is allready picked up at {hub_order.order_pickedup}')
            return apiresponse.__dict__, 400

        if hub_order.order_delivered:
            apiresponse = ApiResponse(False, "Order is allready Delivered", None,
                                    f'Order is allready delivered at {hub_order.order_delivered}')
            return apiresponse.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(id = hub_order.hub_id).first()

        hub_da = HubDA.query.filter_by(hub_id=hub.id).filter_by(delivery_associate_id=user['id']).filter_by(status=1).filter_by(deleted_at=None).first()

        if user['role'] == 'distributor':
            apiresponse = ApiResponse(
                False, "Distributor Can't change the Status of the Order", None, None)
            return apiresponse.__dict__, 400

        if not hub_da:
            apiresponse = ApiResponse(
                False, "Delivery Associate does not have the correct permissionsto  change the Status of the Order", None, None)
            return apiresponse.__dict__, 400

        hub_order.order_pickedup = datetime.datetime.utcnow()
        hub_order.updated_at = datetime.datetime.utcnow()

        save_db(hub_order)

        apiresponse = ApiResponse(
            True, "Order Status Changed to Picked Up", None, None)
        return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

def delivery_associate_deliverd_order(data):
    """
    Changes status of a specific hub order associated with the user(Distributor/Delivery Associate) to delivered

    Parameters: json data
    Return type: __dict__, Integer
    """
    try:
        hub_order = HubOrders.query.filter_by(id=data['hub_order_id']).filter(
            HubOrders.deleted_at == None).first()

        if not hub_order:
            apiresponse = ApiResponse(False, "Order Not Found", None, None)
            return apiresponse.__dict__, 400

        if hub_order.walk_in_order == 1:
            error = ApiResponse(
                False, "Can't change Walk in Order Status", None)
            return error.__dict__, 400

        if hub_order.da_id != 1:
            apiresponse = ApiResponse(
                False, "Distributor Can't change the Status of the Order", None, None)
            return apiresponse.__dict__, 400

        if not hub_order.order_created:
            apiresponse = ApiResponse(
                False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400

        if hub_order.status == 10:
            apiresponse = ApiResponse(
                False, "Order is Rejected", None, "'Order Status code is Rejected'")
            return apiresponse.__dict__, 400

        if hub_order.status == 11:
            apiresponse = ApiResponse(
                False, "Order is Canceled", None, "'Order Status code is Canceled'")
            return apiresponse.__dict__, 400

        if not hub_order.order_confirmed:
            apiresponse = ApiResponse(
                False, "Order is not Accepted Yet", None, "Order is not confirmed")
            return apiresponse.__dict__, 400

        if not hub_order.assigned_to_da:
            apiresponse = ApiResponse(
                False, "Order is not Ready to Pack Yet", None, "Order is not Ready to Pack Yet")
            return apiresponse.__dict__, 400

        if not hub_order.order_pickedup:
            apiresponse = ApiResponse(False, "Order is not picked up", None,
                                      f'Order is not picked up at {hub_order.order_pickedup}')
            return apiresponse.__dict__, 400

        if hub_order.order_delivered:
            apiresponse = ApiResponse(False, "Order is allready Delivered", None,
                                      f'Order is allready delivered at {hub_order.order_delivered}')
            return apiresponse.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        hub = Hub.query.filter_by(id = hub_order.hub_id).first()

        if hub.distributor_id != user['id']:
            error = ApiResponse(False, "Unauthorized Distributor", None)
            return error.__dict__, 401

        hub_order.order_delivered = datetime.datetime.utcnow()
        hub_order.updated_at = datetime.datetime.utcnow()
        hub_order.delivery_date = datetime.datetime.utcnow()

        save_db(hub_order, "ItemOrder")

        apiresponse = ApiResponse(
            True, "Order Status Changed to Delivered", None, None)
        return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

## Public Order API's

def get_order_details_by_slug(data):
    """
    Get the details of a specific order by its slug
    
    Parameters: json data
    
    Return type: __dict__, int
    """
    try:
        item_order = ItemOrder.query.filter_by(slug=data['slug']).filter(
            ItemOrder.deleted_at == None).first()

        if not item_order:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order slug not found in database')
            return apiresponse.__dict__, 400
        
        if not item_order.order_created:
            apiresponse = ApiResponse(
                    False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400
                

        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=data['item_order_id']).filter_by(deleted_at=None).all()

        if item_order_lists:
            item_order_list_object = []

        for item in item_order_lists:
            quantity_unit = QuantityUnit.query.filter_by(
                id=item.product_quantity_unit).first()

            if not quantity_unit:
                apiResponce = ApiResponse(
                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                return (apiResponce.__dict__), 400

            orderd_item = {
                'store_item_name': item.product_name,
                'store_item_brand_name': item.product_brand_name,
                'store_item_image': item.product_image,
                'store_item_variable_quantity': item.product_quantity,
                'quantity_unit_name': quantity_unit.name,
                'quantity_unit_short_name': quantity_unit.short_name,
                'quantity_unit_conversion': quantity_unit.conversion,
                'quantity_unit_type_details': quantity_unit.type_details,
                'store_item_variable_mrp': item.product_mrp,
                'store_item_variable_selling_price': item.product_selling_price,
                'item_total_cost': item.product_selling_price * item.quantity,
                'product_packaged': item.product_packaged,
                'quantity': item.quantity,
                'removed_by': item.removed_by,
                'status': item.status,
            }
            item_order_list_object.append(orderd_item)

        tax_object = []
        
        item_order_taxes = ItemOrderTax.query.filter_by(
            item_order_id=item_order.id).filter_by(deleted_at = None).all()

        for item_order_tax in item_order_taxes:
            if item_order_tax.tax_type == 1:
                taxtype = "Percentage"
            else:
                taxtype = "Flat"

            tax_data = {
                'tax_name': item_order_tax.tax_name,
                'tax_type': taxtype,
                'amount': item_order_tax.amount,
                'calculated': item_order_tax.calculated,
            }

            tax_object.append(tax_data)

        tax_details = {
            'total_tax': item_order.total_tax,
            'tax_details': tax_object
        }
        store = Store.query.filter_by(
            id=item_order.store_id).first()

        if item_order.walk_in_order == 1:
            user = Merchant.query.filter_by(
                id=item_order.user_id).first()
        else:
            user = User.query.filter_by(
                id=item_order.user_id).first()

        self_delivery = 0
        if item_order.da_id == 1:
            self_delivery = 1

        coupon_name = None
        if item_order.coupon_id:
            coupon = item_order.coupon
            coupon_name = coupon.name
            
        
        data = {
            'user_name': user.name,
            'order_total': item_order.order_total,
            'slug': item_order.slug,
            'store_name': store.name,
            'self_delivery': self_delivery,
            'coupon_name': coupon_name,
            'order_total_discount': item_order.order_total_discount,
            'final_order_total': item_order.final_order_total,
            'delivery_fee': item_order.delivery_fee,
            'grand_order_total': item_order.grand_order_total,
            'order_created': if_date(item_order.order_created),
            'order_confirmed': if_date(item_order.order_confirmed),
            'ready_to_pack':  if_date(item_order.ready_to_pack),
            'order_paid':  if_date(item_order.order_paid),
            'order_pickedup':  if_date(item_order.order_pickedup),
            'order_delivered':  if_date(item_order.order_delivered),
            'delivery_date': if_date(item_order.delivery_date),
            'walkin_order': item_order.walk_in_order,
            'status': item_order.status,
            'items': item_order_list_object,
            'tax': tax_details
        }

        apiresponse = ApiResponse(
            True, "Data Loaded Succesfully", data, None)
        return apiresponse.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500


def get_hub_order_details_by_slug(data):
    """
    Get the details of a specific hub order by its slug
    
    Parameters: json data
    
    Return type: __dict__, int
    """
    try:
        hub_order = HubOrders.query.filter_by(slug=data['slug']).filter(
            HubOrders.deleted_at == None).first()

        if not hub_order:
            apiresponse = ApiResponse(
                False, "Order not Found", None, 'Order id not found in database')
            return apiresponse.__dict__, 404
            
        if not hub_order.order_created:
            apiresponse = ApiResponse(
                False, "Order is Not Created", None, "Order is Not Created")
            return apiresponse.__dict__, 400
            

        hub = Hub.query.filter_by(
            id=hub_order.hub_id).filter_by(deleted_at=None).first()
  
        hub_order_lists = HubOrderLists.query.filter_by(hub_order_id=hub_order.id).filter_by(deleted_at=None).all()

        hub_order_list_object = []

        for item in hub_order_lists:

            quantity_unit = QuantityUnit.query.filter_by(
                id=item.product_quantity_unit).first()

            if not quantity_unit:
                apiResponce = ApiResponse(
                    False, f'quantity unit {item.product_quantity_unit} not available in QuantityUnit', None,
                    f'quantity unit {QuantityUnit} not available in QuantityUnit')
                return (apiResponce.__dict__), 400

            orderd_item = {
                'item_name': item.product_name,
                'item_brand_name': item.product_brand_name,
                'item_image': item.product_image,
                'item_variable_quantity': item.product_quantity,
                'quantity_unit_name': quantity_unit.name,
                'quantity_unit_short_name': quantity_unit.short_name,
                'quantity_unit_conversion': quantity_unit.conversion,
                'quantity_unit_type_details': quantity_unit.type_details,
                'item_variable_mrp': item.product_mrp,
                'item_variable_selling_price': item.product_selling_price,
                'item_total_cost': item.product_selling_price * item.quantity if item.product_selling_price else None,
                'quantity': item.quantity,
                # 'removed_by_id': item.removed_by_id,
                'status': item.status,
            }
            hub_order_list_object.append(orderd_item)

        tax_object = []
        
        hub_order_taxes = HubOrderTax.query.filter_by(
            hub_order_id=hub_order.id).filter_by(deleted_at = None).all()

        for hub_order_tax in hub_order_taxes:
            if hub_order_tax.tax_type == 1:
                taxtype = "Percentage"
            else:
                taxtype = "Flat"

            tax_data = {
                'tax_name': hub_order_tax.tax_name,
                'tax_type': taxtype,
                'amount': hub_order_tax.amount,
                'calculated': hub_order_tax.calculated,
            }

            tax_object.append(tax_data)

        tax_details = {
            'total_tax': hub_order.total_tax,
            'tax_details': tax_object
        }

        user = Merchant.query.filter_by(
            id=hub_order.merchant_id).first()

        store = hub_order.store
        store_city = store.city
        store_address = {
            'address_line_1' : store.address_line_1,
            'address_line_2' : store.address_line_2, 
            'store_latitude' : store.store_latitude, 
            'store_longitude' : store.store_longitude
        }
        
        da_object= None
        if hub_order.assigned_to_da and hub_order.da_id:
            da = hub_order.delivery_associate
            da_object = {
                'name' : da.name,
                'image' : da.image
            }
        
        
        data = {
            'slug': hub_order.slug,
            'merchant_name': user.name,
            'merchant_store_name' : store.name,
            'merchant_store_city' : store_city.name,
            'merchant_store_address': store_address,
            'order_total': hub_order.order_total,
            'hub_slug': hub.slug,
            'hub_name': hub.name,
            'delivery_fee': hub_order.delivery_fee,
            'grand_order_total': hub_order.grand_order_total,
            'order_created': str(hub_order.order_created) if hub_order.order_created else None,
            'order_confirmed': str(hub_order.order_confirmed) if hub_order.order_confirmed else None,
            'merchant_confirmed': str(hub_order.merchant_confirmed) if hub_order.merchant_confirmed else None,
            'assigned_to_da':  str(hub_order.assigned_to_da) if hub_order.assigned_to_da else None,
            'order_pickedup':  str(hub_order.order_pickedup) if hub_order.order_pickedup else None,
            'order_delivered':  str(hub_order.order_delivered) if hub_order.order_delivered else None,
            'delivery_date': str(hub_order.delivery_date) if hub_order.delivery_date else None ,
            'status': hub_order.status,
            'payment_status': hub_order.payment_status,
            'total_paid': hub_order.total_paid,
            'due_payment': hub_order.due_payment,
            'updated_at': str(hub_order.updated_at) if hub_order.updated_at != None else None,
            'items': hub_order_list_object,
            'tax': tax_details,
            'delivery_associate' : da_object
        }

        apiresponse = ApiResponse(
            True, "Data Loaded Succesfully", data, None)
        return apiresponse.__dict__, 200


    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500

