
from flask_restx import Namespace, fields
from werkzeug.datastructures import FileStorage


class NullableString(fields.String):
    __schema_type__ = ['string', 'null']
    __schema_example__ = "null/string"


class NullableInteger(fields.Integer):
    __schema_type__ = ['integer', 'null']
    __schema_example__ = 0


class NullableList(fields.List):
    __schema_type__ = ['list', 'null']
    __schema_example__ = []


class SuperAdminDto:
    api = Namespace('SuperAdmin Profile',
                    description='Profile Related Operations')

    change_password = api.model("change_password", {
        'old_password': fields.String(required=True, description="Old password"),
        'new_password': fields.String(required=True, description="New password")

    })

    update_profile = api.model("update_profile", {
        'name': fields.String(required=True, description="Name"),
        'email': fields.String(required=True, description="Email"),
        'password': fields.String(required=True, description="Password")
    })
    create_template = api.model("create_template",{
        'template': fields.String(required=True, description="template"),
        'name':fields.String(required=True, description="template_name"),
        't_type':fields.String(required=True, description="t_type it can SMS, email")
    })
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')



class OTPDto:
    api = Namespace('SuperAdmin OTP',
                    description='OTP Related Operations')

    add_type = api.model("add_otp_type", {
        'type_name': fields.String(required=True, description="Type Name")

    })

    add_route = api.model("add_otp_route", {
        'route_name': fields.String(required=True, description="Route Name")
    })

    remove_type = api.model("remove_otp_type", {
        'type_id': fields.String(required=True, description="Type Name")

    })

    remove_route = api.model("remove_otp_route", {
        'route_id': fields.String(required=True, description="Route Name")
    })


class CityDto:
    api = Namespace('Superadmin City', description='City related operations')
    create_city = api.model(
        'create_city', {
            'name':
            fields.String(required=True, description='name'),
            'code':
            fields.String(required=True, description='code'),
            'status':
            fields.Integer(required=True, description='status'),
            'help_number':
            fields.String(required=True, description='help_number'),
            'whats_app_number':
            fields.String(required=True, description='whats_app_number')
        })
    update_city = api.model(
        'update_city', {
            'id':
            fields.Integer(description='id'),
            'name':
            fields.String(required=True, description='name'),
            'code':
            fields.String(required=True, description='code'),
            'status':
            fields.Integer(required=True, description='status'),
            'help_number':
            fields.String(required=True, description='help_number'),
            'whats_app_number':
            fields.String(required=True, description='whats_app_number')
        })
    delete_city = api.model('delete_city',
                            {'id': fields.Integer(description='id')})


class LocalityDto:
    api = Namespace('Superadmin Locality',
                    description='locality related operations')
    create_locality = api.model(
        'create_locality', {
            'city_id':
            fields.Integer(required=True, description='city_id'),
            'name':
            fields.String(required=True, description='name'),
            'code':
            fields.String(required=True, description='code'),
            'pin':
            fields.Integer(required=True, description='pin'),
            'delivery_fee':
            fields.Float(required=True, description='delivery_fee'),
            'start_time':
            fields.String(required=True, description='start_time'),
            'end_time':
            fields.String(required=True, description='end_time'),
            'status':
            fields.Integer(description='Status'),
            'created_at':
            fields.DateTime(description='created')
        })
    update_locality = api.model(
        'update_locality', {
            'id':
            fields.Integer(description='id'),
            'city_id':
            fields.Integer(required=True, description='city_id'),
            'name':
            fields.String(required=True, description='name'),
            'code':
            fields.String(required=True, description='code'),
            'pin':
            fields.Integer(required=True, description='pin'),
            'delivery_fee':
            fields.Float(required=True, description='delivery_fee'),
            'start_time':
            fields.String(required=True, description='start_time'),
            'end_time':
            fields.String(required=True, description='end_time'),
            'status':
            fields.Integer(description='Status'),
            'updated_at':
            fields.DateTime(description='updated')
        })
    delete_locality = api.model('delete_locality', {
        'id': fields.Integer(description='id'),
    })
    city = api.model('city', {
        'city_id': fields.Integer(description='city_id'),
    })


