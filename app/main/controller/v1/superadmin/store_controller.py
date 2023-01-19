from app.main.service.v1.delivery_service import get_delivery_agent
from app.main.service.v1.image_service import image_save
from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import StoreDto
from ....service.v1.store_service import add_store_commison, approve_store, delete_all_store_menu_category, get_merchant_details_by_store, show_all_store_info_by_id, show_onboarding_stores,show_store_by_id,\
    create_store_category_map,show_all_store,create_store_by_admin, fetch_store_menu_category_map,\
    delete_store_menu_category, create_store_menu_category_map, show_store_tax, show_unapproved_stores, store_mis_graph, store_mis_report, store_status_change, update_delivery_type, update_paylater, update_store, delete_store, \
    delete_store_category, fetch_store_category_map, update_store_image, walkin_commission_status_change, walkin_commission_status_fetch, walkin_tax_status_change, walkin_tax_status_fetch

from app.main.config import store_dir
from flask import Blueprint
from app.main import db

main = Blueprint('main', __name__, template_folder='templates')
api = StoreDto.api
_edit_store = StoreDto.update_store
_update_store_image = StoreDto.update_store_image
_image_upload = StoreDto.image_upload
find_store1 = StoreDto.find_store
_store_id = StoreDto.store_id
find_store_by_location_category = StoreDto.find_store_by_location_category
_store_category_delete = StoreDto.store_category_delete
_store_menu_category_create = StoreDto.store_menu_category_create
_store_menu_category_delete = StoreDto.store_menu_category_delete
_create_store_admin = StoreDto.create_store_admin
_approve_store_admin = StoreDto.approve_store
_store_category_create = StoreDto.store_category_create
_add_commission = StoreDto.add_commission
_delivery_type = StoreDto.delivery_type
_update_paylater = StoreDto.update_paylater
_status_change = StoreDto.status_change
_store_mis = StoreDto.store_mis
_show_store_tax = StoreDto.show_store_tax
_get_agent = StoreDto.get_agent
_walkin_tax_fetch = StoreDto.walkin_tax_fetch
_walkin_tax_update = StoreDto.walkin_tax_update
_walkin_commission_fetch = StoreDto.walkin_commission_fetch
_walkin_commission_update = StoreDto.walkin_commission_update
_unapproved_stores = StoreDto.unapproved_stores
_onboard_stores = StoreDto.onboard_stores

@api.route('/create')
class StoreCreate(Resource):
    @api.response(201, 'New Store successfully created.')
    @api.doc('create a new Store by Admin')
    @api.doc(security='api_key')
    @api.expect(_create_store_admin, validate=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Store By Admin"""
        data = request.json
        return create_store_by_admin(data)


@api.route('/show_unapproved')
class ShowOnboarding(Resource):
    @api.response(201, 'New Store successfully created.')
    @api.doc('Show Unapproved Stores')
    @api.doc(security='api_key')
    @api.expect(_unapproved_stores, validate=True)
    @super_admin_token_required
    def get(self):
        data = _unapproved_stores.parse_args()
        return show_unapproved_stores(data)

@api.route('/show_onboarding_stores')
class ShowOnboardingV2(Resource):
    @api.response(201, 'New Store successfully created.')
    @api.doc('Show Onboard Stores')
    @api.doc(security='api_key')
    @api.expect(_onboard_stores, validate=True)
    @super_admin_token_required
    def get(self):
        data = _onboard_stores.parse_args()
        return show_onboarding_stores(data)
    
@api.route('/store_approve')
class ApproveStore(Resource):
    @api.response(201, 'New Store successfully approved.')
    @api.doc('Approve a new Store by Admin')
    @api.doc(security='api_key')
    @api.expect(_approve_store_admin, validate=True)
    @super_admin_token_required
    def post(self):
        """Approves the new Store By Admin"""
        data = request.json
        return approve_store(data)

@api.route('/get_merchant_details')
class GetMerchantDetails(Resource):
    @api.response(200, "Merchant Details Fetched Successfuly")
    @api.doc('Get Merchant Details by Store')
    @api.doc(security = 'api_key')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Get Merchant Details by Store"""
        data = request.json
        return get_merchant_details_by_store(data)

@api.route('/')
class StoreList(Resource):
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='query', description='Query String')
    @super_admin_token_required
    def get(self, **kwargs):
        """Show all Stores 
         item_per_page should be [5, 10, 25, 50, 100]"""
        return show_all_store()


