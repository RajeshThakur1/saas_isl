from app.main.service.v1.profile_service import change_password
from werkzeug.datastructures import FileStorage
from app.main.service.v1.store_service import update_delivery_type, update_paylater
from app.main.service.v1.locality_service import update_locality
from flask_restx import Namespace, fields


class NullableString(fields.String):
    __schema_type__ = ['string', 'null']
    __schema_example__ = "null/string"


class NullableInteger(fields.Integer):
    __schema_type__ = ['integer', 'null']
    __schema_example__ = 0


class NullableList(fields.List):
    __schema_type__ = ['list', 'null']
    __schema_example__ = []




class StoreItemDto:
    api = Namespace('Supervisor Manage Store Items',
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
            'image':
            fields.String(required=True, description='image'),
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

    update_item_variable_stock = api.model(
        'update_item_variable_stock_merchant', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'stock':
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


class SupervisorDto:
    api = Namespace('Supervisor Profile',
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

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

class OrderDto:
    api = Namespace('Supervisor Order',
                    description="Supervisor order related operations.")

    accept_order = api.model(
        'accept_order', {
            'order_id': fields.Integer(required=True, description='Order ID')
        }
    )

    order_details = api.model(
        'order_details', {
            'order_id': fields.Integer(required=True, description='Order ID')
        }
    )

    reject_order = api.model(
        'reject_order', {
            'order_id': fields.Integer(required=True, description='Order ID')
        }
    )

    cancel_order = api.model(
        'cancel_order', {
            'order_id': fields.Integer(required=True, description='Order ID')
        }
    )


class LocationDto:
    api = Namespace('Supervisor Manage Location',
                    description="Supervisor location related operations")

    get_locality_details = api.model("get_locality_details", {
        'city_id': fields.Integer(required=True, description='City ID')
    })

    update_localities = api.model("update_localites", {
        'city_id': fields.Integer(required=True, description='City ID'),
        'start_time': fields.String(required=True, description="Delivery Start Time"),
        'end_time': fields.String(required=True, description="Delivery End Time"),
        'delivery_fee': fields.String(required=True, description="Delivery Free")

    })


class StoreDto:
    api = Namespace('Supervisor Manage Store',
                    description="Supervisor Store Related Operation")

    status_change = api.model("status_change", {
        'store_id': fields.Integer(required=True, description="Store ID"),
        'status': fields.Integer(required=True, description="Store Status")
    })

    update_store_image = api.parser()
    update_store_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_store_image.add_argument('id', type=str, required=True)
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')
    
    delete_store = api.model("delete_store", {
        'store_id': fields.Integer(required=True, description="Store ID")
    })

    store_id = api.model("store_id", {
        'store_id': fields.Integer(required=True, description="Store ID")
    })
    
    approve_store = api.model(
        'approve_store',{
            'store_id': fields.Integer(required=True, description='Store id'),
            'approve' : fields.Integer(required= True, description = '0 for reject & 1 for approve')
         })
    
    onboard_stores = api.parser()
    onboard_stores.add_argument('query', type=str, required=False)
    onboard_stores.add_argument('status', type=int, required=False)
    onboard_stores.add_argument('city_id', type= int, required=False)
    onboard_stores.add_argument('page', type=int, required=False)
    onboard_stores.add_argument('items_per_page', type=int, required=False)
    
    add_commission = api.model(
        'add_commission', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'commission': fields.Float(required=True, description='Commision Percentage')
        }
    )
    
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

    show_store_tax = api.model(
        'show_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )

    delivery_type = api.model("delivery_type", {
        'store_id': fields.Integer(required=True, description='Store Id'),
        'delivery_mode': fields.Integer(required=True, description='Delivery Mode'),
        'delivery_start_time': fields.String(required=True, description="Delivery Start Time"),
        'delivery_end_time': fields.String(required=True, description="Delivery End Time")
    })

    update_paylater = api.model("update_paylater", {
        'store_id': fields.Integer(required=True, description='Store Id'),
        'pay_later': fields.Integer(required=True, description="Status")
    })

    store_mis = api.model(
        'store_mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date'),
            'store_id': fields.Integer(required=True, description="Store ID")
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

class DashboardDto:
    api = Namespace('Supervisor Dashboard',
                    description='Dashboard Related Operations')

    order_mis_report = api.model(
        'order_mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date')
        }
    )


class StoreBankDetailDto:
    api = Namespace('Supervisor Store Bank Details',
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
            fields.String(required=True, description='vpa'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='vpa')

        })
    update_store_bankdetails = api.model(
        'update_store_bankdetails_', {
            'id':
            fields.Integer(required=True, description='id'),
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'store_id':
            fields.String(required=True, description='vpa'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='vpa')

        })
    delete_store_bankdetails = api.model(
        'delete_store_bankdetails_',
        {
            'id': fields.Integer(required=True, description='id'),
            'store_id': fields.Integer(required=True, description='Store ID')
        })


class QuantityUnitDto:
    api = Namespace('Supervisor Quantity Unit',
                    description='Quantity related operations')


class MenuCategoryDto:
    api = Namespace('Merchant Menu Category',
                    description='Category related operations')
    add_menu_category = api.model(
        'add_menu_category', {
            'name': fields.String(description='name'),
            'image': fields.String(description='image'),
            'slug': fields.String(description='slug'),
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
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


class CouponDto:
    api = Namespace('Supervisor Coupon',
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
                fields.Integer(
                    required=True, description='max_user_usage_limit'),
            'is_display':
                fields.Integer(
                    required=True, description='is_display', default=1),
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
class CategoryDto:
    api = Namespace('Supervisor Category',
                    description='Category related operations')

class HubOrderDto:
    api = Namespace('Supervisor Distributor Orders', description='Order Related Operation')

    order_details = api.model("order_details_distributor", {
        'hub_order_id': fields.Integer(required=True, description='order id')
    })

    get_payment = api.model("get_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
    })


class HubDto:
    api = Namespace('Supervisor Manage Hub',description = 'Hub related operations')

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

    update_hub_status = api.model("update_hub_status",{
        'slug':fields.String(required=True, description='slug'),
        'status':fields.Integer(required=True, description='status code')
    })

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


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

class HubBankDetailsDto:
    api = Namespace('Supervisor Hub Bank Details',
                    description='Hub Bank Details related operations')
    get_bank_details = api.model('get_bank_details', {
        'hub_slug':
            fields.String(required=True, description='Hub slug'),
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
    api = Namespace('Supervisor Store Payment',
                    description='Store Payment related operations')
    
    get_store_payment = api.parser()
    get_store_payment.add_argument('page_no', type = int, required = True)
    get_store_payment.add_argument('item_per_page', type = int, required = True)
    get_store_payment.add_argument('searc', type = str, required = False)
    
    get_orders = api.parser()
    get_orders.add_argument('store_paymnet_id',type = int, required = True)