class OrderDto:
    api = Namespace('Superadmin Order', description='Order related operations')

    order_details_admin = api.model('order_details_admin', {
        "item_order_id": fields.Integer(required=True, description='order id')
    })

    cancel_order_admin = api.model('cancel_order_admin', {
        "item_order_id": fields.Integer(required=True, description='order id')
    })
    reject_order_admin = api.model("reject_order_admin", {
        'item_order_id': fields.Integer(required=True, description='order id')
    })

class HubOrderDto:
    api = Namespace('Super Admin Distributor Orders', description='Order Related Operation')

    order_details = api.model("order_details_distributor", {
        'hub_order_id': fields.Integer(required=True, description='order id')
    })

    cancel_order = api.model("cancel_order_distributor", {
        "hub_order_id": fields.Integer(required=True, description='order id')
    })

    get_payment = api.model("get_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
    })


class StoreDto:
    api = Namespace('Superadmin Store', description='store related operations')
    store = api.model(
        'store', {
            'id':
            fields.Integer(description='id'),
            'slug':
            fields.String(required=True, description='slug'),
            'name':
            fields.String(required=True, description='Name'),
            'owner_name':
            fields.String(required=True, description='Owner Name'),
            'shopkeeper_name':
            fields.String(required=True, description='Shop Keeper Name'),
            'image':
            fields.String(required=True, description='Image URL'),
            'address_line_1':
            fields.String(required=True, description='Address 1'),
            'address_line_2':
            fields.String(description='Address 2'),
            'store_latitude':
            fields.Float(required=True, description='Latitude'),
            'store_longitude':
            fields.Float(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, example="HH:MM", description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, example="HH:MM", description='End Time'),
            'radius':
            fields.Integer(description='Radius'),
            'status':
            fields.Integer(description='Status'),
            'created_at':
            fields.DateTime(description='created'),
            'updated_at':
            fields.DateTime(description='updated'),
            'deleted_at':
            fields.DateTime(description='deleted'),
        })
    create_store_admin = api.model(
        'create_store_admin', {
            'name':
            fields.String(required=True, description='Name'),
            'owner_name':
            fields.String(required=True, description='Owner Name'),
            'shopkeeper_name':
            fields.String(required=True, description='Shop Keeper Name'),
            'image':
            fields.String(required=True, description='Image URL'),
            'address_line_1':
            fields.String(required=True, description='Address 1'),
            'address_line_2':
            fields.String(description='Address 2'),
            'store_latitude':
            fields.Float(required=True, description='Latitude'),
            'store_longitude':
            fields.Float(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, example="HH:MM", description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, example="HH:MM", description='End Time'),
            'radius':
            fields.Integer(required=True, description='Radius'),
            'merchant_email':
            fields.String(required=True, description='merchant email address'),
            'merchant_name':
            fields.String(required=True, description='merchant name'),
            'merchant_phone':
            fields.String(required=True, description='merchant Phone'),
            'city_name':
            fields.String(required=False,
                          description='City name with Capital First Letter'),
            'walk_in_order_tax':
            fields.Integer(required=True, description='Walk in Order Tax'),         
            'da_id':
            fields.Integer(required=True, description='Delivery Agent'),
            'self_delivery_price':
            fields.Float(required=False, description='Self Delivery Price')
        })
    create_store_merchant = api.model(
        'create_store_merchant', {
            'name':
            fields.String(required=True, description='Name'),
            'owner_name':
            fields.String(required=True, description='Owner Name'),
            'shopkeeper_name':
            fields.String(required=True, description='Shop Keeper Name'),
            'image':
            fields.String(required=True, description='Image URL'),
            'address_line_1':
            fields.String(required=True, description='Address 1'),
            'address_line_2':
            fields.String(description='Address 2'),
            'store_latitude':
            fields.Float(required=True, description='Latitude'),
            'store_longitude':
            fields.Float(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, example="HH:MM", description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, example="HH:MM", description='End Time'),
            'radius':
            fields.Integer(required=True, description='Radius'),
            'city_name':
            fields.String(required=False,
                          description='City name with Capital First Letter')

        })

    update_store = api.model(
        'update_store', {
            'id':
            fields.Integer(required=True, description='id'),
            'name':
            fields.String(required=True, description='Name'),
            'owner_name':
            fields.String(required=True, description='Owner Name'),
            'shopkeeper_name':
            fields.String(required=True, description='Shop Keeper Name'),
            # 'image':
            # fields.String(required=True, description='Image URL'),
            'address_line_1':
            fields.String(required=True, description='Address 1'),
            'address_line_2':
            fields.String(description='Address 2'),
            'store_latitude':
            fields.Float(required=True, description='Latitude'),
            'store_longitude':
            fields.Float(required=True, description='Longitude'),
            # 'pay_later':
            # fields.Integer(required=True, description='Pay Later'),
            # 'delivery_mode':
            # fields.Integer(required=True, description='Delivery Mode'),
            # 'delivery_start_time':
            # fields.String(required=True, description='Start Time'),
            # 'delivery_end_time':
            # fields.String(required=True, description='End Time'),
            'radius':
            fields.Integer(description='Radius'),
            # 'status':
            # fields.Integer(description='Status'),
            'city_name':
            fields.String(required=False,
                          description='City name with Capital First Letter')
        })
    
    update_store_image = api.parser()
    update_store_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_store_image.add_argument('id', type=str, required=True)


    find_store = api.model(
        'find_store', {
            'lat':
            fields.Float(required=True, description='Latitude'),
            'long':
            fields.Float(required=True, description='Longitude'),
            'max_dist':
            fields.Integer(required=True, description='maximum distance')
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
        {'store_id': fields.Integer(required=True, description='Store id')})
    
    approve_store = api.model(
        'approve_store',{
            'store_id': fields.Integer(required=True, description='Store id'),
            'approve' : fields.Integer(required= True, description = '0 for reject & 1 for approve')
         })
    fetch_store_item_by_menu_cat = api.model(
        'fetch_store_item_by_menu_cat', {
            'store_id':
            fields.Integer(required=True, description='Store id'),
            'menu_category_id':
            fields.Integer(required=True, description='Menu Category id')
        })
    store_category_create = api.model(
        'store_category_create', {
            'store_id':
            fields.Integer(required=True, description='Store Category id'),
            'category_id':
            fields.List(fields.Integer)
        })
    store_category_delete = api.model(
        'store_category_delete', {
            'store_cat_id':
            fields.Integer(required=True, description='Store Category id')
        })
    store_menu_category_create = api.model(
        'store_menu_category_create', {
            'store_id':
            fields.Integer(required=True,
                           description='Store Menu Category id'),
            'menu_category_id':
            fields.List(fields.Integer)
        })
    store_menu_category_delete = api.model(
        'store_menu_category_delete', {
            'menu_category_id':
            fields.Integer(required=True, description='Store Menu Category id')
        })

    add_commission = api.model(
        'add_commission', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'commission': fields.Float(required=True, description='Commision Percentage')
        }
    )

    delivery_type = api.model("delivery_type", {
        'store_id': fields.Integer(required=True, description='Store Id'),
        'delivery_mode': fields.Integer(required=True, description='Delivery Mode'),
        'delivery_start_time': fields.String(required=True, example="HH:MM", description="Delivery Start Time"),
        'delivery_end_time': fields.String(required=True, example="HH:MM", description="Delivery End Time")
    })

    update_paylater = api.model("update_paylater", {
        'store_id': fields.Integer(required=True, description='Store Id'),
        'pay_later': fields.Integer(required=True, description="Status")
    })

    status_change = api.model("status_change", {
        'store_id': fields.Integer(required=True, description="Store ID"),
        'status': fields.Integer(required=True, description="Store Status")
    })

    store_mis = api.model(
        'store_mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date'),
            'store_id': fields.Integer(required=True, description="Store ID")
        }
    )

    show_store_tax = api.model(
        'show_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )

    get_agent = api.model(
        'get_agent_',
        {
            "store_id": fields.Integer(required=True, description='Item Order ID'),
        }
    )

    walkin_tax_fetch = api.model(
        'walkin_tax_fetch', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )
    
    walkin_tax_update = api.model(
        'walkin_tax_update', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'status': fields.Integer(required=True, description='Walk in Tax Status')
        }
    )
    
    walkin_commission_fetch = api.model(
        'walkin_commission_fetch', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )
    
    walkin_commission_update = api.model(
        'walkin_commission_update', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'status': fields.Integer(required=True, description='Walk in Tax Status')
        }
    )
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


    unapproved_stores = api.parser()
    unapproved_stores.add_argument('query', type=str, required=False)
    unapproved_stores.add_argument('status', type=int, required=False)
    unapproved_stores.add_argument('city_id', type= int, required=False)
    unapproved_stores.add_argument('page', type=int, required=False)
    unapproved_stores.add_argument('items_per_page', type=int, required=False)
    
    onboard_stores = api.parser()
    onboard_stores.add_argument('query', type=str, required=False)
    onboard_stores.add_argument('status', type=int, required=False)
    onboard_stores.add_argument('city_id', type= int, required=False)
    onboard_stores.add_argument('page', type=int, required=False)
    onboard_stores.add_argument('items_per_page', type=int, required=False)