@api.route('/fetch/by_id')
class StoreListByID(Resource):
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self, **kwargs):
        """Show Store Data w.r.t ID"""
        data = request.json
        return show_store_by_id(data=data)

@api.route('/fetch/by_id_v2')
class StoreListByIDV2(Resource):
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    #@check_merchant_access
    def post(self, **kwargs):
        """Show Store Data w.r.t ID V2"""
        data = request.json
        return show_all_store_info_by_id(data=data)

@api.route('/update')
class StoreUpdate(Resource):
    @api.response(201, 'Store successfully Updated.')
    @api.doc('update a Store')
    @api.doc(security='api_key')
    @api.expect(_edit_store, validate=True)
    @super_admin_token_required
    def post(self):
        """updates a Store """
        data = request.json
        return update_store(data=data)

@api.route('/update_store_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store Image Update')
    @api.doc(security='api_key')
    @api.expect(_update_store_image, validate = True)
    @super_admin_token_required
    def post(self):
        """Store Image Update"""
        data = _update_store_image.parse_args()
        return update_store_image(data)
    
@api.route('/image_upload')
class StoreImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Store Image Upload"""

        return image_save(request, store_dir)
    
@api.route('/delete')
class StoreDelete(Resource):
    @api.response(201, 'Store successfully Deleted.')
    @api.doc(security='api_key')
    @api.doc('delete a Store')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Store """
        data = request.json
        return delete_store(data=data)


