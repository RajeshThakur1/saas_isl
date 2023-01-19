import re
from flask.globals import request
from flask_restx import Namespace, fields
from werkzeug.datastructures import FileStorage

from datetime import time
  
class NullableString(fields.String):
    __schema_type__ = ['string', 'null']
    __schema_example__ = "null/string"


class NullableInteger(fields.Integer):
    __schema_type__ = ['integer', 'null']
    __schema_example__ = 0


class NullableFloat(fields.Integer):
    __schema_type__ = ['float', 'null']
    __schema_example__ = 0.0


class NullableList(fields.List):
    __schema_type__ = ['list', 'null']
    __schema_example__ = []


class MerchantDto:

    api = Namespace('Merchant Profile',
                    description='merchant related operations')
    merchant_create = api.model(
        'merchant_create', {
            'email':
            fields.String(required=True, description='merchant email address'),
            'name':
            fields.String(description='merchant username'),
            'password':
            fields.String(required=True, description='merchant password'),
            'phone':
            fields.String(description='merchant Identifier'),
        })
    merchant_profile = api.model(
        'merchant_profile', {
            'name':
            fields.String(description='merchant username'),
            'password':
            fields.String(required=True, description='merchant password'),
            'phone':
            fields.String(description='merchant Identifier'),
        })

    change_password = api.model("change_password", {
        'old_password': fields.String(required=True, description="Old password"),
        'new_password': fields.String(required=True, description="New password")

    })

    update_profile = api.model("update_profile", {
        'email': fields.String(required=True, description="Email"),
        'password': fields.String(required=True, description="Password")
    })

    update_name = api.model("update_name", {
        'name': fields.String(required=True, description="Name"),
        'password': fields.String(required=True, description="Password")
    })

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