class CategoryDto:
    api = Namespace('Superadmin Category',
                    description='Category related operations')
    category = api.model(
        'Category', {
            'id': fields.Integer(description='id'),
            'name': fields.String(required=True, description='Name'),
            'image': fields.String(description='Image'),
            'status': fields.Integer(required=True, description='status'),
            'created_at': fields.DateTime(description='created'),
            'updated_at': fields.DateTime(description='updated'),
            'deleted_at': fields.DateTime(description='deleted')
        })
    add_category = api.model(
        'add_category', {
            'name': fields.String(required=True, description='Name'),
            'image': fields.String(description='Image'),
            'status': fields.Integer(required=True, description='status')
        })
    update_category_name = api.model(
        'update_category_name', {
            'id': fields.Integer(required=True, description='id'),
            'name': fields.String(required=True, description='Name'),
            # 'image': fields.String(description='Image'),
            # 'status': fields.Integer(required=True, description='status')
        })
    
    update_category_image = api.parser()
    update_category_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_category_image.add_argument('id', type=str, required=True)
    
    delete_category = api.model(
        'delete_category', {
            'id': fields.Integer(required=True, description='id')
        })
    
    get_category_city = api.model(
        'get_category_city', {
            'id': fields.Integer(required=True, description='id')
        })
    
    get_not_category_city = api.model(
        'get_not_category_city', {
            'id': fields.Integer(required=True, description='id')
        })

    add_city_cat = api.model(
        'add_city_cat', {
            'cat_id':
            fields.List(fields.Integer, required=True, description='city_id'),
            'city_id':
            fields.Integer(required=True, description='id')
        })
    city_name = api.model(
        'city_name', {
            'city_name': fields.String(required=True, description='name'),
        })

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

    category_status_change = api.model(
        'category_status_change' , {
            'id' : fields.Integer(required=True, description="Category ID"),
            'status': fields.Integer(required=True, description = "Status Code")
        }
    )

