from flask_restx import Namespace, fields


class NullableString(fields.String):
    __schema_type__ = ['string', 'null']
    __schema_example__ = "null/string"


class NullableInteger(fields.Integer):
    __schema_type__ = ['integer', 'null']
    __schema_example__ = 0


class NullableFloat(fields.Integer):
    __schema_type__ = ['float', 'null']
    __schema_example__ = 0


class NullableList(fields.List):
    __schema_type__ = ['list', 'null']
    __schema_example__ = []


class CityDto:
    api = Namespace('Admin City', description='City related operations')
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
    api = Namespace('Admin Locality',
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
            fields.String(required=True, description='delivery_fee'),
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
            fields.String(required=True, description='delivery_fee'),
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


class StoreDto:
    api = Namespace('store', description='store related operations')
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
            'latitude':
            fields.String(required=True, description='Latitude'),
            'longitude':
            fields.String(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, description='End Time'),
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
            'latitude':
            fields.String(required=True, description='Latitude'),
            'longitude':
            fields.String(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, description='End Time'),
            'radius':
            fields.Integer(required=True, description='Radius'),
            'merchant_email':
            fields.String(required=True, description='merchant email address'),
            'merchant_name':
            fields.String(required=True, description='merchant name'),
            'merchant_phone':
            fields.String(required=True, description='merchant Phone'),
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
            'latitude':
            fields.String(required=True, description='Latitude'),
            'longitude':
            fields.String(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, description='End Time'),
            'radius':
            fields.Integer(required=True, description='Radius')
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
            'image':
            fields.String(required=True, description='Image URL'),
            'address_line_1':
            fields.String(required=True, description='Address 1'),
            'address_line_2':
            fields.String(description='Address 2'),
            'latitude':
            fields.String(required=True, description='Latitude'),
            'longitude':
            fields.String(required=True, description='Longitude'),
            'pay_later':
            fields.Integer(required=True, description='Pay Later'),
            'delivery_mode':
            fields.Integer(required=True, description='Delivery Mode'),
            'delivery_start_time':
            fields.String(required=True, description='Start Time'),
            'delivery_end_time':
            fields.String(required=True, description='End Time'),
            'radius':
            fields.Integer(description='Radius'),
            'status':
            fields.Integer(description='Status'),
        })
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
            fields.Integer(required=True, description='Store Menu Category id')
        })


class CategoryDto:
    api = Namespace('category', description='Category related operations')
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
    api = Namespace('menu_category', description='Category related operations')
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


class QuantityUnitDto:
    api = Namespace('quantity_unit', description='Category related operations')
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
    api = Namespace('store_item', description='Store Item related operations')
    add_store_item = api.model(
        'add_store_item', {
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
        })
    fetch_store_item_by_store_id = api.model(
        'fetch_store_item_by_store_id', {
            'store_id': fields.Integer(description='store_id'),
        })
    update_item_variable = api.model(
        'update_item_variable', {
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
            fields.Integer(required=True, description='status')
        })
    delete_store_item_variable = api.model(
        'delete_store_item_variable', {
            'store_item_variable_id':
            fields.Integer(required=True,
                           description='store_item_variable_id'),
            'store_item_id':
            fields.Integer(required=True, description='store_item_id')
        })


class CouponDto:
    api = Namespace('coupon', description='Coupon related operations')
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
            fields.Integer(required=True, description='deduction_type'),
            'deduction_amount':
            fields.Float(required=True, description='deduction_amount'),
            'min_order_value':
            fields.Float(
                required=True, description='min_order_value', default=0),
            'max_deduction':
            NullableFloat(description='max_deduction'),
            'max_user_usage_limit':
            fields.Integer(required=True, description='max_user_usage_limit'),
            'is_display':
            fields.Integer(required=True, description='is_display', default=1),
            'expired_at':
            NullableString(description='expired_at'),
        })
    fetch_coupon = api.model('fetch_coupon', {
        'filter': NullableString(description='filter'),
    })
    coupon_id = api.model(
        'coupon_id', {'id': fields.Integer(required=True, description='id')})
