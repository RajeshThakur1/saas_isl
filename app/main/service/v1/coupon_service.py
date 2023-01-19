from sqlalchemy import or_
from flask.helpers import url_for
from app.main.model.category import Category
from app.main.model.userCities import UserCities
from app.main.service.v1.image_service import image_upload
from app.main.service.v1.fileupload_ import check_file
from werkzeug.utils import secure_filename
from app.main.util.v1.database import save_db
from app.main.util.v1.dateutil import str_to_date
from app.main.util.v1.orders import calculate_order_total, order_total_calculate
from app.main.model.itemOrders import ItemOrder
from app.main.model.store import Store
import datetime
from itertools import groupby

from re import search
from app.main import db
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.coupon import Coupon
from app.main.model.couponMerchant import CouponMerchant
from app.main.model.couponCategories import CouponCategories
from app.main.model.couponCities import CouponCities
from app.main.model.couponStores import CouponStores
from app.main.model.user import User
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from sqlalchemy import text
import re
from app.main.config import coupon_banner1_dir, coupon_banner2_dir, item_per_page, ENDPOINT_PREFIX
from sqlalchemy import func
from sqlalchemy import or_


import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/coupon_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")


def create_coupon(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')):
    try:

        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        # if (data['user_mobile']):
        #     user_id = get_user_by_phone(data['user_mobile'])
        # else:
        #     user_id = None
        if data['deduction_type'] not in [1, 2]:
            error = ApiResponse(
                False, 'Wrong Deduction Type Code Provided ', None, None)
            return (error.__dict__), 400

        if resp['data']['role'] == 'supervisor':
            try:
                city_id = data['city_id']
                if not city_id:
                    error = ApiResponse(False, f'supervisor not applicable to create coupon without city id',
                                        None, "supervisor not applicable to create coupon without city id")
                    return (error.__dict__), 500
                # checking the validation of city Id of the supervisor
                for record in data['city_id']:
                    supervisor_city = UserCities.query.filter_by(user_id=user_id).filter_by(
                        city_id=record).filter_by(deleted_at=None).first()
                    if not supervisor_city:
                        error = ApiResponse(
                            False, f'supervisor not applicable to create coupon for city id [ {record} ]', None, f"city id {record} not valid city")
                        return (error.__dict__), 500

                check_coupon = Coupon.query.filter(func.lower(Coupon.code) == func.lower(data['code'])).filter_by(
                    deleted_at=None).first()

                if check_coupon:
                    error = ApiResponse(False, f"Coupon {data['code']} allready exists", None,
                                        f"Coupon {data['code']} allready exists")
                    return (error.__dict__), 400

                data['banner_1'] = coupon_banner1_dir + \
                    secure_filename(data['banner_1'])
                data['banner_2'] = coupon_banner2_dir + \
                    secure_filename(data['banner_2'])

                if not check_file(data['banner_1']) or not check_file(data['banner_2']):
                    data['banner_1'] = coupon_banner1_dir + "default.png"

                    data['banner_2'] = coupon_banner2_dir + "default.png"

                coupon = Coupon(code=data['code'],
                                title=data['title'],
                                description=data['description'],
                                level=data['level'],
                                target=data['target'],
                                deduction_type=data['deduction_type'],
                                deduction_amount=data['deduction_amount'],
                                max_deduction=data['max_deduction'],
                                min_order_value=data['min_order_value'],
                                max_user_usage_limit=data['max_user_usage_limit'],
                                is_display=data['is_display'],
                                previous_order_track=data['previous_order_track'],
                                expired_at=data['expired_at'],
                                banner_1=data['banner_1'],
                                banner_2=data['banner_2'],
                                user_id=user_id,
                                status=1,
                                created_at=datetime.datetime.utcnow())
                save_db(coupon)
                # db.session.add(coupon)
                # db.session.commit()
                if (data['category_id']):
                    for record in data['category_id']:
                        new_coupon_cat_map = CouponCategories(
                            coupon_id=coupon.id,
                            category_id=record,
                            status='1',
                            created_at=datetime.datetime.utcnow())
                        save_db(new_coupon_cat_map)
                        # db.session.add(new_coupon_cat_map)
                        # db.session.commit()

                if (data['city_id']):
                    for record in data['city_id']:
                        new_coupon_cat_map = CouponCities(
                            coupon_id=coupon.id,
                            city_id=record,
                            status='1',
                            created_at=datetime.datetime.utcnow())
                        save_db(new_coupon_cat_map)
                        # db.session.add(new_coupon_cat_map)
                        # db.session.commit()

                apiResponce = ApiResponse(True, 'Coupon Created successfully',
                                          None, None)
                return (apiResponce.__dict__), 201

            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Create', None,
                                    str(e))
                return (error.__dict__), 500

        elif resp['data']['role'] == 'super_admin':
            check_coupon = Coupon.query.filter(func.lower(Coupon.code) == func.lower(
                data['code'])).filter_by(deleted_at=None).first()

        if check_coupon:
            error = ApiResponse(
                False, f"Coupon {data['code']} allready exists", None, f"Coupon {data['code']} allready exists")
            return (error.__dict__), 400

        if (data['city_id']):
            for record in data['city_id']:

                city = City.query.filter_by(
                    id=record).filter_by(deleted_at=None).first()
                if not city:
                    error = ApiResponse(
                        False, f'City id {record} not found', None,)
                    return (error.__dict__), 400

                if city.status == 0:
                    error = ApiResponse(
                        False, f'City {city.name} is disabled', None,)
                    return (error.__dict__), 400

        if (data['category_id']):
            for record in data['category_id']:
                category = Category.query.filter_by(
                    id=record).filter_by(deleted_at=None).first()
                if not category:
                    error = ApiResponse(
                        False, f'Category id {record} not found', None,)
                    return (error.__dict__), 400

                if category.status == 0:
                    error = ApiResponse(
                        False, f'Category {category.name} is disabled', None,)
                    return (error.__dict__), 400

        if data['is_display'] not in [0, 1]:
            error = ApiResponse(
                False, f'Wrong is_display Code provided ', None)
            return (error.__dict__), 400

        data['banner_1'] = coupon_banner1_dir + \
            secure_filename(data['banner_1'])
        data['banner_2'] = coupon_banner2_dir + \
            secure_filename(data['banner_2'])

        if not check_file(data['banner_1']):
            data['banner_1'] = coupon_banner1_dir + "default.png"

        if not check_file(data['banner_2']):
            data['banner_2'] = coupon_banner2_dir + "default.png"

        userId_for_coupon_created = None
        if (data['user_mobile']):
            user_for_coupon_created = User.query.filter_by(phone=data['user_mobile']).filter_by(deleted_at=None).first()
            userId_for_coupon_created = user_for_coupon_created.id
        coupon = Coupon(code=data['code'],
                        title=data['title'],
                        description=data['description'],
                        level=data['level'],
                        target=data['target'],
                        deduction_type=data['deduction_type'],
                        deduction_amount=data['deduction_amount'],
                        max_deduction=data['max_deduction'],
                        min_order_value=data['min_order_value'],
                        max_user_usage_limit=data['max_user_usage_limit'],
                        is_display=data['is_display'],
                        previous_order_track=data['previous_order_track'],
                        expired_at=data['expired_at'],
                        banner_1=data['banner_1'],
                        banner_2=data['banner_2'],
                        user_id=userId_for_coupon_created,
                        status=1,
                        created_at=datetime.datetime.utcnow())

        save_db(coupon, "Coupons")
        

        if (data['category_id']):
            for record in data['category_id']:

                new_coupon_cat_map = CouponCategories(
                    coupon_id=coupon.id,
                    category_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map, "CouponCategories")
                

        if (data['city_id']):
            for record in data['city_id']:

                new_coupon_cat_map = CouponCities(
                    coupon_id=coupon.id,
                    city_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map, "CouponCities")
                

        apiResponce = ApiResponse(True, 'Coupon Created successfully',
                                  None, None)
        return (apiResponce.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Create', None,
                            str(e))
        return (error.__dict__), 500