class MenuCategoryDto:
    api = Namespace('Superadmin Menu Category',
                    description='Category related operations')
    add_menu_category = api.model(
        'add_menu_category',
        {
            'name': fields.String(description='name'),
            'image': fields.String(description='image'),
            # 'slug': fields.String(description='slug'),
            'category_id': fields.Integer(required=True,
                                          description='category_id'),
            'status': fields.Integer(required=True, description='status')
        })
    update_menu_category = api.model(
        'update_menu_category', {
            'id': fields.Integer(required=True, description='id'),
            'name': fields.String(description='name'),
            # 'image': fields.String(description='Image'),
            'slug': fields.String(description='slug'),
            'category_id': fields.Integer(required=True,
                                          description='category_id'),
            'status': fields.Integer(required=True, description='status')
        })
    
    update_menucategory_image = api.parser()
    update_menucategory_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_menucategory_image.add_argument('id', type=str, required=True)
    update_menucategory_image.add_argument('category_id', type=str, required=True)
    
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')
    
    delete_menu_category = api.model(
        'delete_menu_category',
        {'id': fields.Integer(required=True, description='id')})
    category_id = api.model('category_id', {
        'category_id':
        fields.Integer(required=True, description='category_id')
    })
    store_menu_category_id = api.model(
        'store_menu_category_id', {'category_id': fields.List(fields.Integer)})
    delete_by_category_id = api.model(
        'delete_by_category_id', {
            'store_id':
            fields.Integer(required=True, description='store_id'),
            'category_id':
            fields.Integer(required=True, description='category_id'),
        })