@api.route('/store_category_map/fetch')
class FetchStoreCategoryMap(Resource):
    @api.response(200, 'Store Category Map successfully Fetched.')
    @api.doc('Fetch Store Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch Store Category Map"""
        data = request.json
        return fetch_store_category_map(data=data)


@api.route('/store_category_map/delete')
class StoreCategoryDelete(Resource):
    @api.response(201, 'Store Category successfully Deleted.')
    @api.doc(security='api_key')
    @api.doc('delete a Store Category Map')
    @api.expect(_store_category_delete, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Store Category Map"""
        data = request.json
        return delete_store_category(data=data)


@api.route('/store_category_map/create')
class CreateStoreCategoryMap(Resource):
    @api.response(201, 'Store Category successfully Mapped.')
    @api.doc('Create Store Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_category_create, validate=True, as_list=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Store Category Map"""
        data = request.json
        return create_store_category_map(data=data)


@api.route('/store_menu_category_map/create')
class CreateStoreMenuCategoryMap(Resource):
    @api.response(201, 'Store Menu Category successfully Mapped.')
    @api.doc('Create Store Menu Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_menu_category_create, validate=True, as_list=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Store Menu Category Map"""
        data = request.json
        return create_store_menu_category_map(data=data)


@api.route('/store_menu_category_map/fetch')
class FetchStoreCategoryMap(Resource):
    @api.response(200, 'Store Menu Category Map successfully Fetched.')
    @api.doc('Fetch Store Menu Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch Store Menu Category Map"""
        data = request.json
        return fetch_store_menu_category_map(data=data)


@api.route('/store_menu_category_map/delete')
class StoreMenuCategoryDelete(Resource):
    @api.response(201, 'Store Menu Category successfully Deleted.')
    @api.doc(security='api_key')
    @api.doc('delete a Store Menu Category Map')
    @api.expect(_store_menu_category_delete, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Store Menu Category Map"""
        data = request.json
        return delete_store_menu_category(data=data)


@api.route('/store_menu_category_map/delete_all')
class StoreMenuCategoryDeleteAll(Resource):
    @api.response(201, 'Store Menu Categories successfully Deleted.')
    @api.doc(security='api_key')
    @api.doc('delete all Store Menu Category Map')
    @api.expect(_store_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Store Menu Category Map"""
        data = request.json
        return delete_all_store_menu_category(data=data)

@api.route('/add_commission')
class AddStoreCommision(Resource):
    @api.response(200, 'Commision Added successfully')
    @api.doc(security='api_key')
    @api.doc('Add Commision to a store')
    @api.expect(_add_commission, validate=True)
    @super_admin_token_required
    def post(self):
        """Commision Added successfully"""
        data = request.json
        return add_store_commison(data)


@api.route('/pay_later/update')
class StoreDeliveryUpdate(Resource):
    @api.doc(security='api_key')
    @api.doc('Update Pay Later')
    @api.expect(_update_paylater, validate=True)
    @super_admin_token_required
    def post(self):
        """Update Pay Later"""
        data = request.json
        return update_paylater(data=data)

@api.route('/status_change')
class StoreStatusChange(Resource):
    @api.doc("Change Super Admin Store Status")
    @api.doc(security="api_key")
    @api.expect(_status_change, validate = True)
    @api.response(200, 'Store Enabled')
    @api.response(200, 'Store Disabled')
    @super_admin_token_required
    def post(self):
        """Change Super Admin Store Status"""
        data = request.json
        return store_status_change(data)

@api.route('/delivery/mode_change')
class StoreDeliveryUpdate(Resource):
    @api.doc(security='api_key')
    @api.doc('Update Delivery Details')
    @api.expect(_delivery_type, validate=True)
    @super_admin_token_required
    def post(self):
        """Update Delivery Details"""
        data = request.json
        return update_delivery_type(data=data)

@api.route('/mis_report')
class DetailedMisReport(Resource):
    @api.response(200, "Store Mis Report From start_date to end_date' Fetched Successfully")
    @api.doc('Shows Store MIS Report in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_store_mis,validate=True)
    @super_admin_token_required
    def post(self):
        """Shows Store MIS Report in Given Timeframe"""
        data = request.json
        return store_mis_report(data)

@api.route('/store_taxes/')
class StoreTaxesUpdate(Resource):
    @api.response(201, 'Tax Details Fetched')
    @api.doc(security='api_key')
    @api.doc('Fetch store tax')
    @api.expect(_show_store_tax, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch store tax"""
        data = request.json
        return show_store_tax(data=data)

@api.route('/mis_graph')
class DetailedMisReport(Resource):
    @api.response(200, "Store Mis Graph From start_date to end_date' Fetched Successfully")
    @api.doc('Shows Store MIS Graph in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_store_mis,validate=True)
    @super_admin_token_required
    def post(self):
        """Shows Store MIS Graph in Given Timeframe"""
        data = request.json
        return store_mis_graph(data)

@api.route('/get_delivery_agent')
class SetDeliveryAgent(Resource):
    @api.doc("""Get delivery agent for an store""")
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized Request')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @api.expect(_get_agent, validate=True)
    @super_admin_token_required
    def post(self):
        """Get delivery agent for an Store"""
        data = request.json
        return get_delivery_agent(data)

@api.route('/walkin_order_tax_status_fetch')
class GetWalkinOrderTax(Resource):
    @api.doc(security='api_key')
    @api.doc('Get Walkin Order Tax Status')
    @api.expect(_walkin_tax_fetch, validate=True)
    @super_admin_token_required
    def post(self):
        """Get Walkin Order Tax Status"""
        data = request.json
        return walkin_tax_status_fetch(data)
    
@api.route('/walkin_order_tax_status_update')
class UpdateWalkinOrderTax(Resource):
    @api.response(200, 'Tax status changed')
    @api.doc(security='api_key')
    @api.doc('Change Walkin Order Tax Status')
    @api.expect(_walkin_tax_update, validate=True)
    @super_admin_token_required
    def post(self):
        """Change Walkin Order Tax Status"""
        data = request.json
        return walkin_tax_status_change(data)


@api.route('/walkin_order_commission_status_fetch')
class GetWalkinOrderCommission(Resource):
    @api.doc(security='api_key')
    @api.doc('Get Walkin Order Commission Status')
    @api.expect(_walkin_commission_fetch, validate=True)
    @super_admin_token_required
    def post(self):
        """Get Walkin Order Commission Status"""
        data = request.json
        return walkin_commission_status_fetch(data)

@api.route('/walkin_order_commission_status_update')
class UpdateWalkinOrderTax(Resource):
    @api.response(200, 'Commission status changed')
    @api.doc(security='api_key')
    @api.doc('Change Walkin Order Commission Status')
    @api.expect(_walkin_commission_update, validate=True)
    @super_admin_token_required
    def post(self):
        """Change Walkin Order Commission Status"""
        data = request.json
        return walkin_commission_status_change(data)