def create_coupon_new(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin')):
    try:

        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        # if (data['user_mobile']):
        #     user_id = get_user_by_phone(data['user_mobile'])
        # else:
        #     user_id = None
        if data['deduction_type'] not in [1, 2]:
            error = ApiResponse(
                False, 'Wrong Deduction Type Code Provided ', None, None)
            return (error.__dict__), 400

        if resp['data']['role'] == 'supervisor':
            try:
                city_id = data['city_id']
                if not city_id:
                    error = ApiResponse(False, f'supervisor not applicable to create coupon without city id',
                                        None, "supervisor not applicable to create coupon without city id")
                    return (error.__dict__), 500
                # checking the validation of city Id of the supervisor
                for record in data['city_id']:
                    supervisor_city = UserCities.query.filter_by(user_id=user_id).filter_by(
                        city_id=record).filter_by(deleted_at=None).first()
                    if not supervisor_city:
                        error = ApiResponse(
                            False, f'supervisor not applicable to create coupon for city id [ {record} ]', None, f"city id {record} not valid city")
                        return (error.__dict__), 500

                check_coupon = Coupon.query.filter(func.lower(Coupon.code) == func.lower(data['code'])).filter_by(
                    deleted_at=None).first()

                if check_coupon:
                    error = ApiResponse(False, f"Coupon {data['code']} allready exists", None,
                                        f"Coupon {data['code']} allready exists")
                    return (error.__dict__), 400

                if data['banner_1'] == "default":
                    data['banner_1'] = coupon_banner1_dir + "default"

                else:
                    image_file, status = image_upload(
                        data['banner_1'], coupon_banner1_dir, data['code'])
                    if status == 400:
                        return image_file, status
                    data['banner_1'] = image_file

                if data['banner_2'] == "default":
                    data['banner_2'] = coupon_banner1_dir + "default"

                else:
                    image_file, status = image_upload(
                        data['banner_2'], coupon_banner2_dir, data['code'])
                    if status == 400:
                        return image_file, status

                    data['banner_2'] = image_file

                coupon = Coupon(code=data['code'],
                                title=data['title'],
                                description=data['description'],
                                level=data['level'],
                                target=data['target'],
                                deduction_type=data['deduction_type'],
                                deduction_amount=data['deduction_amount'],
                                max_deduction=data['max_deduction'],
                                min_order_value=data['min_order_value'],
                                max_user_usage_limit=data['max_user_usage_limit'],
                                is_display=data['is_display'],
                                previous_order_track=data['previous_order_track'],
                                expired_at=data['expired_at'],
                                banner_1=data['banner_1'],
                                banner_2=data['banner_2'],
                                user_id=user_id,
                                status=1,
                                created_at=datetime.datetime.utcnow())
                save_db(coupon,"Coupon")
                # db.session.add(coupon)
                # db.session.commit()
                if (data['category_id']):
                    for record in data['category_id']:
                        new_coupon_cat_map = CouponCategories(
                            coupon_id=coupon.id,
                            category_id=record,
                            status='1',
                            created_at=datetime.datetime.utcnow())
                        save_db(new_coupon_cat_map, "CouponCategories")
                        # db.session.add(new_coupon_cat_map)
                        # db.session.commit()

                if (len(data['city_id'])==0):
                    for record in data['city_id']:
                        new_coupon_cat_map = CouponCities(
                            coupon_id=coupon.id,
                            #city_id=record,
                            status='1',
                            created_at=datetime.datetime.utcnow())
                        save_db(new_coupon_cat_map,"CouponCities")
                        # db.session.add(new_coupon_cat_map)
                        # db.session.commit()

                if (data['city_id']):
                    for record in data['city_id']:
                        new_coupon_cat_map = CouponCities(
                            coupon_id=coupon.id,
                            city_id=record,
                            status='1',
                            created_at=datetime.datetime.utcnow())
                        save_db(new_coupon_cat_map,"CouponCities")
                        # db.session.add(new_coupon_cat_map)
                        # db.session.commit()

                apiResponce = ApiResponse(True, 'Coupon Created successfully',
                                          None, None)
                return (apiResponce.__dict__), 201

            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Create', None,
                                    str(e))
                return (error.__dict__), 500

        elif resp['data']['role'] == 'super_admin':
            check_coupon = Coupon.query.filter(func.lower(Coupon.code) == func.lower(
                data['code'])).filter_by(deleted_at=None).first()

        if check_coupon:
            error = ApiResponse(
                False, f"Coupon {data['code']} allready exists", None, f"Coupon {data['code']} allready exists")
            return (error.__dict__), 400

        if (data['city_id']):
            for record in data['city_id']:

                city = City.query.filter_by(
                    id=record).filter_by(deleted_at=None).first()
                if not city:
                    error = ApiResponse(
                        False, f'City id {record} not found', None,)
                    return (error.__dict__), 400

                if city.status == 0:
                    error = ApiResponse(
                        False, f'City {city.name} is disabled', None,)
                    return (error.__dict__), 400

        if (data['category_id']):
            for record in data['category_id']:
                category = Category.query.filter_by(
                    id=record).filter_by(deleted_at=None).first()
                if not category:
                    error = ApiResponse(
                        False, f'Category id {record} not found', None,)
                    return (error.__dict__), 400

                if category.status == 0:
                    error = ApiResponse(
                        False, f'Category {category.name} is disabled', None,)
                    return (error.__dict__), 400

        if data['is_display'] not in [0, 1]:
            error = ApiResponse(
                False, f'Wrong is_display Code provided ', None)
            return (error.__dict__), 400

        if data['banner_1'] == "default":
            data['banner_1'] = coupon_banner1_dir + "default"

        else:
            image_file, status = image_upload(
                data['banner_1'], coupon_banner1_dir, data['code'])
            if status == 400:
                return image_file, status
            data['banner_1'] = image_file

        if data['banner_2'] == "default":
            data['banner_2'] = coupon_banner1_dir + "default"

        else:
            image_file, status = image_upload(
                data['banner_2'], coupon_banner2_dir, data['code'])
            if status == 400:
                return image_file, status

            data['banner_2'] = image_file

        userId_for_coupon_created = None
        if (data['user_mobile']):
            user_for_coupon_created = User.query.filter_by(phone=data['user_mobile']).filter_by(deleted_at=None).first()
            userId_for_coupon_created = user_for_coupon_created.id
        coupon = Coupon(code=data['code'],
                        title=data['title'],
                        description=data['description'],
                        level=data['level'],
                        target=data['target'],
                        deduction_type=data['deduction_type'],
                        deduction_amount=data['deduction_amount'],
                        max_deduction=data['max_deduction'],
                        min_order_value=data['min_order_value'],
                        max_user_usage_limit=data['max_user_usage_limit'],
                        is_display=data['is_display'],
                        previous_order_track=data['previous_order_track'],
                        expired_at=str_to_date(data['expired_at']) if data['expired_at'] else None,
                        banner_1=data['banner_1'],
                        banner_2=data['banner_2'],
                        user_id=userId_for_coupon_created,
                        status=1,
                        created_at=datetime.datetime.utcnow())

        save_db(coupon, "Coupons")
        

        if (data['category_id']):
            for record in data['category_id']:

                new_coupon_cat_map = CouponCategories(
                    coupon_id=coupon.id,
                    category_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map, "CouponCategories")
                

        if (len(data['city_id'])==0):
            new_coupon_cat_map = CouponCities(
                coupon_id=coupon.id,
                #city_id=0,
                status='1',
                created_at=datetime.datetime.utcnow())
            save_db(new_coupon_cat_map, "CouponCities")
            

        if (data['city_id']):
            for record in data['city_id']:

                new_coupon_cat_map = CouponCities(
                    coupon_id=coupon.id,
                    city_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map, "CouponCities")
                

        apiResponce = ApiResponse(True, 'Coupon Created successfully',
                                  None, None)
        return (apiResponce.__dict__), 201

    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Create', None,
                            str(e))
        return (error.__dict__), 500