class QuantityUnitDto:
    api = Namespace('Superadmin Quantity Unit',
                    description='Category related operations')
    add_quantity_unit = api.model(
        'add_quantity_unit', {
            'name':
            fields.String(description='name'),
            'short_name':
            fields.String(description='short_name'),
            'conversion':
            fields.String(description='conversion'),
            'type_details':
            fields.String(required=True, description='type_details'),
            'status':
            fields.Integer(required=True, description='status')
        })
    update_quantity_unit = api.model(
        'update_quantity_unit', {
            'id':
            fields.Integer(required=True, description='id'),
            'name':
            fields.String(description='name'),
            'short_name':
            fields.String(description='short_name'),
            'conversion':
            fields.String(description='conversion'),
            'type_details':
            fields.String(required=True, description='type_details'),
            'status':
            fields.Integer(required=True, description='status')
        })
    delete_quantity_unit = api.model(
        'delete_quantity_unit',
        {'id': fields.Integer(required=True, description='id')})


class StoreItemDto:
    api = Namespace('Superadmin Store Item',
                    description='Store Item related operations')
    add_store_item = api.model(
        'add_store_item_superadmin', {
            'store_id':
            fields.Integer(required=True, description='store_id'),
            'menu_category_id':
            fields.Integer(required=True, description='menu_category_id'),
            'name':
            fields.String(required=True, description='name'),
            'brand_name':
            fields.String(required=True, description='brand_name'),
            # 'image':
            # fields.String(required=True, description='image'),
            'quantity':
            fields.Integer(required=True, description='quantity'),
            'quantity_unit':
            fields.Integer(required=True, description='quantity_unit'),
            'mrp':
            fields.Float(required=True, description='mrp'),
            'selling_price':
            fields.Float(required=True, description='selling_price'),
            'stock':
            fields.Integer(required=True, description='stock')
        })
    
    update_store_item_image = api.parser()
    update_store_item_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_store_item_image.add_argument('id', type=str, required=True)
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')
    
    update_item_variable_stock = api.model(
        'update_item_variable_stock_merchant', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'stock':
            fields.Integer(required=True, description="stock"),
        })

    update_item_status = api.model(
        'update_item_status_merchant', {
            'store_item_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'status':
            fields.Integer(required=True, description="stock"),
        })

    fetch_store_item_by_store_id = api.model(
        'fetch_store_item_by_store_id', {
            'store_id': fields.Integer(description='store_id', required=True),
            'stock': fields.List(fields.Integer, description="stock_filter", required=False),
            'menu_categories': fields.List(fields.Integer, description="menu_categories_filter", required=True),
            'page': fields.Integer(description='page no', required=True),
            'item_per_page': fields.Integer(description='Item Per Page', required=True),
            'search': fields.String(description = "Search String")
        })

    fetch_store_item_by_store_id_count = api.model(
        'fetch_store_item_by_store_id_count', {
            'store_id': fields.Integer(description='store_id')
        })
    update_item_variable = api.model(
        'update_item_variable_superadmin', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'store_item_id':
            fields.Integer(required=True, description='store_item_id'),
            'quantity':
            fields.Integer(description='quantity'),
            'quantity_unit':
            fields.Integer(description='quantity_unit'),
            'mrp':
            fields.Float(description='mrp'),
            'selling_price':
            fields.Float(required=True, description='selling_price'),
            'status':
            fields.Integer(required=True, description='status'),
            'stock':
            fields.Integer(required=True, description='stock')
        })


    delete_store_item_variable = api.model(
        'delete_store_item_variable', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'store_item_id':
            fields.Integer(required=True, description='store_item_id')
        })

    max_stock = api.model('max_stock', {
            'store_id': fields.Integer(required=True, description=" Store ID")
        }
    )


