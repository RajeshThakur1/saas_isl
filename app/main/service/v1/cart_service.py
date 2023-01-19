
import logging
from app.main.model.hubOrderList import HubOrderLists
from app.main.model.hubOrderTax import HubOrderTax
from app.main.model.hubOrders import HubOrders
from app.main.util.v1.database import get_count, save_db
from app.main.model.coupon import Coupon
from app.main.config import ENDPOINT_PREFIX
from app.main.model.storeTaxes import StoreTaxes
from app.main.model.itemOrderTax import ItemOrderTax
import datetime

from sqlalchemy import func
from app.main import db
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import text
from app.main.model.itemOrders import ItemOrder
from app.main.model.itemOrderLists import ItemOrderLists
from flask import request, url_for
from app.main.model.userAddress import UserAddress
from app.main.model.quantityUnit import QuantityUnit
from app.main.model.storeItemVariable import StoreItemVariable
from app.main.model.store import Store
from app.main.service.v1.auth_helper import Auth
from itertools import groupby
import re
from alembic import op
from sqlalchemy import or_
import json
from app.main.util.v1.decorator import *
from app.main.model.storeItems import StoreItem
from app.main.model.store import Store
from app.main.util.v1.orders import calculate_order_total, delivery_fee_calc
import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/cart_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")
def add_to_cart(data):
    try:
        logging.info("Test info")
        store_item_variable = StoreItemVariable.query.filter_by(
            id=data['store_item_variable_id']).filter_by(deleted_at=None).first()

        if not store_item_variable:
            error = ApiResponse(False, "ERORR occured", None, "store_item_variable_id " +
                                str(data['store_item_variable_id'])+"  not available")
            return error.__dict__, 400

        # if store_item_variable.store_item_id != data['store_item_variable_id']:
        #     error = ApiResponse(False, "ERORR occured", None,
        #                         "store_item_variable_id " + data['store_item_variable_id'] + "  not matched with store_item")
        #     return error.__dict__, 400
        quantity_unit = QuantityUnit.query.filter_by(
            id=store_item_variable.quantity_unit).filter_by(deleted_at=None).first()
        if not quantity_unit:
            error = ApiResponse(False, "ERORR occured", None, "quantity_unit " +
                                str(store_item_variable.quantity_unit) + "  not available")
            return error.__dict__, 400

        store_item = StoreItem.query.filter_by(
            id=store_item_variable.store_item_id).filter_by(deleted_at=None).first()

        if not store_item:
            error = ApiResponse(False, "ERORR occured", None, "store_item_id [ " + str(
                store_item_variable.store_item_id) + " ]not available")
            return error.__dict__, 400

        if store_item.id != data['store_item_id']:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_item_id [ " + str(data['store_item_id']) + " ]not available")
            return error.__dict__, 400

        if store_item.store_id != data['store_id']:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_id [ " + str(data['store_id']) + " ]not available")
            return error.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        store = Store.query.filter_by(id=data['store_id']).filter_by(
            deleted_at=None).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Item not added to cart',
                                None, 'Store is not active or deleted')
            return error.__dict__, 400

        item_order = ItemOrder.query.filter_by(store_id=data['store_id']).filter_by(
            deleted_at=None).filter_by(user_id=user_id).filter_by(order_created=None).first()

        if not item_order:
            new_item_order = ItemOrder(
                user_id=user_id,
                store_id=data['store_id'],
                created_at=datetime.datetime.utcnow()
            )
            save_db(new_item_order)
            # try:
            #     db.session.add(new_item_order)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrder Error: {str(e)}")
            #     return error.__dict__, 500

                # Create item Order list
            new_item_order_list = ItemOrderLists(
                item_order_id=new_item_order.id,
                store_item_id=data['store_item_id'],
                store_item_variable_id=data['store_item_variable_id'],
                quantity=1,
                removed_by=0,
                status=1,
                created_at=datetime.datetime.utcnow()
            )
            save_db(new_item_order_list)
            # try:
            #     db.session.add(new_item_order_list)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderList Error: {str(e)}")
            #     return error.__dict__, 500
            order_total, final_order_total, grand_order_total = calculate_order_total(
                new_item_order)
            new_item_order.order_total = order_total
            new_item_order.final_order_total = final_order_total
            new_item_order.grand_order_total = grand_order_total
            try:
                db.session.add(new_item_order)
                db.session.commit()
            except Exception as e:
                db.session.rollback()
                error = ApiResponse(False, "Database Server Error", None,
                                    f"Database Name: ItemOrderList Error: {str(e)}")
                return error.__dict__, 500
            apiResponce = ApiResponse(
                True, 'New Item Added to cart successfully.', None, None)
            return (apiResponce.__dict__), 201

            # except Exception as e:
            #     error = ApiResponse(False, 'New Item can not be Added', None,
            #                         str(e))
            #     return (error.__dict__), 500

        else:
            # check if item exist for the cart
            old_item = ItemOrderLists.query.filter_by(item_order_id=item_order.id).filter_by(store_item_id=data['store_item_id']).filter_by(
                store_item_variable_id=data['store_item_variable_id']).filter_by(deleted_at=None).first()

            if not old_item:
                new_item_order_list = ItemOrderLists(
                    item_order_id=item_order.id,
                    store_item_id=data['store_item_id'],
                    store_item_variable_id=data['store_item_variable_id'],
                    quantity=1,
                    removed_by=0,
                    status=1,
                    created_at=datetime.datetime.utcnow()
                )
                try:
                    db.session.add(new_item_order_list)
                    db.session.commit()
                except Exception as e:
                    db.session.rollback()
                    error = ApiResponse(False, "Database Server Error", None,
                                        f"Database Name: ItemOrderList Error: {str(e)}")
                    return error.__dict__, 500
                # Create item Order list
                msg = 'Item Added to cart successfully.'
                # apiResponce = ApiResponse(
                #     True, 'one more Item Added to cart successfully.', None,
                #     None)
                # return (apiResponce.__dict__), 202

            else:
                # for update
                old_item.quantity += 1
                save_db(old_item)
                # try:
                #     db.session.add(old_item)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: ItemOrderList Error: {str(e)}")
                #     return error.__dict__, 500

                msg = 'One More Item Added to cart successfully.'
                # apiResponce = ApiResponse(
                #             True, 'One More Item Added to cart successfully.',
                #             None, None)
                # return (apiResponce.__dict__), 200

            order_total, final_order_total, grand_order_total = calculate_order_total(
                item_order)

            item_order.order_total = order_total
            item_order.final_order_total = final_order_total
            item_order.grand_order_total = grand_order_total

            save_db(item_order)
            # try:
            #     db.session.add(item_order)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderList Error: {str(e)}")
            #     return error.__dict__, 500
            apiResponce = ApiResponse(
                True, msg, None, None)
            return (apiResponce.__dict__), 201

    except Exception as e:
        apiResponce = ApiResponse(False, 'Internal Server Error', "", str(e))
        return (apiResponce.__dict__), 500