def create_coupon_by_merchant(data):
    # user = Auth.get_logged_in_user(request)

    try:
        if (data['user_mobile']):
            user_id = get_user_by_phone(data['user_mobile'])
        else:
            user_id = None

        check_coupon = Coupon.query.filter_by(func.lower(Coupon.code) == func.lower(
            data['code'])).filter_by(deleted_at=None).first()

        if check_coupon:
            error = ApiResponse(False, f"Coupon {data['code']} allready exists", None,
                                f"Coupon {data['code']} allready exists")
            return (error.__dict__), 400

        if data['banner_1'] == "default":
            data['banner_1'] = coupon_banner1_dir + "default"

        else:
            image_file, status = image_upload(
                data['banner_1'], coupon_banner1_dir, data['code'])
            if status == 400:
                return image_file, status
            data['banner_1'] = image_file

        if data['banner_2'] == "default":
            data['banner_2'] = coupon_banner1_dir + "default"

        else:
            image_file, status = image_upload(
                data['banner_2'], coupon_banner2_dir, data['code'])
            if status == 400:
                return image_file, status

            data['banner_2'] = image_file

        if data['is_display'] not in [0, 1]:
            error = ApiResponse(
                False, f'Wrong is_display Code provided ', None)
            return (error.__dict__), 400

        coupon = Coupon(code=data['code'],
                        title=data['title'],
                        description=data['description'],
                        level=data['level'],
                        target=data['target'],
                        deduction_type=data['deduction_type'],
                        deduction_amount=data['deduction_amount'],
                        max_deduction=data['max_deduction'],
                        min_order_value=data['min_order_value'],
                        max_user_usage_limit=data['max_user_usage_limit'],
                        is_display=data['is_display'],
                        previous_order_track=data['previous_order_track'],
                        expired_at=data['expired_at'],
                        banner_1=data['banner_1'],
                        banner_2=data['banner_2'],
                        user_id=user_id,
                        status=1,
                        created_at=datetime.datetime.utcnow())

        save_db(coupon,'Coupon')
        # db.session.add(coupon)
        # db.session.commit()
        if (data['category_id']):
            for record in data['category_id']:
                new_coupon_cat_map = CouponCategories(
                    coupon_id=coupon.id,
                    category_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map,'CouponCategories')
                # db.session.add(new_coupon_cat_map)
                # db.session.commit()
        if (data['store_id']):
            for record in data['store_id']:
                new_coupon_cat_map = CouponStores(
                    coupon_id=coupon.id,
                    store_id=record,
                    status='1',
                    created_at=datetime.datetime.utcnow())
                save_db(new_coupon_cat_map, 'CouponCategories')
                # db.session.add(new_coupon_cat_map)
                # db.session.commit()

        # coupon merchant ID by Auth Token
        new_coupon_id = coupon.id

        # get merchant ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        new_merchant_id = user_id
        try:
            new_coupon_merchant_map = CouponMerchant(
                coupon_id=new_coupon_id,
                merchant_id=new_merchant_id,
                status=1,
                created_at=datetime.datetime.utcnow())
            save_db(new_coupon_merchant_map,'CouponMerchant')

            # db.session.add(new_coupon_merchant_map)
            # db.session.commit()
            apiResponce = ApiResponse(True, 'Coupon Created successfully',
                                      None, None)
            return (apiResponce.__dict__), 201

        except Exception as e:
            error = ApiResponse(False, 'coupon Not able to mapped with Merchant', None,
                                str(e))
            return (error.__dict__), 500

    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Create', None,
                            str(e))
        return (error.__dict__), 500


def get_user_by_phone(phone):
    user = User.query.filter_by(phone=phone).first()
    user_id = user.id
    return user_id