class CouponDto:
    api = Namespace('Superadmin Coupon',
                    description='Coupon related operations')
    add_coupon = api.model(
        'add_coupon', {
            'code':
            fields.String(required=True, description='code'),
            'user_mobile':
            NullableString(description='user_mobile'),
            'previous_order_track':
            NullableInteger(description='previous_order_track'),
            'title':
            NullableString(description='title'),
            'description':
            fields.String(required=True, description='description'),
            'banner_1':
            NullableString(description='banner_1'),
            'banner_2':
            NullableString(description='banner_2'),
            'category_id':
            NullableList(fields.Integer),
            'city_id':
            NullableList(fields.Integer),
            'level':
            fields.Integer(required=True, description='level', default=1),
            'target':
            fields.Integer(required=True, description='target'),
            'deduction_type':
            fields.Float(required=True, description='deduction_type'),
            'deduction_amount':
            fields.Float(required=True, description='deduction_amount'),
            'min_order_value':
            fields.Float(
                required=True, description='min_order_value', default=0),
            'max_deduction':
            NullableInteger(description='max_deduction'),
            'max_user_usage_limit':
            fields.Integer(required=True, description='max_user_usage_limit'),
            'is_display':
            fields.Integer(required=True, description='is_display', default=1),
            'expired_at':
            NullableString(description='expired_at'),
        })
    fetch_coupon = api.model('fetch_coupon', {
        'filter': NullableString(description='filter'),
        'page' : fields.Integer(description = 'Page'),
        'items' : fields.Integer(description = "Items Per Page"),
        'search': fields.String(description = "Search")
    })
    coupon_id = api.model(
        'coupon_id', {'id': fields.Integer(required=True, description='id')})

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')
    
class StoreUserDto:
    api = Namespace('Superadmin Store Users',
                    description='Store Users related operations')
    add_user = api.model(
        'add_user', {
            'name':
            fields.String(required=True, description='code'),
            'email':
            fields.String(required=True, description='email'),
            'phone':
            fields.String(required=True, description='phone'),
            'user_role':
            fields.String(required=True, description='user_role', default='admin'),
            'city_id':
            NullableList(fields.Integer)
        })
    user_data = api.model(
        'user_data', {
            'user_id':
            fields.Integer(required=True, description='user_role', default=0),
            'user_role':
            fields.String(required=True, description='code')
        })
    supervisor_City_map = api.model(
        'supervisor_City_map', {
            'supervisor_id':
            fields.Integer(
                required=True, description='supervisor_id', default=0),
            'city_id':
            NullableList(fields.Integer)
        })
    supervisor_id = api.model(
        'supervisor_id', {
            'supervisor_id':
            fields.Integer(
                required=True, description='supervisor_id', default=0)
        })
    userCities = api.model(
        'userCities', {
            'id':
            fields.Integer(
                required=True, description='id', default=0)
        })
    
    get_users = api.model(
        'get_users', {
            'page' : fields.Integer(required=False, description = "Page Number"),
            'items' : fields.Integer(required=False, description = "Item Number"),
            'filter' : fields.String(required=True, description = "Filter String"),
            'search' : fields.String(required=False, description= "Search String")
        }
    )


class DashboardDto:
    api = Namespace('Superadmin Dashboard',
                    description='Dashboard Related Operations')

    mis_report = api.model(
        'mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date'),
            'city_ids': fields.List(fields.Integer, required=True, description="City ID's")
        }
    )
    order_mis_report = api.model(
        'order_mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date')
        }
    )


class DeliveryAgentDto:

    api = Namespace('Superadmin Delivery Agent',
                    description='Delivery Agent related operations')

    add_agent = api.model('add_agent', {
        'name': fields.String(required=True, description='agent name'),
        'api_link': fields.String(required=True, description='api link'),
        'api_key': fields.String(required=True, description='api key')
    })

    update_agent = api.model('update_agent', {
        'id': fields.Integer(required=True, description="id"),
        'name': fields.String(required=True, description='agent name'),
        'api_link': fields.String(required=True, description='api link'),
        'api_key': fields.String(required=True, description='api key')
    })

    delete_agent = api.model('delete_agent', {
        'id': fields.Integer(required=True, description="id")
    })

    status_change = api.model('change_status', {
        'id': fields.Integer(required=True, description="id"),
        'status': fields.Integer(required=True, description="status")
    })

class StoreBankDetailDto:
    api = Namespace('Super Admin Store Bank Details',
                    description='Store Bank Details related operations')
    get_payment = api.model('get_payment_', {
        'store_id': fields.Integer(required=True, description='Store ID')
    })
    add_store_bankdetails = api.model(
        'add_store_bankdetails_', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'store_id':
            fields.Integer(required=True, description='Store Id'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number')

        })
    update_store_bankdetails = api.model(
        'update_store_bankdetails_', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'store_id':
            fields.Integer(required=True, description='Store Id'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number'),
            'id':
            fields.Integer(required=True, description='Bank details ID')

        })
    delete_store_bankdetails = api.model(
        'delete_store_bankdetails_',
        {'id': fields.Integer(required=True, description='id'),
         'store_id': fields.Integer(required=True, description='id')})

    change_update = api.model(
        'change_update_', {
            'store_id': fields.Integer(required=True, description="Store Id"),
            'status': fields.Integer(required=True, description="Accept = 1, Reject = 0"),
            'id': fields.Integer(required=True, description="id")
        }
    )