# def checkCartWeightData(cart, item):
#     print("cart--->,item--->", cart, item)

#     return []

##### Merchant add to cart ############

def merchat_add_to_cart(data):
    try:

        store_item_variable = StoreItemVariable.query.filter_by(id=data['store_item_variable_id']).filter_by(
            deleted_at=None).first()

        if not store_item_variable:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_item_variable_id " + str(data['store_item_variable_id']) + "  not available")
            return error.__dict__, 400

        # if store_item_variable.store_item_id != data['store_item_variable_id']:
        #     error = ApiResponse(False, "ERORR occured", None,
        #                         "store_item_variable_id " + data['store_item_variable_id'] + "  not matched with store_item")
        #     return error.__dict__, 400
        quantity_unit = QuantityUnit.query.filter_by(id=store_item_variable.quantity_unit).filter_by(
            deleted_at=None).first()
        if not quantity_unit:
            error = ApiResponse(False, "ERORR occured", None,
                                "quantity_unit " + str(store_item_variable.quantity_unit) + "  not available")
            return error.__dict__, 400

        store_item = StoreItem.query.filter_by(
            id=store_item_variable.store_item_id).filter_by(deleted_at=None).first()

        if not store_item:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_item_id [ " + str(store_item_variable.store_item_id) + " ]not available")
            return error.__dict__, 400

        if store_item.id != data['store_item_id']:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_item_id [ " + str(data['store_item_id']) + " ]not available")
            return error.__dict__, 400

        if store_item.store_id != data['store_id']:
            error = ApiResponse(False, "ERORR occured", None,
                                "store_id [ " + str(data['store_id']) + " ]not available")
            return error.__dict__, 400

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        item_order = ItemOrder.query.filter_by(store_id=data['store_id']).filter_by(walk_in_order=1).filter_by(deleted_at=None).filter_by(
            user_id=user_id).filter_by(order_created=None).first()

        if not item_order:
            new_item_order = ItemOrder(
                user_id=user_id,
                store_id=data['store_id'],
                created_at=datetime.datetime.utcnow(),
                walk_in_order=1
            )
            save_db(new_item_order)
            # try:
            #     db.session.add(new_item_order)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrder Error: {str(e)}")
            #     return error.__dict__, 500

                # Create item Order list
            new_item_order_list = ItemOrderLists(
                item_order_id=new_item_order.id,
                store_item_id=data['store_item_id'],
                store_item_variable_id=data['store_item_variable_id'],
                quantity=1,
                removed_by=0,
                status=1,
                created_at=datetime.datetime.utcnow()
            )
            save_db(new_item_order_list)
            # try:
            #     db.session.add(new_item_order_list)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderList Error: {str(e)}")
            #     return error.__dict__, 500
            order_total, final_order_total, grand_order_total = calculate_order_total(
                new_item_order)
            new_item_order.order_total = order_total
            new_item_order.final_order_total = final_order_total
            new_item_order.grand_order_total = grand_order_total
            save_db(new_item_order)
            # try:
            #     db.session.add(new_item_order)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderList Error: {str(e)}")
            #     return error.__dict__, 500
            apiResponce = ApiResponse(
                True, 'New Item Added to cart successfully.', None, None)
            return (apiResponce.__dict__), 201

            # except Exception as e:
            #     error = ApiResponse(False, 'New Item can not be Added', None,
            #                         str(e))
            #     return (error.__dict__), 500

        else:
            # check if item exist for the cart
            old_item = ItemOrderLists.query.filter_by(item_order_id=item_order.id).filter_by(
                store_item_id=data['store_item_id']).filter_by(
                store_item_variable_id=data['store_item_variable_id']).filter_by(deleted_at=None).first()

            if not old_item:
                new_item_order_list = ItemOrderLists(
                    item_order_id=item_order.id,
                    store_item_id=data['store_item_id'],
                    store_item_variable_id=data['store_item_variable_id'],
                    quantity=1,
                    removed_by=0,
                    status=1,
                    created_at=datetime.datetime.utcnow()
                )
                save_db(new_item_order_list)
                # try:
                #     db.session.add(new_item_order_list)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: ItemOrderList Error: {str(e)}")
                #     return error.__dict__, 500
                # Create item Order list
                msg = 'Item Added to cart successfully.'
                # apiResponce = ApiResponse(
                #     True, 'one more Item Added to cart successfully.', None,
                #     None)
                # return (apiResponce.__dict__), 202

            else:
                # for update
                old_item.quantity += 1
                try:
                    db.session.add(old_item)
                    db.session.commit()
                except Exception as e:
                    db.session.rollback()
                    error = ApiResponse(False, "Database Server Error", None,
                                        f"Database Name: ItemOrderList Error: {str(e)}")
                    return error.__dict__, 500

                msg = 'One More Item Added to cart successfully.'
                # apiResponce = ApiResponse(
                #             True, 'One More Item Added to cart successfully.',
                #             None, None)
                # return (apiResponce.__dict__), 200

            order_total, final_order_total, grand_order_total = calculate_order_total(
                item_order)

            item_order.order_total = order_total
            item_order.final_order_total = final_order_total
            item_order.grand_order_total = grand_order_total

            save_db(item_order)
            # try:
            #     db.session.add(item_order)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderList Error: {str(e)}")
            #     return error.__dict__, 500
            apiResponce = ApiResponse(
                True, msg, None, None)
            return (apiResponce.__dict__), 201

    except Exception as e:
        apiResponce = ApiResponse(False, 'Internal Server Error', "", str(e))
        return (apiResponce.__dict__), 500


# def checkCartWeightData(cart, item):
#     print("cart--->,item--->", cart, item)

#     return []


def existingCartData(user_id, store_id):
    # print("test.....")
    # sql = text('SELECT id from item_orders \
    #     where store_id = :store_id and user_id = :user_id and deleted_at is NULL')

    item_order = ItemOrder.query.filter_by(store_id=store_id).filter_by(
        deleted_at=None).filter_by(user_id=user_id).first()
    if item_order:
        return item_order
    else:
        return False
    