def fetch_coupons(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']

        filter = None
        page = 1
        items = 10
        search = None
        try:
            page = data['page']
        except:
            pass

        try:
            items = data['items']
        except:
            pass
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        if items not in item_per_page:
            apiresponse = ApiResponse(
                False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if data['filter']:
            try:
                filter = data['filter']
            except:
                pass


        try:
            search = data['search']
            if len(search) < 2:
                search = None
            else:
                search = f"%{search}%"

        except:
            pass

        if filter not in ['Deactive', 'Expired', 'User Specific', 'Active', None]:
            apiresponse = ApiResponse(
                False, "Wrong Filter Provide", None, None)
            return apiresponse.__dict__, 400 

        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):
            today = datetime.date.today()

            if (filter == 'Deactive'):
                if search == None:
                    coupons = Coupon.query.filter(
                        Coupon.status == 0).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)
                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                        Coupon.status == 0).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif (filter == 'Expired'):
                if not search:
                    coupons = Coupon.query.filter(
                        Coupon.expired_at < str(today)).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                        Coupon.expired_at < str(today)).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif (filter == 'User Specific'):
                if not search:
                    coupons = Coupon.query.filter(
                        Coupon.user_id != None).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                        Coupon.user_id != None).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif filter == 'Active':
                if not search:
                    coupons = Coupon.query.filter_by(status = 1).filter(Coupon.expired_at > str(today)).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(Coupon.status == 1,
                                              Coupon.expired_at == None).filter_by(deleted_at=None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            else:
                if not search:
                    coupons = Coupon.query.filter_by(deleted_at=None).order_by(
                        Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter_by(deleted_at=None).order_by(
                        Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            recordObject = []
            for record in coupons.items:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track':
                    record.previous_order_track,
                    'max_user_usage_limit':
                    record.max_user_usage_limit,
                    'expired_at': str(record.expired_at) if record.expired_at else None,
                    # 'max_user_usage_limit':
                    # record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at) if record.created_at else None,
                    'updated_at': str(record.updated_at) if record.updated_at else None,
                    'deleted_at': str(record.deleted_at) if record.deleted_at else None
                }
                recordObject.append(response)
            return_obj = {
                'page': coupons.page,
                'total_pages': coupons.pages,
                'has_next_page': coupons.has_next,
                'has_prev_page': coupons.has_prev,
                'prev_page': coupons.prev_num,
                'next_page': coupons.next_num,
                'prev_page_url': None,
                'next_page_url': None,
                'current_page_url': None,
                'items_per_page': coupons.per_page,
                'items_current_page': len(coupons.items),
                'total_items': coupons.total,
                'items': recordObject
            }
            apiResponce = ApiResponse(True,
                                      'Coupon Fetched successfully',
                                      return_obj, None)
            return (apiResponce.__dict__), 200


        ##################### Need to Check ##########################


        elif ((user['role'] == 'supervisor')):
            user_cities = UserCities.query.filter_by(user_id=user['id']).filter_by(deleted_at=None)
            city_ids = get_city_id_associate_with_supervisor(user_cities)
            today = datetime.date.today()
            
            coupon_ids = []
            coupon_cities = CouponCities.query.filter(CouponCities.city_id.in_(city_ids)).filter_by(deleted_at=None)
            
            for coupon_city in coupon_cities:
                coupon_ids.append(coupon_city.coupon_id)

            if (filter == 'Deactive'):
                if not search: 
                    coupons = Coupon.query.filter(
                    Coupon.status == 0).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                    Coupon.status == 0).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

            elif (filter == 'Expired'):
                if not search:
                    coupons = Coupon.query.filter(
                        Coupon.expired_at < str(today)).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )
                
                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                        Coupon.expired_at < str(today)).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )
                
            elif (filter == 'User Specific'):
                if not search:
                    coupons = Coupon.query.filter(
                        Coupon.user_id != None).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(
                        Coupon.user_id != None).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )


            elif filter == 'Active':
                if not search:
                    coupons = Coupon.query.filter(Coupon.id.in_(coupon_ids)).filter(Coupon.status == 1,
                                                Coupon.expired_at > str(today)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(Coupon.id.in_(coupon_ids)).filter(Coupon.status == 1,
                                                Coupon.expired_at == None).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )


            else:
                if not search:
                    coupons = Coupon.query.filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

                else:
                    coupons = Coupon.query.filter(or_(func.lower(Coupon.code).like(func.lower(
                        search)), func.lower(Coupon.title).like(func.lower(
                            search)))).filter(Coupon.id.in_(coupon_ids)).filter_by(deleted_at=None).order_by(Coupon.status).order_by(Coupon.code).paginate(page, items, False )

            recordObject = []
            for record in coupons.items:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track':
                        record.previous_order_track,
                    'max_user_usage_limit':
                        record.max_user_usage_limit,
                    'expired_at': str(record.expired_at) if record.expired_at else None ,
                    # 'max_user_usage_limit':
                    #     record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at) if record.created_at else None,
                    'updated_at': str(record.updated_at) if record.updated_at else None,
                    'deleted_at': str(record.deleted_at) if record.deleted_at else None
                }
                recordObject.append(response)

            return_obj = {
                    'page': coupons.page,
                    'total_pages': coupons.pages,
                    'has_next_page': coupons.has_next,
                    'has_prev_page': coupons.has_prev,
                    'prev_page': coupons.prev_num,
                    'next_page': coupons.next_num,
                    'prev_page_url': None,
                    'next_page_url': None,
                    'current_page_url': None,
                    'items_per_page': coupons.per_page,
                    'items_current_page': len(coupons.items),
                    'total_items': coupons.total,
                    'items': recordObject
                }
            apiResponce = ApiResponse(True,
                                      'Coupon Fetched successfully',
                                      return_obj, None)
            return (apiResponce.__dict__), 200


        elif(user['role'] == 'merchant'):

            # get merchant_id from auth token
            merchant_id = user['id']
            # get todays date
            today = datetime.date.today()

            if (filter == 'Deactive'):
                if not search:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.status == 0).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)
                else:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(or_(func.lower(Coupon.code).like(func.lower(
                            search)), func.lower(Coupon.title).like(func.lower(
                                search)))).filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.status == 0).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif (filter == 'Expired'):
                if not search:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.expired_at < str(today)).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(or_(func.lower(Coupon.code).like(func.lower(
                            search)), func.lower(Coupon.title).like(func.lower(
                                search)))).filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.expired_at < str(today)).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif (filter == 'User Specific'):
                if not search:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.user_id != None).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)
                else:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(or_(func.lower(Coupon.code).like(func.lower(
                            search)), func.lower(Coupon.title).like(func.lower(
                                search)))).filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.user_id != None).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            elif filter == 'Active':
                if not search:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.status == 1, Coupon.expired_at == None).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(or_(func.lower(Coupon.code).like(func.lower(
                            search)), func.lower(Coupon.title).like(func.lower(
                                search)))).filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.status == 1, Coupon.expired_at == None).filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

            else:
                if not search:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)

                else:
                    coupons = Coupon.query\
                        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                        .filter(or_(func.lower(Coupon.code).like(func.lower(
                            search)), func.lower(Coupon.title).like(func.lower(
                                search)))).filter(CouponMerchant.merchant_id == merchant_id)\
                        .filter(Coupon.deleted_at == None).order_by(Coupon.status.desc()).order_by(Coupon.code).paginate(page, items, False)
            
            recordObject = []

            for record in coupons.items:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track':
                    record.previous_order_track,
                    'max_user_usage_limit':
                    record.max_user_usage_limit,
                    'expired_at': str(record.expired_at) if record.expired_at else None,
                    # 'max_user_usage_limit':
                    # record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at) if record.created_at else None,
                    'updated_at': str(record.updated_at) if record.updated_at else None,
                    'deleted_at': str(record.deleted_at) if record.deleted_at else None
                }
                recordObject.append(response)

            return_obj = {
                'page': coupons.page,
                'total_pages': coupons.pages,
                'has_next_page': coupons.has_next,
                'has_prev_page': coupons.has_prev,
                'prev_page': coupons.prev_num,
                'next_page': coupons.next_num,
                'prev_page_url': None,
                'next_page_url': None,
                'current_page_url': None,
                'items_per_page': coupons.per_page,
                'items_current_page': len(coupons.items),
                'total_items': coupons.total,
                'items': recordObject
            }
            apiResponce = ApiResponse(True,
                                      'Coupon Fetched successfully',
                                      return_obj, None)
            return (apiResponce.__dict__), 200

        # Super Visor Coupon Logic
        # elif(user['role'] == 'supervisor'):

    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return error.__dict__, 500

