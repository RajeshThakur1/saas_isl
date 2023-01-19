from calendar import firstweekday
from flask_restx import Namespace, fields
from werkzeug.datastructures import FileStorage

class CartDto:
    # print("test...1234")
    api = Namespace('User Cart', description='Cart related operations')
    add_to_cart = api.model(
        'add_to_cart', {
            'store_item_id':
            fields.Integer(description='store_item_id'),
            'store_id':
            fields.Integer(description='store_id'),
            'store_item_variable_id':
            fields.Integer(description='store_item_variable_id')
        })
    remove_cart = api.model('remove_cart', {
        'cart_id':
        fields.Integer(description='this API will remove the cart'),
    })
    remove_item = api.model('remove_item', {
        'item_order_list_id':
            fields.Integer(description='this API will remove the item from the cart'),
    })
    get_from_cart = api.model('get_from_cart', {
        'cart_id':
        fields.String(description='cart id'),
    })

    delivery_fee = api.model('delivery_fee',{
        'order_id' : fields.String(required = True, description='Order Id'),
        'address_id' : fields.Integer(required = True, description='Address Id')
    })


authorizations = {
    'api_key': {
        'type': 'apiKey',
        'in': 'header',
        'name': 'Authorization'
    }
}


class AddressDto:
    api = Namespace('User Address',
                    description='user address related operations',
                    authorizations=authorizations)
    address = api.model(
        'UserAddress', {
            'user_id': fields.String(description='email'),
            'udate_id': fields.Integer(description='id', required=True),
            'email': fields.String(attribute='person.email',
                                   description='email'),
            'address1': fields.String(description='Address 1'),
            'address2': fields.String(description='Address 2'),
            'address3': fields.String(description='Address 2'),
            'landmark': fields.String(description='landmark'),
            'phone': fields.String(description='phone'),
            'lat': fields.Float(description='latitude'),
            'long': fields.Float(description='longitude'),
            'created_at': fields.DateTime(description='created'),
            'updated_at': fields.DateTime(description='updated'),
            'deleted_at': fields.DateTime(description='deleted'),
        })
    add_address = api.model(
        'add_address', {
            'address1': fields.String(required=True, description='Address 1'),
            'address2': fields.String(required=True, description='Address 2'),
            'address3': fields.String(description='Address 2'),
            'landmark': fields.String(description='landmark'),
            'phone': fields.String(required=True, description='phone'),
            'lat': fields.Float(description='latitude'),
            'long': fields.Float(description='longitude'),
            'city': fields.String(required=True,description='city')
        })
    delete_address = api.model(
        'delete_update', {
            'id': fields.Integer(required=True, description='delete Address'),
        })
    update_address = api.model('update_address',{
        'id': fields.Integer(required=True, description='delete Address'),
        'address1': fields.String(required=True, description='Address 1'),
        'address2': fields.String(required=True, description='Address 2'),
        'address3': fields.String(description='Address 2'),
        'landmark': fields.String(description='landmark'),
        'phone': fields.String(required=True, description='phone'),
        'lat': fields.Float(description='latitude'),
        'long': fields.Float(description='longitude'),
        'city': fields.String(required=True,description='city')
    })

    get_address_by_city = api.model('get_address_by_city',{
        'cart_id': fields.String(required=True, description='City id')
    })

class OrderDto:
    api = Namespace('User Order', description='Order related operations')
    order_details = api.model(
        'Order', {
            'id':
            fields.String(attribute='store.id', description='id'),
            'store':
            fields.String(attribute='store.name', description='store name '),
            'order_total':
            fields.String(description='Order Total'),
            'order_created':
            fields.DateTime(description='created')
        })
    get_orders_list = api.model('get_orders_list', {
        'user_id':
            fields.Integer(description='user id'),
    })
    get_orders = api.model('get_orders', {
        'page': fields.Integer(description='page no', required=False),
        'item_per_page': fields.Integer(description='Item Per Page', required=False)
    })
    get_discount_list = api.model('get_discount_list', {
        'code':
            fields.String(description='cupon code'),
        'id':
            fields.String(description='cart id'),
        'locality_id':
            fields.Integer(description='locality Id'),

    })
    place_order = api.model('place_order', {
        'id':
            fields.String(description='order_id', required = True)
    })
    
    place_order_payu = api.model('place_order_payu', {
        'id':
            fields.String(description='order_id', required = True)
    })
    
    check_order_payu = api.model('check_order_payu',{
        'productinfo' : fields.String(),
        'txnid': fields.String(),
        'status': fields.String(),
        'amount': fields.String(),
        'firstname': fields.String(),
        'hash' : fields.String(),
        'key' : fields.String(),
        'email' : fields.String(),
        'additionalCharges' : fields.String(),
        'PG_TYPE' : fields.String(),
        'addedon' : fields.String(),
        'mode' : fields.String(),
        'mihpayid' : fields.String(),
        'bankcode' : fields.String(),
        'bank_ref_num' : fields.String(),
        'discount' : fields.String(),
        'unmappedstatus' : fields.String(),
    })
    
    get_order_by_id = api.model('get_order_by_id', {
        'order_id':
            fields.String(description='order id'),

    })

    cancel_order_cust = api.model('cancel_order_customer',{
        'order_id':fields.String(description='order id'),
    })