class HubDto:
    api = Namespace('Super Admin Manage Hub',description = 'Hub related operations')

    create_hub_superadmin = api.model('create_hub_super_admin',{
        'name':
        fields.String(required=True, description='Name'),
        'image':
        fields.String(required=True, description='Image URL'),
        'address_line_1':
        fields.String(required=True, description='Address 1'),
        'address_line_2':
        fields.String(description='Address 2'),
        'hub_latitude':
        fields.Float(required=True, description='Latitude'),
        'hub_longitude':
        fields.Float(required=True, description='Longitude'),
        'radius':
        fields.Integer(required=True, description='Radius'),
        'city_name':
        fields.String(required=True,
                        description='City name'), 
        'delivery_associate_name': 
        fields.String(required=True,
                        description='Delivery Associate name'),
        'delivery_associate_email': 
        fields.String(required=True,
                        description='Delivery Associate email'),
        'delivery_associate_phone': 
        fields.String(required=True,
                        description='Delivery Associate phone'),
        'distributor_id':
        fields.Integer(required=False,
                        description='Delivery Associate phone')
    })

    get_hub = api.model("get_hub",{
        'slug':fields.String(required=True, description='slug')
    })

    delete_hub = api.model("delete_hub",{
        'slug':fields.String(required=True, description='slug')
    })

    update_hub_details = api.model("update_hub_details",{
        'slug':fields.String(required=True, description='slug'),
        'name':
        fields.String(required=True, description='Name'),
        'address_line_1':
        fields.String(required=True, description='Address 1'),
        'address_line_2':
        fields.String(description='Address 2'),
        'hub_latitude':
        fields.Float(required=True, description='Latitude'),
        'hub_longitude':
        fields.Float(required=True, description='Longitude'),
        'radius':
        fields.Integer(required=True, description='Radius'),
        'city_name':
        fields.String(required=False,
                        description='City name'), 
    })
    
    update_hub_image = api.parser()
    update_hub_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_hub_image.add_argument('slug', type=str, required=True)
    
    update_hub_image = api.parser()

    update_hub_status = api.model("update_hub_status",{
        'slug':fields.String(required=True, description='slug'),
        'status':fields.Integer(required=True, description='status code')
    })

    show_hub_tax = api.model(
        'show_hub_tax', {
            'slug':
            fields.String(required=True, description='Hub slug'),
        }
    )

    get_all_da = api.model('get_all_da',{
        'slug':
        fields.String(required=True, description='slug'),
    })
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

class HubBankDetailsDto:
    api = Namespace('Super Admin Hub Bank Details',
                    description='Hub Bank Details related operations')
    get_bank_details = api.model('get_bank_details', {
        'hub_slug':
            fields.String(required=True, description='Hub slug')
    })
    add_hub_bank_details = api.model(
        'add_hub_bank_details', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'hub_slug':
            fields.String(required=True, description='Hub slug'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number')

        })
    update_hub_bank_details = api.model(
        'update_hub_bank_details', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'hub_slug':
            fields.String(required=True, description='Hub slug'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number'),
            'id':
            fields.Integer(required=True, description='Bank details ID')

        })
    delete_hub_bank_details = api.model(
        'delete_hub_bank_details',
        {'id': fields.Integer(required=True, description='id'),
         'hub_slug':
            fields.String(required=True, description='Hub slug')})


class StorePaymentDto:
    api = Namespace('Super Admin Store Payment',
                    description='Store Payment related operations')
    
    get_store_payment = api.parser()
    get_store_payment.add_argument('page_no', type = int, required = True)
    get_store_payment.add_argument('item_per_page', type = int, required = True)
    get_store_payment.add_argument('searc', type = str, required = False)
    
    get_orders = api.parser()
    get_orders.add_argument('store_paymnet_id',type = int, required = True)