def get_city_id_associate_with_supervisor(user_cities):
    city_id=[]
    for user_city in user_cities:
        city_id.append(user_city.city_id)
    return city_id



def activate_coupon(data):

    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        if ((user['role'] == 'super_admin') or (user['role'] == 'admin')):
            try:
                coupon = Coupon.query.filter_by(id=data['id']).first()

                if coupon:
                    coupon.status = 1
                    coupon.updated_at = datetime.datetime.utcnow()

                    db.session.commit()

                    apiResponce = ApiResponse(True,
                                              'Coupon Activated successfully',
                                              None, None)
                    return (apiResponce.__dict__), 200
            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Fetch', None,
                                    str(e))
                return (error.__dict__), 500


        if ((user['role'] == 'supervisor')):
            try:
                coupon = Coupon.query.filter_by(id=data['id']).first()

                if coupon:
                    coupon.status = 1
                    coupon.updated_at = datetime.datetime.utcnow()

                    save_db(coupon)

                    apiResponce = ApiResponse(True,
                                              'Coupon Activated successfully',
                                              None, None)
                    return (apiResponce.__dict__), 200
            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Fetch', None,
                                    str(e))
                return (error.__dict__), 500

        if (user['role'] == 'merchant'):

            try:

                # get merchant_id from auth token
                merchant_id = user['id']

                coupon = Coupon.query\
                    .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                    .filter(CouponMerchant.merchant_id == merchant_id)\
                    .filter(Coupon.id == data['id']).first()

                if coupon:
                    coupon.status = 1
                    coupon.updated_at = datetime.datetime.utcnow()
                    save_db(coupon,'coupon')

                    apiResponce = ApiResponse(True,
                                              'Coupon Activated successfully',
                                              None, None)
                    return (apiResponce.__dict__), 200
            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Fetch', None,
                                    str(e))
                return (error.__dict__), 500
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))

        return error.__dict__, 500


def deactivate_coupon(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        if ((user['role'] == 'super_admin') or (user['role'] == 'admin') or (user['role'] == 'supervisor')):
            try:
                coupon = Coupon.query.filter_by(id=data['id']).first()

                if coupon:
                    coupon.status = 0
                    coupon.updated_at = datetime.datetime.utcnow()

                    save_db(coupon,"coupon")
                    #db.session.commit()

                    apiResponce = ApiResponse(True,
                                              'Coupon Deactivated successfully',
                                              None, None)
                    return (apiResponce.__dict__), 200
            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Fetch', None,
                                    str(e))
                return (error.__dict__), 500

        if (user['role'] == 'merchant'):
            try:

                # get merchant_id from auth token
                user = Auth.get_logged_in_user(request)
                merchant_id = user.id

                coupon = Coupon.query\
                    .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                    .filter(CouponMerchant.merchant_id == merchant_id)\
                    .filter(Coupon.id == data['id']).first()

                if coupon:
                    coupon.status = 0
                    coupon.updated_at = datetime.datetime.utcnow()
                    save_db(coupon,"coupon")
                    #db.session.commit()

                    apiResponce = ApiResponse(True,
                                              'Coupon Deactivated successfully',
                                              None, None)
                    return (apiResponce.__dict__), 200
            except Exception as e:
                error = ApiResponse(False, 'Coupon Not able to Fetch', None,
                                    str(e))
                return (error.__dict__), 500
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return error.__dict__, 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500