def getcartByid(data):
    
    try:

        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        cart_id = data['cart_id']
        try:
            id = re.search(r"\d+(\.\d+)?", cart_id)
            id = int(id.group(0))

        except Exception as e:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
            return (apiResponce.__dict__), 400

        cart_id = id

        cart = ItemOrder.query.filter_by(
            id=cart_id).filter_by(deleted_at=None).first()
        if not cart:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if cart.user_id != user_id:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is not belongs to the User')
            return (apiResponce.__dict__), 400

        if cart.order_created != None:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Order is allready Created')
            return (apiResponce.__dict__), 400

        items = ItemOrderLists.query.filter_by(item_order_id=cart_id).filter_by(
            deleted_at=None).order_by(ItemOrderLists.id).all()

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
                    'store_item_id': item.store_item_id
                }
                item_object.append(data)

        store = Store.query.filter_by(id=cart.store_id).first()
        calculate_order_total(cart)

        # taxes = StoreTaxes.query.filter_by(store_id = cart.store_id).filter_by(deleted_at = None).all()

        # tax_object = []
        # for tax in taxes:
        #     item_order_tax = ItemOrderTax.query.filter_by(item_order_id = cart.id).filter_by(tax_id = tax.id).first()

        #     if not item_order_tax:
        #         continue

        #     if item_order_tax.tax_type == 1:
        #         taxtype = "Percentage"
        #     else:
        #         taxtype = "Flat"

        #     tax_data = {
        #         'tax_id' : item_order_tax.id,
        #         'tax_name' : item_order_tax.tax_name,
        #         'tax_type' : taxtype,
        #         'amount' : item_order_tax.amount,
        #         'calculated' : item_order_tax.calculated,
        #     }

        #     tax_object.append(tax_data)

        response = {
            'cart_id': cart_id,
            'store_name': store.name,
            'store_id': store.id,
            'COD': bool(store.pay_later),
            # 'order_total' : order_total,
            # 'coupon_id' : cart.coupon_id,
            # 'discount' : cart.order_total_discount,
            # 'final_order_total' : final_total,
            # 'grand_order_total' : grand_total,
            'items': item_object,
            # 'tax'   : {
            #     'total_tax' : cart.total_tax,
            #     'tax_details' : tax_object
            # }
        }

        apiResponce = ApiResponse(
            True, 'Cart Fetched', response, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500


def cart_count():
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']

        city_name = request.args.get('city')

        city_id = City.query.filter(func.lower(City.name) == func.lower(
            city_name)).filter_by(deleted_at=None).first()

        if city_id:
            city_id = city_id.id

        item_orders = ItemOrder.query.filter_by(user_id=user_id).filter_by(
            deleted_at=None).filter_by(order_created=None).all()

        count = 0
        for items in item_orders:
            store = Store.query.filter_by(
                id=items.store_id).filter_by(deleted_at=None).first()

            if not store.city_id == city_id:
                continue

            count += get_count(ItemOrderLists.query.filter_by(
                item_order_id=items.id).filter_by(deleted_at=None))

        final = {
            'cart_count': count
        }

        apiResponce = ApiResponse(True, 'User Cart Data Fetched', final, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500


def cart_count_merchant(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']

        store = Store.query.filter_by(
            id=data['store_id']).filter_by(deleted_at=None).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400

        if store.status == 0:
            error = ApiResponse(False, 'Store Status Disabled', None,
                                None)
            return (error.__dict__), 400

        # city_name = request.args.get('city')
        #
        # city_id = City.query.filter(func.lower(City.name)==func.lower(city_name)).filter_by(deleted_at=None).first()
        #
        # if city_id:
        #    city_id=city_id.id

        item_order = ItemOrder.query.filter_by(user_id=user_id).filter_by(deleted_at=None).filter_by(
            order_created=None).filter_by(store_id=data['store_id']).filter_by(walk_in_order=1).first()

        count = 0

        count += get_count(ItemOrderLists.query.filter_by(
            item_order_id=item_order.id).filter_by(deleted_at=None))

        final = {
            'cart_count': count
        }

        apiResponce = ApiResponse(True, 'User Cart Data Fetched', final, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500


def fetch_merchant_cart(data):
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        store_id = data['store_id']

        store = Store.query.filter_by(id=store_id).filter_by(
            deleted_at=None).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400
        # city_name = request.args.get('city')
        #
        # city_id = City.query.filter(func.lower(City.name) == func.lower(city_name)).filter_by(deleted_at=None).first()
        #
        # if not city_id:
        #     error = ApiResponse(False, 'We do not server this city', None,
        #                         'City not found')
        #     return (error.__dict__), 400
        #
        # city_id = city_id.id

        item_order = ItemOrder.query.filter_by(user_id=user_id).filter_by(order_created=None).filter_by(
            deleted_at=None).filter_by(walk_in_order=1).filter_by(store_id=store_id).first()

        if not item_order:
            error = ApiResponse(True, "Cart Fetched Successfully", [],
                                None)
            return (error.__dict__), 200

        items = ItemOrderLists.query.filter_by(
            item_order_id=item_order.id).filter_by(deleted_at=None).all()

        # if not items:
        #     continue
        #     # error = ApiResponse(True, 'No data in cart', None,
        #     #                 None)
        #     # return (error.__dict__), 200

        resp = []

        # if not city_id == store.city_id:
        #     continue

        for item in items:

            store_item = StoreItem.query.filter_by(
                id=item.store_item_id).filter_by(deleted_at=None).first()

            if not store_item:
                item.deleted_at = datetime.datetime.utcnow()
                continue

            store_item_variable = StoreItemVariable.query.filter_by(id=item.store_item_variable_id).filter_by(
                deleted_at=None).first()

            if not store_item_variable:
                item.deleted_at = datetime.datetime.utcnow()
                continue

            quantity_unit = QuantityUnit.query.filter_by(
                id=store_item_variable.quantity_unit).first()

            obj = {
                'id': store_item.id,
                'item_order_id': item.item_order_id,
                'item_order_list_id': item.id,
                'product_in_cart_quantity': item.quantity,
                'item_brand_name': store_item.brand_name,
                'item_image': store_item.image,
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
            resp.append(obj)

        data_s = {
            'store_id': store.id,
            'store_name': store.name,
            'id': item_order.id,
            'store_item': resp
        }
        

        ret = ApiResponse(True, 'Cart data fetched', data_s, None)
        return ret.__dict__, 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        return (error.__dict__), 500


def show_all_store():
    try:

        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        role = user['role']

        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):
            records = Store.query.filter(
                Store.deleted_at == None).filter_by(status=1).all()
            if records:
                recordObject = []
                for record in records.items:
                    cityname = ""

                    if record.city:
                        cityname = record.city.name

                    commission = 0
                    if record.commission != None:
                        commission = record.commission
                    response = {
                        'id': record.id,
                        'name': record.name,
                        'slug': record.slug,
                        'image': f"{record.image}/.png",
                        'city_id': record.city_id,
                        'city_name': cityname,
                    }
                    recordObject.append(response)

                return_obj = {
                    'items': recordObject
                }

                apiResponce = ApiResponse(True, 'List of All Stores', return_obj,
                                          None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(
                    False, 'Store Not able to fetch', None, 'No Data Found')
            return (error.__dict__), 404

        elif ((user['role'] == 'merchant')):

            # get merchant_id from auth token
            user_id = user['id']

            records = Store.query.filter_by(deleted_at=None).filter_by(status=1).filter(Store.merchant_id == user_id).all()
            if records:
                print('hello')
                recordObject = []
                for record in records:
                    cityname = ""
                    if record.city:
                        cityname = record.city.name
                    response = {
                        'id': record.id,
                        'name': record.name,
                        'slug': record.slug,
                        # 'owner_name': record.owner_name,
                        # 'shopkeeper_name': record.shopkeeper_name,
                        'image': record.image,
                        'city_name': cityname,
                        
                    }
                    recordObject.append(response)

                return_obj = {
                    'items': recordObject
                }

                apiResponce = ApiResponse(True, 'List of Stores', return_obj,
                                          None)
                return (apiResponce.__dict__), 200
            else:
                error = ApiResponse(
                    False, 'Store Not able to fetch', None, 'No Data Found')
                return (error.__dict__), 404

    except Exception as e:
        error = ApiResponse(False, 'Store Not able to fetch', None, str(e))
        return (error.__dict__), 500


def fetch_user_cart():
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        city_name = request.args.get('city')

        city_id = City.query.filter(func.lower(City.name) == func.lower(
            city_name)).filter_by(deleted_at=None).first()

        if not city_id:
            error = ApiResponse(False, 'We do not server this city', None,
                                'City not found')
            return (error.__dict__), 400

        city_id = city_id.id

        item_orders = ItemOrder.query.filter_by(user_id=user_id).filter_by(
            order_created=None).filter_by(deleted_at=None).all()

        if not item_orders:
            error = ApiResponse(False, 'User Data Can not be fetched', None,
                                'Cart Not Found')
            return (error.__dict__), 400

        data = []

        for item_order in item_orders:

            store = Store.query.filter_by(
                id=item_order.store_id).filter_by(deleted_at=None).first()

            if not store:
                continue
                # error = ApiResponse(False, 'User Data Can not be fetched', None,
                #                 'Cart Not Found')
                # return (error.__dict__), 400

            items = ItemOrderLists.query.filter_by(
                item_order_id=item_order.id).filter_by(deleted_at=None).all()

            if not items:
                continue
                # error = ApiResponse(True, 'No data in cart', None,
                #                 None)
                # return (error.__dict__), 200

            resp = []

            if not city_id == store.city_id:
                continue

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
                    'id': store_item.id,
                    'item_order_id': item.item_order_id,
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
                resp.append(obj)

            data_s = {
                'store_id': store.id,
                'store_name': store.name,
                'id': item_order.id,
                'store_item': resp
            }
            data.append(data_s)

        ret = ApiResponse(True, 'Cart data fetched', data, None)
        return ret.__dict__, 200

        # ORM CODE

        # carts = ItemOrder.query.filter_by(user_id = user_id).filter_by(deleted_at = None)

        # cart_object = []
        # for cart in carts:
        #     items = ItemOrderLists.query.filter_by(item_order_id = cart.id).filter_by(deleted_at = None)

        #     item_object = []
        #     for item in items:
        #         store_item = StoreItem.query.filter_by(id = item.store_item_id).first()
        #         store_item_variable = StoreItemVariable.query.filter_by(id = item.store_item_variable_id).first()
        #         quantity = QuantityUnit.query.filter_by(id = store_item_variable.quantity_unit).first()
        #         data = {
        #             'id':item.id,
        #             'product_mrp':store_item_variable.mrp,
        #             'product_selling_price': store_item_variable.selling_price,
        #             'quantity': item.quantity,
        #             'item_variable_quantity' : store_item_variable.quantity,
        #             'item_variable_quantity_name': quantity.name,
        #             'item_variable_quantity_short_name': quantity.short_name,
        #             'item_brand_name': store_item.brand_name,
        #             'item_image_url': store_item.image,
        #             'item_name': store_item.name,
        #             'item_variable_id': item.store_item_variable_id,
        #             'store_item_id': item.store_item_id
        #         }
        #         item_object.append(data)

        #     store = Store.query.filter_by(id = cart.store_id).first()
        #     order_total, final_total, grand_total = calculate_order_total(cart)
        #     response = {
        #         'cart_id' : cart.id,
        #         'store_name' : store.name,
        #         'COD' : bool(store.pay_later),
        #         'order_total' : order_total,
        #         'coupon_id' : cart.coupon_id,
        #         'discount' : cart.order_total_discount,
        #         'final_order_total' : final_total,
        #         'grand_order_total' : grand_total,
        #         'items' : item_object,
        #     }
        #     cart_object.append(response)

        # apiResponce = ApiResponse(True, 'User Cart Data Fetched'
        #     ,cart_object, None)
        # return (apiResponce.__dict__), 200

        # NOT ORM CODE

        # sql = text('SELECT item_orders.id as item_order_id,\
        #             item_order_lists.id as item_order_list_id,\
        #             item_orders.store_id as store_id,\
        #             store_item_variable.mrp as product_mrp,\
        #             store_item_variable.selling_price as product_selling_price,\
        #             item_order_lists.quantity as product_quantity,\
        #             quantity_unit.name as quantity_name,\
        #             quantity_unit.short_name as quantity_short_name,\
        #             store.name as store_name,\
        #             store_item.brand_name as item_brand_name ,\
        #             store_item.image as item_image_url,\
        #             store_item.name as item_name,\
        #             store_item.id as store_item_id,\
        #             store_item_variable.id as store_item_variable_id,\
        #             store_item_variable.quantity as store_item_variable_quantity\
        #             FROM item_orders\
        #             join item_order_lists on item_orders.id = item_order_lists.item_order_id\
        #             join store_item_variable on item_order_lists.store_item_variable_id = store_item_variable.id\
        #             join quantity_unit on store_item_variable.quantity_unit = quantity_unit.id\
        #             join store_item on store_item_variable.store_item_id = store_item.id\
        #             join store on item_orders.store_id = store.id\
        #             WHERE item_orders.user_id = :user_id\
        #             and item_orders.deleted_at IS NULL\
        #             and item_order_lists.deleted_at IS NULL\
        #             and item_orders.order_created IS NULL\
        #             ORDER by item_orders.id DESC'
        #         )
        # result = db.engine.execute(sql, {'user_id': user_id})

        # fetchCartDetails = []
        # empty_dict = {}
        # for row in result:
        #     if row[2] in list(empty_dict.keys()):
        #         for i in range(len(fetchCartDetails)):
        #             if fetchCartDetails[i]['store_id'] == row[2]:
        #                 fetchCartDetails[i]['store_item'].append({
        #                     "id": row[12],
        #                     'item_order_id': row[0],
        #                     'item_order_list_id': row[1],
        #                     'product_in_cart_quantity': row[5],
        #                     'item_brand_name': row[9],
        #                     'item_brand_url': row[10],
        #                     'item_name': row[11],
        #                     "item_variable_id": row[13],
        #                     # 'store_id': row[2],

        #                     "item_variable":

        #                         {
        #                             "id":row[13],
        #                             'product_mrp': row[3],
        #                             'product_selling_price': row[4],
        #                             'quantity': row[14],   # store_item_variable.quantity
        #                             'quantity_name': row[6],
        #                             'quantity_short_name': row[7],
        #                             # 'store_name': row[8],
        #                         },
        #                 })

        #     else:
        #         empty_dict[row[2]] = row[8]
        #         recordObject = {
        #             'store_id': row[2],
        #             'store_name': row[8],
        #             'id':row[0],
        #             'store_item': [
        #                 {
        #                     "id": row[12],   # store_item.id
        #                     'item_order_id': row[0],
        #                     'item_order_list_id': row[1],
        #                     'product_in_cart_quantity': row[5],
        #                     'item_brand_name': row[9],
        #                     'item_brand_url': row[10],
        #                     'item_name': row[11],
        #                     # 'store_id': row[2],
        #                     "item_variable_id": row[13],

        #                     "item_variable":
        #                         {
        #                             "id":row[13],   # item_variable.id
        #                             'product_mrp': row[3],
        #                             'product_selling_price': row[4],
        #                             'quantity': row[14],
        #                             'quantity_name': row[6],
        #                             'quantity_short_name': row[7],
        #                             # 'store_name': row[8],
        #                         },
        #                 }
        #             ]
        #         }

        #     fetchCartDetails.append((recordObject))
        # fetchCartDetails = [i for j, i in enumerate(fetchCartDetails) if i not in fetchCartDetails[:j]]
        # #fetchCartDetails = sorted(fetchCartDetails, key=itemgetter('store_id'))
        # finalResult = []

        # for key, value in groupby(fetchCartDetails):
        #     finalResult.append(list(value))
        # finalResult_without_array = []
        # for i in range(len(finalResult)):
        #     finalResult_without_array.append(finalResult[i][0])

        # apiResponce = ApiResponse(True, 'User Cart Data Fetched'
        #     ,finalResult_without_array, None)
        # return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        print("test6")
        return (error.__dict__), 500

        #result = []
        # result.append([])

        # for element in fetchCartDetails:
        #    result[element['store_id']].append(element)

        # from collections import defaultdict
        # res = defaultdict(list)
        # for key, val in fetchCartDetails[0].items():
        #     res[val].append(key)


def get_quantity_count(item_order_list_id):
    try:
        sql = text(
            'SELECT  item_order_lists.quantity \
            FROM item_order_lists where item_order_lists.id = :item_order_list_id')
        result = db.engine.execute(
            sql, {'item_order_list_id': item_order_list_id})
        quantity_count_list = []
        for row in result:
            quantity_count_list.append(row[0])

        return quantity_count_list[0]
    except Exception as e:
        return "item_order_list_id not present"


def update_item_from_cart_merchant(data):
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        if data['method'] not in ['+','-']:
            error = error = ApiResponse(False, 'Wrong Method Code', None, None)
            return error.__dict__, 400

        if(user['role'] == 'merchant'):

            current_time = datetime.datetime.utcnow()
            item_order_list = ItemOrderLists.query.filter_by(id=data['item_order_list_id']).filter_by(
                deleted_at=None).first()
            
            if not item_order_list:
                error = error = ApiResponse(False, 'item does not exist in your cart', None,
                                            str("item not exit in cart"))
                return error.__dict__, 400
            
            item_order_id = item_order_list.item_order_id
            item_order = ItemOrder.query.filter_by(id=item_order_id).filter_by(user_id=user_id).filter_by(
                order_created=None).filter_by(store_id=data['store_id']).filter_by(walk_in_order = 1).filter_by(deleted_at=None)
            
            if not item_order:
                error = error = ApiResponse(False, f'item order does not exist or order deleted in your cartId {item_order_id}', None,
                                            str("cart not exit in cart"))
                return error.__dict__, 400

            item_order_id = item_order_list.item_order_id
            item_quantity = item_order_list.quantity
            
            if data['method'] == '-' :
                # if the quantity os more than 1
                if (item_quantity > 1):
                    item_order_list.quantity = item_quantity - 1
                    item_order_list.updated_at = current_time

                    save_db(item_order_list, "ItemOrderList")
                    

                    apiResponce = ApiResponse(
                        True, 'User Cart item Data Removed by 1', None, None)
                    return (apiResponce.__dict__), 200

                # if the quantity is 1
                else:
                    # delete the item variant
                    item_order_list.quantity = item_quantity - 1
                    item_order_list.updated_at = current_time
                    item_order_list.deleted_at = current_time

                    save_db(item_order_list, "ItemOrderList")
                    

                    exist_item_order_variable = check_item_order_variable(
                        item_order_id)
                    
                    # if another item variable does not exist in cart
                    
                    if not len(exist_item_order_variable):
                        sql = text(
                            'UPDATE item_orders SET deleted_at = :current_time WHERE id = :item_order_id;'
                        )
                        resultdetails = db.engine.execute(
                            sql, {
                                'item_order_id': item_order_id,
                                'current_time': current_time
                            })
                        apiResponce = ApiResponse(
                            True, 'Item and item variable was removed from cart.', None,
                            None)
                        return (apiResponce.__dict__), 200

                    else:
                        apiResponce = ApiResponse(
                            True,
                            'One item variable was removed from cart.',
                            None, None)
                        return (apiResponce.__dict__), 200

            else:
                item_order_list.quantity = item_quantity + 1
                item_order_list.updated_at = current_time

                save_db(item_order_list, "ItemOrderList")
                

                apiResponce = ApiResponse(
                    True, 'Item Increased by 1', None, None)
                return (apiResponce.__dict__), 200 

    except Exception as e:
        error = ApiResponse(False, 'User Cart Item Can not be Deleted', None,
                            str(e))
        return (error.__dict__), 500


def fetch_user_cart_new():
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        city_name = request.args.get('city')

        city_id = City.query.filter(func.lower(City.name) == func.lower(
            city_name)).filter_by(deleted_at=None).first()

        if not city_id:
            error = ApiResponse(False, 'We do not server this city', None,
                                'City not found')
            return (error.__dict__), 400

        city_id = city_id.id

        item_orders = ItemOrder.query.filter_by(user_id=user_id).filter_by(
            order_created=None).filter_by(deleted_at=None).all()

        if not item_orders:
            error = ApiResponse(False, 'User Data Can not be fetched', None,
                                'Cart Not Found')
            return (error.__dict__), 400

        data = []

        for item_order in item_orders:

            store = Store.query.filter_by(
                id=item_order.store_id).filter_by(deleted_at=None).first()

            if not store:
                continue
                # error = ApiResponse(False, 'User Data Can not be fetched', None,
                #                 'Cart Not Found')
                # return (error.__dict__), 400

            items = ItemOrderLists.query.filter_by(
                item_order_id=item_order.id).filter_by(deleted_at=None).all()

            if not items:
                continue
                # error = ApiResponse(True, 'No data in cart', None,
                #                 None)
                # return (error.__dict__), 200

            resp = []

            if not city_id == store.city_id:
                continue

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
                    'id': store_item.id,
                    'item_order_id': item.item_order_id,
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
                resp.append(obj)

            data_s = {
                'store_id': store.id,
                'store_name': store.name,
                'id': item_order.id,
                'store_item': resp
            }
            data.append(data_s)

        ret = ApiResponse(True, 'Cart data fetched', data, None)
        return ret.__dict__, 200


    except Exception as e:
        error = ApiResponse(False, 'User Data Can not be fetched', None,
                            str(e))
        print("test6")
        return (error.__dict__), 500






def remove_specific_item_completely_merchant(data):
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']
        #cart_id = data['cart_id']
        if(user['role'] == 'merchant'):
            current_time = datetime.datetime.utcnow()
            item_order1 = ItemOrder.query.filter_by(user_id=user_id).filter_by(store_id=data['store_id']).filter_by(
                walk_in_order=1).filter_by(order_created=None).filter_by(deleted_at=None).first()
            if not item_order1:
                error = error = ApiResponse(False, 'No cart found', None,
                                            str("No cart found"))
                return error.__dict__, 400

            item_order_list1 = ItemOrderLists.query.filter_by(
                item_order_id=item_order1.id).filter_by(deleted_at=None).all()

            if not item_order_list1:
                error = error = ApiResponse(False, 'No item found in cart', None,
                                            str("No item found in cart"))
                return error.__dict__, 400

            list_of_item_order_list_ids = []

            for item in item_order_list1:
                list_of_item_order_list_ids.append(item.id)

            if data['item_order_list_id'] not in list_of_item_order_list_ids:
                error = error = ApiResponse(False, f"invalid item order list id {data['item_order_list_id']}", None,
                                            str(f"invalid item order list id {data['item_order_list_id']}"))
                return error.__dict__, 400

            item_order_list = ItemOrderLists.query.filter_by(id=data['item_order_list_id']).filter_by(
                deleted_at=None).first()
            if not item_order_list:
                error = error = ApiResponse(False, 'item does not exist in your cart', None,
                                            str("item not exit in cart"))
                return error.__dict__, 400
            itemOrderListValid = []
            # item_order_id = item_order_list.item_order_id
            # item_order  = ItemOrder.query.filter_by(id= item_order_id).filter_by(user_id=user_id).filter_by(order_created=None).filter_by(store_id=data['store_id']).filter_by(deleted_at= None)
            # if not item_order:
            #     error = error = ApiResponse(False, f'item order does not exist or order deleted in your cartId {item_order_id}', None,
            #                                 str("cart not exit in cart"))
            #     return error.__dict__, 400
            # # for row in result:
            # recordObject = {
            #     'id': item_order_list.id,
            #     'item_order_id': item_order_list.item_order_id,
            #     'store_item_id': item_order_list.store_item_id,
            #     'store_item_variable_id': item_order_list.store_item_variable_id,
            #     'quantity': item_order_list.quantity,
            # }

            if len(list_of_item_order_list_ids) == 1:
                item_order_list.deleted_at = current_time
                item_order_list.updated_at = current_time

                save_db(item_order_list)
                # try:
                #     db.session.add(item_order_list)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: ItemOrderList Error: {str(e)}")
                #     return error.__dict__, 500
                item_order1.deleted_at = current_time
                item_order1.updated_at = current_time
                
                save_db(item_order1)
                # try:
                #     db.session.add(item_order1)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: ItemOrder Error: {str(e)}")
                #     return error.__dict__, 500

                apiResponce = ApiResponse(
                    True,
                    'One item variable was removed from cart and cart also removed.',
                    None, None)
                return (apiResponce.__dict__), 200

            else:
                item_order_list.deleted_at = current_time
                item_order_list.updated_at = current_time

                save_db(item_order_list)
                # try:
                #     db.session.add(item_order_list)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: ItemOrderList Error: {str(e)}")
                #     return error.__dict__, 500

                apiResponce = ApiResponse(
                    True,
                    'One item variable was removed from cart.',
                    None, None)
                return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'User Cart Item Can not be Deleted', None,
                            str(e))
        return (error.__dict__), 500


def remove_from_cart(data):
    try:
        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        current_time = datetime.datetime.utcnow()
        item_order_list = ItemOrderLists.query.filter_by(
            id=data['item_order_list_id']).filter_by(deleted_at=None).first()

        itemOrder = ItemOrder.query.filter_by(id=item_order_list.item_order_id).filter_by(deleted_at=None).first()
        if itemOrder.user_id != user_id:
            error = error = ApiResponse(False, 'user id is not valid for this operation', None,
                                        str("item not exit in cart"))
            return error.__dict__, 400

        if not item_order_list:
            error = error = ApiResponse(False, 'item does not exist in your cart', None,
                                        str("item not exit in cart"))
            return error.__dict__, 400
        itemOrderListValid = []

        # for row in result:
        recordObject = {
            'id': item_order_list.id,
            'item_order_id': item_order_list.item_order_id,
            'store_item_id': item_order_list.store_item_id,
            'store_item_variable_id': item_order_list.store_item_variable_id,
            'quantity': item_order_list.quantity,
        }

        item_order_id = item_order_list.item_order_id
        item_quantity = item_order_list.quantity
        itemOrderListValid.append(recordObject)
        # Not empty Check for item order list with item id
        if len(itemOrderListValid):
            sql = text('SELECT * FROM item_orders where id = :item_order_id')
            resultdetails = db.engine.execute(sql,
                                              {'item_order_id': item_order_id})
            itemOrderValid = []

            for row in resultdetails:
                recordObject = {
                    'id': row[0],
                }
            itemOrderValid.append(recordObject)
            # Not empty Check for item order with item id
            print("itemOrderValid:-", itemOrderValid)
            if len(itemOrderValid):
                # if the quantity os more than 1
                if (item_quantity > 1):

                    sql = text(
                        'UPDATE item_order_lists SET quantity = (quantity-1), deleted_at = NULL, updated_at = :current_time WHERE item_order_lists.id = :item_order_list_id'
                    )

                    resultdetails = db.engine.execute(
                        sql,
                        {'item_order_list_id': data['item_order_list_id'], 'current_time': current_time})
                    apiResponce = ApiResponse(
                        True, 'User Cart item Data Removed by 1', None, None)
                    return (apiResponce.__dict__), 200

                # if the quantity is 1
                else:
                    # delete the item variant
                    sql = text(
                        'UPDATE item_order_lists SET deleted_at = :current_time, quantity = 0 WHERE id = :item_order_list_id;'
                    )

                    resultdetails = db.engine.execute(
                        sql, {
                            'item_order_list_id': data['item_order_list_id'],
                            "current_time": current_time
                        })
                    exist_item_order_variable = check_item_order_variable(
                        item_order_id)
                    print("exist_item_order_variable:-",
                          len(exist_item_order_variable))
                    # if another item variable does not exist in cart
                    if not len(exist_item_order_variable):
                        sql = text(
                            'UPDATE item_orders SET deleted_at = :current_time, updated_at = :current_time WHERE id = :item_order_id;'
                        )

                        resultdetails = db.engine.execute(
                            sql, {
                                'item_order_id': item_order_id,
                                'current_time': current_time
                            })
                        custom_res = {
                            'custom_status_code': 205
                        }
                        apiResponce = ApiResponse(
                            True, 'User Cart item Data Removed by 1 and cart not exist', custom_res, None)
                        return (apiResponce.__dict__), 200

                    else:
                        apiResponce = ApiResponse(
                            True,
                            'One item variable was removed from cart.',
                            None, None)
                        return (apiResponce.__dict__), 200

            else:
                apiResponce = ApiResponse(False,
                                          'Invalid Order. Try Again Later',
                                          str(itemOrderValid), None)
                return (apiResponce.__dict__), 400
        else:
            apiResponce = ApiResponse(False, 'Invalid Item. Try Again Later',
                                      str(itemOrderListValid), None)
            return (apiResponce.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'User Cart Item Can not be Deleted', None,
                            str(e))
        return (error.__dict__), 500


def check_item_order_variable(item_order_id):

    # sql = text(
    #     'SELECT * FROM item_order_lists where item_order_id = :item_order_id')
    result = ItemOrderLists.query.filter_by(
        item_order_id=item_order_id).filter_by(deleted_at=None)

    # result = db.engine.execute(sql, {'item_order_id': item_order_id})
    exist_item_order = []

    for row in result:

        exist_item_order.append(row)
    return exist_item_order


def get_cart(data):
    sql = text(
        'SELECT * FROM item_order_lists where item_order_id = :item_order_id')

    result = db.engine.execute(sql, {'item_order_id': data['item_order_id']})
    exist_item_order = []

    for row in result:

        exist_item_order = row
    return exist_item_order


def remove_cart(data):
    try:
        # 'SELECT * FROM item_order_lists where item_order_id = :item_order_id')
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        cart_id = data['cart_id']
        deleted_at = datetime.datetime.utcnow()
        # begin_sql = text('BEGIN')
        # db.engine.execute(begin_sql)
        item_orders = ItemOrder.query.filter_by(id=cart_id).filter_by(
            deleted_at=None).filter_by(user_id=user['id']).first()
        if not item_orders:
            # error = ApiResponse(False, cart_id + " not able to fetch the cart id", None,
            #                    "cart_id " + cart_id + "  is not present is item orders Database")
            error = ApiResponse(False, "Database Server Error", None,
                                f"Database Name: {cart_id} not present in ItemOrders")
            return error.__dict__, 400

        item_order_lists = ItemOrderLists.query.filter_by(
            item_order_id=cart_id)

        for item_order_list in item_order_lists:
            item_order_list.deleted_at = deleted_at

            save_db(item_order_list)
            # try:
            #     db.session.add(item_order_list)
            #     db.session.commit()
            # except Exception as e:
            #     db.session.rollback()
            #     error = ApiResponse(False, "Database Server Error", None,
            #                         f"Database Name: ItemOrderLists Error: {str(e)} while deleting of {item_order_list.id}")
            #     return error.__dict__, 500

        item_orders.deleted_at = deleted_at
        save_db(item_orders)
        # try:
        #     db.session.add(item_orders)
        #     db.session.commit()
        # except Exception as e:
        #     db.session.rollback()
        #     error = ApiResponse(False, "Database Server Error", None,
        #                         f"Database Name: ItemOrders Error: {str(e)}")
        #     return error.__dict__, 500

        apiResponce = ApiResponse(
            True, 'cart removed Successfully.', None, None)
        return (apiResponce.__dict__), 201
        # return "successfully removed"

    except Exception as e:
        # rollback_sql = text('ROLLBACK')
        # db.engine.execute(rollback_sql)
        error = ApiResponse(False, 'User Cart not removed', None,
                            str(e))
        return (error.__dict__), 500
    # 'created_at': datetime.datetime.utcnow()


def get_delivery_price(data):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        try:
            #order_id = int(data['order_id'][4:])
            order_id = data['order_id']
            order_id = re.search(r"\d+(\.\d+)?", order_id)
            order_id = int(order_id.group(0))

        except Exception as e:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong')
            return (apiResponce.__dict__), 400

        order = ItemOrder.query.filter_by(
            id=order_id).filter_by(deleted_at=None).first()

        if not order:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Order Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if order.user_id != user['id']:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, "This Order doesn't belong to the Current User")
            return (apiResponce.__dict__), 400

        if order.user_address_id == data['address_id']:
            apiResponce = ApiResponse(
                True, 'Address Already Selected', {'delivery_fee': order.delivery_fee, 'order_total': order.order_total, 'final_order_total': order.final_order_total, 'grand_order_total': order.grand_order_total}, "Given Address id is allready Selected with the Cart")
            return (apiResponce.__dict__), 200

        address = UserAddress.query.filter_by(
            id=data['address_id']).filter_by(deleted_at=None).first()

        if not address:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Address Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if address.user_id != user['id']:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'User id Not Matched with the Address')
            return (apiResponce.__dict__), 400

        store = Store.query.filter_by(
            id=order.store_id, deleted_at=None).first()

        if not store:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Store Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        delivery_fee, msg = delivery_fee_calc(order, store, address)
        calculate_order_total(order)

        order.user_address_id = address.id

        save_db(order)
        # try:
        #     db.session.add(order)
        #     db.session.commit()
        # except Exception as e:
        #     db.session.rollback()
        #     error = ApiResponse(False, "Database Server Error",
        #                         None, f"Database Name: ItemOrder Error: {str(e)}")
        #     return error.__dict__, 500

        #apiResponce = ApiResponse(True, msg , {'delivery_fee' : delivery_fee, 'order_total' : order_total, 'final_order_total': final_order_total, 'grand_order_total': grand_order_total}, None)
        apiResponce = ApiResponse(True, msg, None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500


def get_order_calculated(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        cart_id = data['cart_id']

        if not isinstance(cart_id, int):
            try:
                id = re.search(r"\d+(\.\d+)?", cart_id)
                id = int(id.group(0))

            except Exception as e:
                apiResponce = ApiResponse(
                    False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
                return (apiResponce.__dict__), 400

            cart_id = id

        cart = ItemOrder.query.filter_by(
            id=cart_id).filter_by(deleted_at=None).first()
        if not cart:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong or Deleted')
            return (apiResponce.__dict__), 400

        if cart.user_id != user_id:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is not belongs to the User')
            return (apiResponce.__dict__), 400

        if cart.order_created != None:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Order is allready Created')
            return (apiResponce.__dict__), 400

        order_total, final_order_total, grand_order_total = calculate_order_total(
            cart)
        discount = None
        coupon_id = None
        coupon_code = None
        deduction_amount = None
        deduction_type = None

        if cart.order_total_discount and cart.coupon_id:

            coupon = Coupon.query.filter_by(id=cart.coupon_id).filter_by(deleted_at=None).first()
            if coupon:

                coupon_code = coupon.code
                discount = cart.order_total_discount
                coupon_id = cart.coupon_id
                deduction_amount = coupon.deduction_amount

                if coupon.deduction_type == '1':
                    deduction_type = "Percentage"
                else:
                    deduction_type = "Flat"
            else:
                cart.order_total_discount = None
                cart.coupon_id = None

                save_db(cart, "Item Cart")
                

        delivery_fee = 0
        delivery_address = None

        if cart.delivery_fee:
            delivery_fee = cart.delivery_fee
            delivery_address = cart.user_address_id

        # store = Store.query.filter_by(id = cart.store_id).filter_by(deleted_at = None).all()

        taxes = StoreTaxes.query.filter_by(
            store_id=cart.store_id).filter_by(deleted_at=None).all()

        tax_object = []

        for tax in taxes:
            item_order_tax = ItemOrderTax.query.filter_by(
                item_order_id=cart.id).filter_by(tax_id=tax.id).first()

            if item_order_tax == None:
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

        total_tax = cart.total_tax

        response_object = {
            'order_total': order_total,
            'final_order_total': final_order_total,
            'total_tax': total_tax,
            'grand_order_total': grand_order_total,
            'tax_details': tax_object,
            'delivery': {
                'fee': delivery_fee,
                'address': delivery_address
            },
            'coupon': {
                'id': coupon_id,
                'coupon_code': coupon_code,
                'deduction_amount': deduction_amount,
                'deduction_type': deduction_type,
                'discount': discount
            }
        }

        apiResponce = ApiResponse(
            True, '', response_object, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None,
                            str(e))
        return (error.__dict__), 500


def globelSearch_func(data):
    try:
        searchString = data['search_string']
        search = "%{}%".format(searchString)

        if len(search) < 4:
            error = ApiResponse(True, 'List of search items', [],
                                None)
            return (error.__dict__), 200

        print(search, "<<<=====")
        #item_name = data['item_name']
        store_id = data['store_id']
        resp, status = Auth.get_logged_in_user(request)
        merchant_id = resp['data']['id']

        store = Store.query.filter_by(id=store_id).filter_by(status=1).first()

        if not store:
            error = ApiResponse(False, 'Store Not Found', None,
                                None)
            return (error.__dict__), 400

        if store.deleted_at != None:
            error = ApiResponse(False, 'Store was Deleted', None,
                                None)
            return (error.__dict__), 400

        store_merchant = Store.query.filter_by(id=store_id).filter_by(
            merchant_id=merchant_id).filter_by(deleted_at=None)
        if not store_merchant:
            error = ApiResponse(False, 'Merchant Has No Access', None,
                                None)
            return (error.__dict__), 403

        store_items = StoreItem.query.filter(or_(func.lower(StoreItem.name).like(func.lower(search)), func.lower(
            StoreItem.brand_name).like(func.lower(search)))).filter_by(store_id=store_id).filter_by(status=1).filter_by(deleted_at=None).all()

        if not store_items:
            error = ApiResponse(True, None, [],
                                None)
            return (error.__dict__), 200

        vars = []
        for record in store_items:

            item_variables = StoreItemVariable.query.filter_by(
                store_item_id=record.id).filter_by(status=1).filter_by(deleted_at=None).all()

            if not item_variables:
                continue

            for item in item_variables:
                quantity = QuantityUnit.query.filter_by(
                    id=item.quantity_unit).first()
                obj = {
                    'store_item_id': record.id,
                    'name': record.name,
                    'store_id': record.store_id,
                    'brand_name': record.brand_name,
                    'image': record.image,
                    'packaged': record.packaged,
                    'store_item_variable_id': item.id,
                    'quantity': item.quantity,
                    'store_item_id': item.store_item_id,
                    'quantity_unit': quantity.name,
                    'mrp': item.mrp,
                    'selling_price': item.selling_price,
                    'stock': item.stock,
                }
                vars.append(obj)

        apiResponce = ApiResponse(True, 'List of search items', vars,
                                  None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Store item Not able to Fetch', None,
                            str(e))
        return (error.__dict__), 500