class UserDto:

    api = Namespace('User Profile', description='user related operations')
    user_create = api.model(
        'user_create', {
            'email': fields.String(required=True,
                                   description='user email address'),
            'name': fields.String(description='user username'),
            'password': fields.String(required=True,
                                      description='user password'),
            'phone': fields.String(description='user Identifier'),
        })
    user_profile = api.model(
        'user_profile', {
            'name': fields.String(description='user username'),
            'password': fields.String(description='user password'),
            'phone': fields.String(description='user Identifier'),
        })
    user_auth = api.model(
        'user_auth', {
            'email': fields.String(description='user email'),
            'password': fields.String(description='user password')
        }
    )

    change_password = api.model("change_password", {
        'old_password': fields.String(required=True, description="Old password"),
        'new_password': fields.String(required=True, description="New password")

    })

    confirm_phone_otp = api.model(
        "confirm_phone_otp", {
            'login_request': fields.String(required=True, description="Login Request"),
            'otp': fields.String(required=True, description="Otp"),
            'phone': fields.String(required=True, description="User Phone"),
            'password': fields.String(required=True, description="User Password")

    })

    confirm_email_otp = api.model(
        "confirm_email_otp", {
            'login_request': fields.String(required=True, description="Login Request"),
            'otp': fields.String(required=True, description="Otp"),
            'email': fields.String(required=True, description="User Phone"),
            'password': fields.String(required=True, description="User Password")

    })

    user_name = api.model(
        'user_name', {
            'name': fields.String(description='user username')
        }
    )

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


class StoreDto:
    api = Namespace('User Store', description='store related operations')
    find_store = api.model(
        'find_store', {
            'lat':
            fields.Float(required=True, description='Latitude'),
            'long':
            fields.Float(required=True, description='Longitude'),
            'max_dist':
            fields.Integer(required=True, description='maximum distance')
        })


    items_by_id = api.model(
        'items_by_id', {
            'store_id':
            fields.Integer(required=True, description='Store ID')
        })
    

    find_store_by_location_category = api.model(
        'find_store_by_location_category', {
            'lat':
            fields.Float(required=True, description='Latitude'),
            'long':
            fields.Float(required=True, description='Longitude'),
            'max_dist':
            fields.Integer(required=True, description='maximum distance'),
            'category_id':
            fields.Integer(required=True, description='category_id')
        })
    store_id = api.model(
        'store_id',
        {'store_id': fields.Integer(required=True, description='Store id')
        })

    # fetch_store_item_by_menu_cat = api.model(
    #     'fetch_store_item_by_menu_cat', {
    #         'slug_st':
    #         fields.String(required=True, description='Store slug'),
    #         'menu_category_id':
    #         fields.Integer(required=True, description='Menu Category id')
    #     })
    fetch_store_by_slug=api.model(
        'store_slug',{
            'store_slug':fields.String(required=True,description='slug'),
        })
    
    get_store_by_slug = api.model(
        'store_slug', {
            'store_slug': fields.String(required=True, description='slug')
        })

    get_store_item_by_slug = api.model(
        'store_slug', {
            'store_slug': fields.String(required=True, description='slug')
        })

    fetch_store_by_slug_pagiantion=api.model(
        'store_slug_pagination',{
            'store_slug':fields.String(required=True,description='slug'),
            'page': fields.Integer(description='page no', required=False),
            'item_per_page': fields.Integer(description='Item Per Page', required=False)
        })

    fetch_store_item_by_menu_cat_and_storeSlug = api.model(
        'fetch_store_item_by_menu_cat_and_storeSlug', {
            'store_slug':
            fields.String(required=True, description='Store slug'),
            'menu_slug':
            fields.String(required=True, description='Menu Category id'),
            'page': fields.Integer(description='page no', required=False),
            'item_per_page': fields.Integer(description='Item Per Page', required=False)
        })

    globelSearch=api.model(
        'globelSearch_',{
           'search_string':
            fields.String(required=True, description='Store slug'),
           'city_name': fields.String(required=True, description='name'),
           'page' : fields.Integer(required = False, description = "page"),
           'items' : fields.Integer(required = False, description = "Item Per Page")
        }
        )
    
    

class CategoryDto:
    api = Namespace('User Category', description='Category related operations')
    city_name = api.model(
        'city_name', {
            'city_name': fields.String(required=True, description='name'),
            'page' : fields.Integer(required=False, description = "page no"),
            'items' : fields.String(required = False, description = "Item per page")
        })
    city_name_all = api.model(
        'city_name_all', {
            'city_name': fields.String(required=True, description='name')
        })
    
class CouponDto:
    api = Namespace('User Coupon', description='Coupon related operations')
    city_specific = api.model(
        'city_name', {'city_name': fields.String(required=False, description='city_name')})
    discount_specific = api.model(
        'discount_specific', {
            'coupon_code':
                fields.String(required=True, description='coupon_code'),
            'cart_id':
                fields.String(required=True, description='cart_id'),

        })
        
    coupon_removal = api.model('coupon_removal',{
        'cart_id' : fields.String(required=True, description = 'Coupon Removal')
    })