def fetch_coupons_by_city_id(data):
    today = datetime.date.today()
    try:

        city = check_city(data['city_name'])

        if city:
            coupon_ids = check_city_coupon_map(city.id)

            # get todays date

            coupons = Coupon.query.filter(Coupon.id.in_(coupon_ids)).filter(Coupon.status == 1).filter(Coupon.expired_at == None).filter(Coupon.is_display == 1).filter(Coupon.deleted_at == None)
            coupons_with_expiry = Coupon.query.filter(
                Coupon.status == 1, Coupon.id.in_(
                    coupon_ids), Coupon.deleted_at == None, Coupon.is_display == 1,
                Coupon.expired_at > str(today)).all()

            recordObject = []
            for record in coupons:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

            for record in coupons_with_expiry:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)
            apiResponce = ApiResponse(True, 'Coupon Fetched successfully',
                              recordObject, None)
            return (apiResponce.__dict__), 200

        else:
            error = ApiResponse(False, 'City Name Does not Match', None, None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Fetch', None, str(e))
        return (error.__dict__), 500

def fetch_coupons_by_city_id_new(data):
    today = datetime.date.today()
    if data['city_name']:
        try:

            city = check_city(data['city_name'])

            if city:
                coupon_ids = check_city_coupon_map(city.id)

                # get todays date


                coupons = Coupon.query.filter(Coupon.status == 1,
                                              Coupon.expired_at == None, Coupon.is_display == 1,
                                              Coupon.deleted_at == None,
                                              Coupon.id.in_(coupon_ids)).all()
                coupons_with_expiry = Coupon.query.filter(
                    Coupon.status == 1, Coupon.id.in_(
                        coupon_ids), Coupon.deleted_at == None, Coupon.is_display == 1,
                    Coupon.expired_at > str(today)).all()

                recordObject = []
                for record in coupons:
                    response = {
                        'id': record.id,
                        'code': record.code,
                        'title': record.title,
                        'description': record.description,
                        'banner_1': record.banner_1,
                        'banner_2': record.banner_2,
                        'level': record.level,
                        'target': record.target,
                        'deduction_type': record.deduction_type,
                        'deduction_amount': record.deduction_amount,
                        'min_order_value': record.min_order_value,
                        'max_deduction': record.max_deduction,
                        'user_id': record.user_id,
                        'previous_order_track': record.previous_order_track,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'expired_at': record.expired_at,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'status': record.status,
                        'order_id': record.order_id,
                        'is_display': record.is_display,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)

                for record in coupons_with_expiry:
                    response = {
                        'id': record.id,
                        'code': record.code,
                        'title': record.title,
                        'description': record.description,
                        'banner_1': record.banner_1,
                        'banner_2': record.banner_2,
                        'level': record.level,
                        'target': record.target,
                        'deduction_type': record.deduction_type,
                        'deduction_amount': record.deduction_amount,
                        'min_order_value': record.min_order_value,
                        'max_deduction': record.max_deduction,
                        'user_id': record.user_id,
                        'previous_order_track': record.previous_order_track,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'expired_at': record.expired_at,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'status': record.status,
                        'order_id': record.order_id,
                        'is_display': record.is_display,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)
                    #fetching the global coupons
                global_coupons = Coupon.query.filter(Coupon.status == 1, Coupon.expired_at == None, Coupon.is_display == 1,
                                              Coupon.deleted_at == None, ).all()
                global_coupons_with_expiry = Coupon.query.filter(Coupon.status == 1, Coupon.deleted_at == None,
                                                          Coupon.is_display == 1, Coupon.expired_at > str(today)).all()

                for record in global_coupons:
                    response = {
                        'id': record.id,
                        'code': record.code,
                        'title': record.title,
                        'description': record.description,
                        'banner_1': record.banner_1,
                        'banner_2': record.banner_2,
                        'level': record.level,
                        'target': record.target,
                        'deduction_type': record.deduction_type,
                        'deduction_amount': record.deduction_amount,
                        'min_order_value': record.min_order_value,
                        'max_deduction': record.max_deduction,
                        'user_id': record.user_id,
                        'previous_order_track': record.previous_order_track,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'expired_at': record.expired_at,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'status': record.status,
                        'order_id': record.order_id,
                        'is_display': record.is_display,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)

                for record in global_coupons_with_expiry:
                    response = {
                        'id': record.id,
                        'code': record.code,
                        'title': record.title,
                        'description': record.description,
                        'banner_1': record.banner_1,
                        'banner_2': record.banner_2,
                        'level': record.level,
                        'target': record.target,
                        'deduction_type': record.deduction_type,
                        'deduction_amount': record.deduction_amount,
                        'min_order_value': record.min_order_value,
                        'max_deduction': record.max_deduction,
                        'user_id': record.user_id,
                        'previous_order_track': record.previous_order_track,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'expired_at': record.expired_at,
                        'max_user_usage_limit': record.max_user_usage_limit,
                        'status': record.status,
                        'order_id': record.order_id,
                        'is_display': record.is_display,
                        'created_at': str(record.created_at),
                        'updated_at': str(record.updated_at),
                    }
                    recordObject.append(response)

                apiResponce = ApiResponse(True, 'Coupon Fetched successfully',
                                          recordObject, None)
                return (apiResponce.__dict__), 200

            else:
                error = ApiResponse(False, 'City Name Does not Match', None, None)
                return (error.__dict__), 400
        except Exception as e:
            error = ApiResponse(False, 'Coupon Not able to Fetch', None, str(e))
            return (error.__dict__), 500

    else:
        try:
            coupons = Coupon.query.filter(Coupon.status == 1, Coupon.expired_at == None, Coupon.is_display == 1,
                                          Coupon.deleted_at == None, ).all()
            coupons_with_expiry = Coupon.query.filter(Coupon.status == 1, Coupon.deleted_at == None,
                                                      Coupon.is_display == 1, Coupon.expired_at > str(today)).all()

            recordObject = []
            for record in coupons:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

            for record in coupons_with_expiry:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

                apiResponce = ApiResponse(
                    True, 'global coupon fetched successfuly',
                    recordObject, None)
                return (apiResponce.__dict__), 200


        except Exception as e:
            error = ApiResponse(False, 'Coupon Not able to fetch', None,
                                str(e))
            return (error.__dict__), 500

    # except Exception as e:
    # error = ApiResponse(False, 'Coupon Not able to Fetch', None, str(e))
    # return (error.__dict__), 500






def fetch_coupons_by_store_id(data):
    try:
        store = check_store(data['store_name'])

        if store:
            coupon_ids = check_store_coupon_map(store.id)

            # get merchant_id from auth token
            user = Auth.get_logged_in_user(request)
            merchant_id = user.id

            # get todays date
            today = datetime.date.today()

            coupons = Coupon.query\
                .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                .filter(CouponMerchant.merchant_id == merchant_id)\
                .filter(Coupon.status == 1, Coupon.expired_at == None, Coupon.id.in_(coupon_ids)).all()
            coupons_with_expiry = Coupon.query\
                .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
                .filter(CouponMerchant.merchant_id == merchant_id)\
                .filter(
                    Coupon.status == 1, Coupon.id.in_(coupon_ids),
                    Coupon.expired_at > str(today), Coupon.is_display == 1).all()

            recordObject = []
            for record in coupons:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

            for record in coupons_with_expiry:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

            apiResponce = ApiResponse(True, 'Coupon Fetched successfully',
                                      recordObject, None)
            return (apiResponce.__dict__), 200

        else:
            error = ApiResponse(False, 'Store Does not Match', None, None)
            return (error.__dict__), 400
    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Fetch', None, str(e))
        return (error.__dict__), 500


def check_store(name):
    tag = name
    search = "%{}%".format(tag)

    # get merchant_id from auth token
    user = Auth.get_logged_in_user(request)
    merchant_id = user.id

    store = Store.query\
        .join(CouponMerchant, CouponMerchant.coupon_id == Coupon.id)\
        .filter(CouponMerchant.merchant_id == merchant_id)\
        .filter(Store.name.like(search)).first()

    return store


def check_city(name):

    tag = name
    search = "%{}%".format(tag)
    city = City.query.filter(City.name.like(search)).first()

    return city


def check_city_coupon_map(city_id):

    #coupons_id = CouponCities.query.filter(or_(CouponCities.city_id == city_id, CouponCities.city_id == None))
    coupons_id = CouponCities.query.filter(CouponCities.city_id == city_id).filter(CouponCities.deleted_at == None)
    coupons_id_without_city_id = CouponCities.query.filter(CouponCities.city_id == None).filter(CouponCities.deleted_at == None)
    recordObject = []
    for record in coupons_id:
        recordObject.append(record.coupon_id)

    for record in coupons_id_without_city_id:
        recordObject.append(record.coupon_id)
    return recordObject


def check_store_coupon_map(store_id):

    coupons_id = CouponStores.query.filter(
        CouponStores.store_id == store_id).all()

    recordObject = []
    for record in coupons_id:
        recordObject.append(record.coupon_id)

    return recordObject


def fetch_user_coupons():
    try:
        # get todays date
        today = datetime.date.today()

        # get user ID by Auth Token
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        user_id = user['id']

        coupons = Coupon.query.filter(
            Coupon.user_id == user_id, Coupon.deleted_at == None, Coupon.is_display == 1).all()
        #coupons = Coupon.query.filter(Coupon.deleted_at == None, Coupon.is_display == 1).all()
        # print(str(coupons))
        try:
            recordObject = []
            for record in coupons:
                response = {
                    'id': record.id,
                    'code': record.code,
                    'title': record.title,
                    'description': record.description,
                    'banner_1': record.banner_1,
                    'banner_2': record.banner_2,
                    'level': record.level,
                    'target': record.target,
                    'deduction_type': record.deduction_type,
                    'deduction_amount': record.deduction_amount,
                    'min_order_value': record.min_order_value,
                    'max_deduction': record.max_deduction,
                    'user_id': record.user_id,
                    'previous_order_track': record.previous_order_track,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'expired_at': record.expired_at,
                    'max_user_usage_limit': record.max_user_usage_limit,
                    'status': record.status,
                    'order_id': record.order_id,
                    'is_display': record.is_display,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                }
                recordObject.append(response)

            apiResponce = ApiResponse(
                True, 'User Specific Coupon Fetched successfully',
                recordObject, None)
            return (apiResponce.__dict__), 200
        except Exception as e:
            error = ApiResponse(False, 'Coupon Not able to fetch', None,
                                str(e))
            return (error.__dict__), 500

    except Exception as e:
        error = ApiResponse(False, 'Coupon Not able to Fetch', None, str(e))
        return (error.__dict__), 500


def is_max_user_usage_limit_reached(previous_order_track, max_user_usage_limit):
    if previous_order_track == max_user_usage_limit:
        return True
    else:
        return False


def is_coupon_expired(expiry_date, current_date):
    current_date = str(current_date)
    if expiry_date < current_date:
        return True
    else:
        return False


def discount_calulation(deduction_type, total_amount, deduction_amount, max_deduction):

    if int(deduction_type) == 1:
        # get the pecentage of discount
        discount_value = (deduction_amount*total_amount)/100
        type = "pecentage"

    elif int(deduction_type) == 2:
        # get absolute discount
        discount_value = deduction_amount
        type = "absolute"

    if discount_value > max_deduction:
        discount_value = max_deduction

    total_after_discount = total_amount - discount_value

    return total_after_discount, discount_value, type


def get_coupon_discount(data):
    try:
        resp, status = Auth.get_logged_in_user(request)
        user = resp['data']
        # user = Auth.get_logged_in_user(request)
        # user_id = user.id
        current_time = datetime.datetime.utcnow()
        coupon_code = data['coupon_code']
        cart_id = data['cart_id']
        id = re.search(r"\d+(\.\d+)?", cart_id)
        id = int(id.group(0))

        item_orders = ItemOrder.query.filter_by(
            id=id).filter_by(deleted_at=None).first()
        if not item_orders:
            error = ApiResponse(False, "Cart Not Found", None,
                                f" {id} not present in Carts")
            return error.__dict__, 400
        # total = data['total']
        coupons_data = Coupon.query.filter(func.lower(Coupon.code) == func.lower(
            coupon_code)).filter_by(deleted_at=None).first()

        if not coupons_data:
            error = ApiResponse(False, coupon_code + " Coupon does not Exist", None,
                                data['coupon_code'] + " is not present is coupon Database")
            return error.__dict__, 400

        if coupons_data.status == 0:
            error = ApiResponse(False, coupon_code + " Coupon is Not Valid", None,
                                data['coupon_code'] + "  status set as False")
            return error.__dict__, 400

        fetch_coupon_details = []

        recordObject = {
            'coupons_id': coupons_data.id,
            "coupon_code": coupons_data.code,
            "deduction_amount": coupons_data.deduction_amount,
            "min_order_value": coupons_data.min_order_value,
            "max_deduction": coupons_data.max_deduction,
            "max_user_usage_limit": coupons_data.max_user_usage_limit,
            "expired_at": coupons_data.expired_at,
            "deduction_type": coupons_data.deduction_type,
            "previous_order_track": coupons_data.previous_order_track,
            "is_display": coupons_data.is_display
        }
        fetch_coupon_details.append(recordObject)

        if not len(fetch_coupon_details):
            apiResponce = ApiResponse(
                True, 'Coupon code is not valid', None)
            return (apiResponce.__dict__), 400
        else:
            min_order_value = fetch_coupon_details[0]['min_order_value']

            deduction_type = fetch_coupon_details[0]['deduction_type']

            deduction_amount = fetch_coupon_details[0]['deduction_amount']

            item_order = ItemOrder.query.filter_by(
                id=id).filter_by(deleted_at=None).first()
            total = order_total_calculate(item_order)

            if total < min_order_value:
                item_order.coupon_id = None
                item_order.order_total_discount = None
                save_db(item_order, "Item Order")
                
                apiResponce = ApiResponse(
                    False, f'Total amount less than min order value {min_order_value}', None, None)
                return (apiResponce.__dict__), 400

            max_deduction = fetch_coupon_details[0]['max_deduction']

            total_after_discount, discount_value, type = discount_calulation(
                deduction_type, total, deduction_amount, max_deduction)
            # total_after_discount = total - fetch_coupon_details[0]['deduction_amount']

            discountDetails = []

            delivery_fee = None
            # if total_after_discount > max_deduction:
            if item_order.delivery_fee != None:
                delivery_fee = item_order.delivery_fee

            # recordObject = {
            #     "code": coupon_code,
            #     "total": total,
            #     "delivery_fee": delivery_fee,
            #     "delivery_fees_after_discount": delivery_fee,
            #     "discount_amount": discount_value,
            #     "total_after_discount": total_after_discount,
            #     "mode_of_discount": type
            # }

            recordObject = None

            discountDetails.append(recordObject)
            finalResult = []

            for key, value in groupby(discountDetails):
                finalResult.append(list(value))
            finalResult_without_array = []

            for i in range(len(finalResult)):
                finalResult_without_array.append(finalResult[i][0])
            # here we have to increase the count of uses
            max_user_usage_limit = fetch_coupon_details[0]['max_user_usage_limit']
            previous_order_track = fetch_coupon_details[0]['previous_order_track']
            is_display = fetch_coupon_details[0]['is_display']
            if is_max_user_usage_limit_reached(previous_order_track, max_user_usage_limit):
                # if limit reached then we have to write the logic
                coupons_data.status = 0
                coupons_data.updated_at = current_time
                save_db(coupons_data,'Coupon')

                # try:
                #     db.session.add(coupons_data)
                #     db.session.commit()
                # except Exception as e:
                #     db.session.rollback()
                #     error = ApiResponse(False, "Database Server Error", None,
                #                         f"Database Name: coupoun Error: {str(e)}")
                #     return error.__dict__, 500

                # sql = text(
                #     'UPDATE coupons SET is_display = 0, updated_at = :current_time WHERE coupons.code = :coupons_code'
                # )
                # db.engine.execute(
                #     sql,
                #     {'current_time': current_time,
                #      'coupons_code': coupon_code
                #      })
                apiResponce = ApiResponse(
                    True, 'Reached the max usage', None, None)
                return (apiResponce.__dict__), 201

            else:
                previous_order_track = previous_order_track+1
                expired_at = fetch_coupon_details[0]['expired_at']

                # verifying the coupon has been expired or not
                if expired_at is None:
                    #coupons_data.is_display = 0
                    coupons_data.updated_at = current_time
                    coupons_data.previous_order_track = previous_order_track

                    save_db(coupons_data,'Coupon')
                    # try:
                    #     db.session.add(coupons_data)
                    #     db.session.commit()
                    # except Exception as e:
                    #     db.session.rollback()
                    #     error = ApiResponse(False, "Database Server Error", None,
                    #                         f"Database Name: ItemOrderList Error: {str(e)}")
                    #     return error.__dict__, 500
                    # sql = text(
                    #     'UPDATE coupons SET is_display = 0, updated_at = :current_time, previous_order_track = :previous_order_track WHERE coupons.code = :coupons_code'
                    # )
                    # db.engine.execute(
                    #     sql,
                    #     {'current_time': current_time,
                    #      'coupons_code': coupon_code,
                    #      'previous_order_track': previous_order_track
                    #      })

                    # results = Coupon.query.filter(Coupon.code == coupon_code).values('id')
                    coupon_id = coupons_data.id
                    # for record in results:
                    #     coupon_id = record[0]

                    item_order.coupon_id = coupon_id
                    item_order.updated_at = current_time
                    item_order.order_total_discount = discount_value
                    item_order.final_order_total = total_after_discount

                    if delivery_fee == None:
                        item_order.grand_order_total = total_after_discount
                    else:
                        item_order.grand_order_total = total_after_discount + delivery_fee

                    save_db(item_order,"ItemOrders")

                    # try:
                    #     db.session.add(item_order)
                    #     db.session.commit()
                    # except Exception as e:
                    #     db.session.rollback()
                    #     error = ApiResponse(False, "Database Server Error", None,
                    #                         f"Database Name: ItemOrder Error: {str(e)}")
                    #     return error.__dict__, 500

                    # sql = text(
                    #     'UPDATE item_orders SET \
                    #     coupon_id = :coupon_id, \
                    #     updated_at = :current_time, \
                    #     order_total_discount = :discount_value, \
                    #     final_order_total = :total_after_discount, \
                    #     order_total = :order_total WHERE id = :id'
                    # )
                    #
                    # db.engine.execute(
                    #     sql,
                    #     {'coupon_id': coupon_id,
                    #      'order_total': total,
                    #      'current_time': current_time,
                    #      'discount_value': discount_value,
                    #      'total_after_discount': total_after_discount,
                    #      'id': id
                    #      })

                    apiResponce = ApiResponse(
                        True, 'Discount calculated successfully', finalResult_without_array, None)

                    return (apiResponce.__dict__), 200

                else:
                    if is_coupon_expired(expired_at, current_time):
                        coupons_data.status = 0
                        coupons_data.updated_at = current_time

                        try:
                            db.session.add(coupons_data)
                            db.session.commit()
                        except Exception as e:
                            db.session.rollback()
                            error = ApiResponse(False, "Database Server Error", None,
                                                f"Database Name: coupon Error: {str(e)}")
                            return error.__dict__, 500

                        # sql = text(
                        #     'UPDATE coupons SET is_display = 0, updated_at = :current_time WHERE coupons.code = :coupons_code'
                        # )
                        # db.engine.execute(
                        #     sql,
                        #     {'current_time': current_time,
                        #      'coupons_code': coupon_code
                        #      })
                        apiResponce = ApiResponse(
                            True, 'your coupon has been expired', None, None)
                        return (apiResponce.__dict__), 202
                    else:

                        # records = Coupon.query.filter_by(code=[coupon_code]).first()
                        # print(records)
                        results = Coupon.query.filter(
                            Coupon.code == coupon_code).values('id')
                        coupon_id = None
                        for record in results:
                            coupon_id = record[0]

                        sql = text(
                            'UPDATE coupons SET is_display = 1, updated_at = :current_time, previous_order_track = :previous_order_track WHERE coupons.code = :coupons_code'
                        )
                        db.engine.execute(
                            sql,
                            {'current_time': current_time,
                             'coupons_code': coupon_code,
                             'previous_order_track': previous_order_track
                             })

                        # sql = text(
                        #     'UPDATE item_orders SET \
                        #     coupon_id = :coupon_id, \
                        #     updated_at = :current_time, \
                        #     order_total_discount = :discount_value, \
                        #     final_order_total = :total_after_discount, \
                        #     order_total = :order_total WHERE id = :id'
                        # )

                        # db.engine.execute(
                        #     sql,
                        #     {'coupon_id': coupon_id,
                        #      'order_total': total,
                        #      'current_time': current_time,
                        #      'discount_value': discount_value,
                        #      'total_after_discount': total_after_discount,
                        #      'id': id
                        #      })

                        item_order.coupon_id = coupon_id
                        item_order.updated_at = current_time
                        item_order.order_total_discount = discount_value
                        item_order.final_order_total = total_after_discount
                        if delivery_fee == None:
                            item_order.grand_order_total = total_after_discount
                        else:
                            item_order.grand_order_total = total_after_discount + delivery_fee

                        try:
                            db.session.add(item_order)
                            db.session.commit()
                        except Exception as e:
                            db.session.rollback()
                            error = ApiResponse(False, "Database Server Error", None,
                                                f"Database Name: ItemOrder Error: {str(e)}")
                            return error.__dict__, 500

                        apiResponce = ApiResponse(
                            True, 'Discount calculated successfully', finalResult_without_array, None)

                        return (apiResponce.__dict__), 200

        # apiResponce = ApiResponse(
        #     True, 'Discount calculated successfully', None)
        # return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(
            False, 'Discount not able to calculate', None, str(e))
        return (error.__dict__), 500