class StoreDto:
    api = Namespace('Merchant Store', description='store related operations')

    create_store_merchant = api.model(
        'create_store_merchant_', {
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
            fields.String(required=True, example="HH:MM",description='Time in HH:MM'),
            'delivery_end_time':
            fields.String(required=True, example="HH:MM",description='Time in HH:MM'),
            'radius':
            fields.Integer(required=True, description='Radius'),
            'city_name':
            fields.String(required=False,
                          description='City name with Capital First Letter'),
            'walk_in_order_tax':
            fields.Integer(required=True, description='Walk in Order Tax'),         
            'da_id':
            fields.Integer(required=True, description='Delivery Agent'),
            'beneficiary_name':
            fields.String(required=True, description='Beneficiary Name'),
            'name_of_bank':
            fields.String(required=True, description='Bank Name'),
            'ifsc_code':
            fields.String(required=True, description='Bank IFSC Code'),
            'account_number':
            fields.String(required=True, description='Bank Account Number'),
            'vpa':
            fields.String(required=False, description="Virtual Payment Address"),
            'self_delivery_price':
            fields.Float(required=False, description='Self Delivery Price')

        })

    update_store = api.model(
        'update_store', {
            'store_id':
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
            fields.Integer(required=True, description='Store Menu Category id'),
            'store_id':
            fields.Integer(required=True,
                           description='Store Menu Category id'),
        })

    add_store_tax = api.model(
        'add_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'name': fields.String(required=True, description="Tax Name"),
            'description': fields.String(required=False, description="Tax Description"),
            'tax_type': fields.Integer(required=True, description="Tax type Percentage or Flat"),
            'amount': fields.Float(required=True, description="Tax Ammount")
        }
    )

    update_store_tax = api.model(
        'update_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'name': fields.String(required=True, description="Tax Name"),
            'description': fields.String(required=False, description="Tax Description"),
            'tax_type': fields.Integer(required=True, description="Tax type Percentage or Flat"),
            'amount': fields.Float(required=True, description="Tax Ammount")
        }
    )

    delete_store_tax = api.model(
        'delete_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )

    show_store_tax = api.model(
        'show_store_tax', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

    walkin_tax_update = api.model(
        'walkin_tax_update', {
            'store_id': fields.Integer(required=True, description='Store Id'),
            'status': fields.Integer(required=True, description='Walk in Tax Status')
        }
    )

    walkin_tax_fetch = api.model(
        'walkin_tax_fetch', {
            'store_id': fields.Integer(required=True, description='Store Id'),
        }
    )
    
    walkin_commission_fetch = api.model(
        'walkin_commission_fetch', {
            'store_id': fields.Integer(required=True, description='Store Id'),
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

    set_agent = api.model(
        'set_agent_',
        {
            "store_id": fields.Integer(required=True, description='Item Order ID'),
            "agent_id": fields.Integer(required=True, description='Delivery Agent ID'),
            "delivery_price": fields.Float(required=False, description='Self Delivery Price')
        }
    )

    get_agent = api.model(
        'get_agent_',
        {
            "store_id": fields.Integer(required=True, description='Item Order ID'),
        }
    )


class CategoryDto:
    api = Namespace('Merchant Category',
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
    update_category = api.model(
        'update_category', {
            'id': fields.Integer(required=True, description='id'),
            'name': fields.String(required=True, description='Name'),
            'image': fields.String(description='Image'),
            'status': fields.Integer(required=True, description='status')
        })
    delete_category = api.model(
        'delete_category', {
            'id': fields.Integer(required=True, description='id'),
        })
    add_city_cat = api.model(
        'add_city_cat', {
            'cat_id': fields.Integer(required=True, description='id'),
            'city_id': fields.Integer(required=True, description='id'),
        })
    city_name = api.model(
        'city_name', {
            'city_name': fields.String(required=True, description='name'),
        })


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
            'image': fields.String(description='Image'),
            'slug': fields.String(description='slug'),
            'category_id': fields.Integer(required=True,
                                          description='category_id'),
            'status': fields.Integer(required=True, description='status')
        })
    delete_menu_category = api.model(
        'delete_menu_category',
        {'id': fields.Integer(required=True, description='id')})
    category_id = api.model('category_id', {
        'category_id':
        fields.Integer(required=True, description='category_id')
    })

    update_menucategory_image = api.parser()
    update_menucategory_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_menucategory_image.add_argument('id', type=str, required=True)
    update_menucategory_image.add_argument('category_id', type=str, required=True)
    
    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')


class QuantityUnitDto:
    api = Namespace('Merchant Quantity Unit',
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
    api = Namespace('Merchant Store Item',
                    description='Store Item related operations')

    upload_parser = api.parser()
    upload_parser.add_argument(
        'Excel File', location='files', type=FileStorage, required=True)
    upload_parser.add_argument(
        'store_id', location='args', type=int, required=True)
    add_store_item = api.model(
        'add_store_item_merchant', {
            'store_id':
            fields.Integer(description='store_id'),
            'menu_category_id':
            fields.Integer(description='menu_category_id'),
            'name':
            fields.String(description='name'),
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
            fields.Integer(required=True, description="stock"),
        })
    
    update_store_item = api.model(
        'update_store_item_merchant', {
            'store_item_id':
            fields.Integer(description='store_item_id'),
            'menu_category_id':
            fields.Integer(description='menu_category_id'),
            'name':
            fields.String(description='name'),
            'brand_name':
            fields.String(required=True, description='brand_name'),
            # 'image':
            # fields.String(required=True, description='image'),
        })
    
    update_store_item_image = api.parser()
    update_store_item_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_store_item_image.add_argument('id', type=str, required=True)

    
    
    fetch_store_item_by_store_id_merchant = api.model(
        'fetch_store_item_by_store_id_merchant', {
            'store_id': fields.Integer(description='store_id', required=True),
            'stock': fields.List(fields.Integer, description="stock_filter", required=False),
            'menu_categories': fields.List(fields.Integer, description="menu_categories_filter", required=False),
            'page': fields.Integer(description='page no', required=False),
            'item_per_page': fields.Integer(description='Item Per Page', required=False),
            'search': fields.String(description = "Search String")
        })
    fetch_store_item_by_store_id_merchant_count = api.model(
        'fetch_store_item_by_store_id_merchant_count', {
            'store_id': fields.Integer(description='store_id', required=True)
        })
    update_item_variable_stock = api.model(
        'update_item_variable_stock_merchant', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'stock':
            fields.Integer(required=True, description="stock"),
        })



    update_item_status= api.model(
        'update_item_status_merchant', {
            'store_item_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'status':
            fields.Integer(required=True, description="stock"),
        })

    update_item_variable = api.model(
        'update_item_variable_merchant', {
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
            fields.Integer(required=True, description="stock"),
        })
    update_item_variable_stock = api.model(
        'update_item_variable_stock_merchant', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'stock':
            fields.Integer(required=True, description="stock"),
        })
    delete_store_item_variable = api.model(
        'delete_store_item_variable', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'store_item_id':
            fields.Integer(required=True, description='store_item_id')
        })

    import_status = api.model(
        'import_status', {
            'user_id': fields.Integer(required=True, description='user_id'),
            'store_id': fields.Integer(required=True, description='store_id')
        }
    )

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

    max_stock = api.model('max_stock', {
            'store_id': fields.Integer(required=True, description=" Store ID")
        }
    )


class CouponDto:
    api = Namespace('Merchant Coupon',
                    description='Coupon related operations')
    add_coupon_merchant = api.model(
        'add_coupon_merchant', {
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
            fields.Integer(required=True, description='deduction_type'),
            'deduction_amount':
            fields.Integer(required=True, description='deduction_amount'),
            'min_order_value':
            fields.Integer(
                required=True, description='min_order_value', default=0),
            'max_deduction':
            NullableFloat(description='max_deduction'),
            'max_user_usage_limit':
            fields.Integer(required=True, description='max_user_usage_limit'),
            'is_display':
            fields.Integer(required=True, description='is_display', default=1),
            'expired_at':
            NullableString(description='expired_at'),
            'store_id':
                NullableList(fields.Integer)
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


class StoreBankDetailDto:
    api = Namespace('Merchant Store Bank Details',
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
            fields.String(required=False, description='vpa'),
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
            fields.String(required=False, description='vpa'),
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
    create_payment=api.model(
        'create_payment_',{
            'id' : fields.String(required=True, description="order id"),
            'address': fields.String(required=True, description='address_id'),
            'payment_gateway' : fields.String(required=True, description='typeof Gateway')

        })


class OrderDto:
    api = Namespace('Merchant Order', description='Order Related Operation')

    update_order = api.model(
        'update_order_',
        {
            "item_order_list_id": fields.Integer(required=True, description='Item Order List ID'),
            "item_order_id": fields.Integer(required=True, description='Item Order ID'),
            "quantity": fields.Integer(required=True, description='If Action == 1: Quantity to remove.')
        }
    )

    set_agent = api.model(
        'set_agent_',
        {
            "store_id": fields.Integer(required=True, description='Item Order ID'),
            "agent_id": fields.Integer(required=True, description='Delivery Agent ID'),
            "delivery_price": fields.Float(required=False, description='Self Delivery Price')
        }
    )

    accept_order = api.model(
        'accept_order_', {
            "item_order_id": fields.Integer(required=True, description='Item Order ID')
        }
    )
    order_details = api.model("order_details_", {
        'item_order_id': fields.Integer(required=True, description='order id')
    })

    reject_order = api.model("reject_order_", {
        'item_order_id': fields.Integer(required=True, description='order id')
    })

    ready_to_pack = api.model("ready_to_pack_", {
        'item_order_id': fields.Integer(required=True, description="order id")
    })

    place_order = api.model("ready_to_pack_", {
        'store_id': fields.Integer(required=True, description="store id"),
        'order_id': fields.Integer(required=True, description="order id")
    })

    cancel_order = api.model("cancel_order_", {
        "item_order_id": fields.Integer(required=True, description='order id')
    })

    picked_up_order = api.model("picked_up_order_", {
        "item_order_id": fields.Integer(required=True, description='order id')
    })

    deliver_order = api.model("deliver_order_", {
        "item_order_id": fields.Integer(required=True, description='order id')
    })



class HubOrderDto:
    api = Namespace('Merchant Hub Order', description='Merchant Hub Order Related Operations')


    fetch = api.model(
        'fetch_hub_order_details_merchant', {
            'hub_order_id': fields.Integer(required=True, description='Hub Order Id')
        } 
    )

    cancel_order = api.model(
        'cancel_hub_order_merchant', {
            'hub_order_id': fields.Integer(required=True, description='Hub Order Id')
        }
    )

    get_payments = api.model(
        'get_hub_order_payments_merchant', {
            'hub_order_id': fields.Integer(required=True, description='Hub Order Id')
        }
    )


    confirm_payment = api.model(
        'confirm_hub_order_payment_merchant', {
            'hub_order_id': fields.Integer(required=True, description='Hub Order Id'),
            'payment_id': fields.Integer(required=True, description='Payment ID'),
            'confirm': fields.Integer(required=True, description='1-> confirm ,  0-> reject')
        }
    )
    
    delete_items = api.model(
        'delete_items',{
            'hub_order_id': fields.Integer(required = True, description='Hub Order id'),
            'hub_order_list_ids' : fields.List(fields.Integer, required=True, description='Hub Order List ids'),
        }
    )
    
    confirm_order = api.model(
        'confirm_order',{
            'hub_order_id': fields.Integer(required = True, description='Hub Order id'),
            'confirmed' : fields.Integer(required=True, description='0 or 1'),
        }
    )


class HubCartDto:

    api = Namespace('Merchant Hub Cart', description='Merchant Hub Cart Related Operations')

    temp_cart = api.model(
        'temp_cart', {
            'store_id': fields.Integer(required=True, description='Store ID'),
            'pagination': fields.Boolean(required=True, description='True or False'),
            'page': fields.Integer(description = 'Page number'),
            'item_no': fields.Integer(description = 'Item per Page')
        }
    )
    
    hub_cart = api.model(
        'hub_cart', {
            'store_id': fields.Integer(required=True, description='Store ID'),
            # 'page': fields.Integer(description = 'Page number'),
            # 'item_no': fields.Integer(description = 'Item per Page')
        }
    )

    add_items = api.model(
        'add_items_to_hub_cart_by_store', {
            'store_id': fields.Integer(required=True, description='Store ID'),
            'store_item_variable_ids': fields.List(fields.Integer, required=True, description='Store Item Variable ID'),
            'quantity': fields.Integer(required=True, description='Quantity')
        }
    )

    update_item_quantity = api.model(
        'update_item_quantity_by_store', {
            'store_id': fields.Integer(required=True, description='Store ID'),
            'hub_order_list_id': fields.Integer(required=True, description='Hub Order List ID'),
            'quantity': fields.Integer(required=True, description='Quantity')
        }
    )

    remove_item = api.model(
        'remove_item_by_store', {
            'store_id': fields.Integer(required=True, description='Store ID'),
            'hub_order_list_id': fields.Integer(required=True, description='Hub Order List ID')
        }
    )
    
    remove_all_item = api.model(
        'remove_all_item_by_store', {
            'store_id': fields.Integer(required=True, description='Store ID'),
        }
    )

    fetch_hubs = api.model(
        'fetch_hubs_by_store_id', {
            'store_id': fields.Integer(required=True, description='Store ID')            
        }
    )


    select_hub = api.model(
        'select_hub_by_slug', {
            'hub_slug': fields.String(required=True, description='Hub Slug'),
            'store_id': fields.Integer (required=True, description='Store ID')        
        }
    )

    move_to_cart = api.model(
        'move_to_cart', {
            'hub_cart_id': fields.Integer(required=True, desctiption = ' Hub Cart ID'),
            'hub_order_list_ids': fields.List(fields.Integer, required=True, description = 'Hub order list id'),
            'store_id' : fields.Integer(required = False, description = "Store id for moving to temp cart")    
        }
    )

    remove_hub_cart = api.model(
        'remove_hub_cart', {
            'hub_cart_id': fields.Integer(required=True, description= ' Hub Cart ID')

        }
    )

    clear_hub_cart = api.model(
        'clear_hub_cart', {
            'hub_cart_id': fields.Integer(required=True, description= ' Hub Cart ID')

        }
    )


    place_order = api.model('place_hub_order', {
        'cart_id': fields.Integer(required=True, description='Cart ID'),
        
    })



class DashboardDto:
    api = Namespace('Merchant Dashboard',
                    description='Dashboard Related Operations')

    order_mis_report = api.model(
        'order_mis_report', {
            'start_date': fields.Date(required=True, description='Start Date'),
            'end_date': fields.Date(required=True, description='End Date')
        }
    )


class CartDto:
    # print("test...1234")
    api = Namespace('Merchant Cart',
                    description='Merchant Cart related operations')
    add_to_cart = api.model(
        'add_to_cart', {
            'store_item_id':
            fields.Integer(required=True, description='store_item_id'),
            'store_id':
            fields.Integer(required=True, description='store_id'),
            'store_item_variable_id':
            fields.Integer(required=True, description='store_item_variable_id')
        })
    remove_cart = api.model('remove_cart', {
        'cart_id':
        fields.Integer(
            required=True, description='this API will remove the cart'),
    })
    remove_item = api.model('remove_item', {
        'item_order_list_id':
            fields.Integer(
                required=True, description='this API will remove the item from the cart'),
        'store_id':
            fields.Integer(
                required=True, description='store id of logged in merchant'),
    })
    update_item_count = api.model('update_item_count', {
        'item_order_list_id':
            fields.Integer(
                required=True, description='this API will remove the item from the cart'),
        'store_id':
            fields.Integer(
                required=True, description='store id of logged in merchant'),
        'method':
            fields.String(required=True, description='Method Type')
    })
    get_from_cart = api.model('remove_from_cart', {
        'cart_id':
        fields.Integer(required=True, description='cart id'),
    })

    delivery_fee = api.model('delivery_fee', {
        'order_id': fields.String(required=True, description='Order Id'),
        'address_id': fields.Integer(required=True, description='Address Id')
    })

    globelSearch = api.model(
        'globelSearch', {
            'search_string':
                fields.String(required=True, description='Store slug'),
            # 'item_name': fields.String(required=True, description='item_name'),
            "store_id": fields.Integer(required=True, description='store_id')
        }
    )
    storeId = api.model(
        'storeId', {
            'store_id': fields.Integer(required=True, description="store id")
        }
    )

    place_order = api.model("ready_to_pack_", {
        'cart_id': fields.Integer(required=True, description="order id")
    })
    
    cart_count = api.model(
        'cart_count', {
            'store_id': fields.Integer(required=True, description="store id")
        }
    )


class DeliveryDto:

    api = Namespace('Merchant Delivery Agent',
                    description='Merchant Delivery Agent related operations')

    set_agent = api.model(
        'set_agent_',
        {
            "store_id": fields.Integer(required=True, description='Item Order ID'),
            "agent_id": fields.Integer(required=True, description='Delivery Agent ID'),
            "delivery_price": fields.Float(required=False, description='Self Delivery Price')
        }
    )


class StorePaymentDto:
    api = Namespace('Merchant Store Payment',
                    description='Store Payment related operations')
    
    get_store_payment = api.parser()
    get_store_payment.add_argument('page_no', type = int, required = True)
    get_store_payment.add_argument('item_per_page', type = int, required = True)
    get_store_payment.add_argument('searc', type = str, required = False)
    
    get_orders = api.parser()
    get_orders.add_argument('store_paymnet_id',type = int, required = True)