def cart_coupon_removal(data):
    try:

        cart_id = data['cart_id']
        try:
            id = re.search(r"\d+(\.\d+)?", cart_id)
            id = int(id.group(0))

        except Exception as e:
            apiResponce = ApiResponse(
                False, 'Error Occured', None, 'Given Cart Id is Wrong'+str(e))
            return (apiResponce.__dict__), 400

        cart_id = id
        item_order = ItemOrder.query.filter_by(
            id=cart_id).filter_by(deleted_at=None).first()
        if not item_order:
            error = ApiResponse(False, "Cart Not Found", None,
                                f" {id} not present in Carts")
            return error.__dict__, 400

        coupons_data = Coupon.query.filter_by(
            id=item_order.coupon_id).filter_by(deleted_at=None).first()

        if coupons_data:
            coupons_data.previous_order_track -= 1
            coupons_data.updated_at = datetime.datetime.utcnow()
            save_db(coupons_data, "Copouns")
            

        item_order.coupon_id = None
        item_order.order_total_discount = None
        item_order.updated_at = datetime.datetime.utcnow()
        save_db(item_order, "ItemOrder")
        
        o_t, f_o_t, g_o_t = calculate_order_total(item_order)

        delivery_fee = None
        if item_order.delivery_fee:
            delivery_fee = item_order.delivery_fee

        return_object = {
            'order_total': o_t,
            'final_order_total': f_o_t,
            'grand_order_total': g_o_t,
            'delivery_fee': delivery_fee
        }

        apiResponce = ApiResponse(
            True, 'Coupon Removed Successfully', return_object, None)

        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Error Occured', None, str(e))
        return (error.__dict__), 500
