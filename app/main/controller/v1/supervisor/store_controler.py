from app.main.service.v1.delivery_service import get_delivery_agent
from flask.globals import request
from app.main.service.v1.image_service import image_save
from app.main.service.v1.store_service import add_store_commison, approve_store, create_store_category_map, create_store_menu_category_map, delete_all_store_menu_category, delete_store_category, delete_store_menu_category, fetch_store_category_map, fetch_store_menu_category_map, get_merchant_details_by_store, show_all_store_info_by_id, show_onboarding_stores, show_store_by_id, show_store_tax, store_mis_graph, store_mis_report, store_status_change, supervisor_fetch_stores, supervisor_store_delete, update_delivery_type, update_paylater, update_store_image, walkin_commission_status_change, walkin_commission_status_fetch, walkin_tax_status_change, walkin_tax_status_fetch
from flask_restx import Resource
from app.main.util.v1.decorator import supervisor_token_required
from app.main.util.v1.supervisor_dto import StoreDto
from app.main.config import store_dir

api = StoreDto.api
_status_change = StoreDto.status_change
_update_store_image = StoreDto.update_store_image
_image_upload = StoreDto.image_upload
_delete_store = StoreDto.delete_store
_store_id = StoreDto.store_id
_store_category_create = StoreDto.store_category_create
_store_category_delete = StoreDto.store_category_delete
_store_menu_category_create = StoreDto.store_menu_category_create
_store_menu_category_delete = StoreDto.store_menu_category_delete
_show_store_tax = StoreDto.show_store_tax
_delivery_type = StoreDto.delivery_type
_update_paylater = StoreDto.update_paylater
_store_mis = StoreDto.store_mis
_get_agent = StoreDto.get_agent
_walkin_tax_fetch = StoreDto.walkin_tax_fetch
_walkin_tax_update = StoreDto.walkin_tax_update
_walkin_commission_fetch = StoreDto.walkin_commission_fetch
_walkin_commission_update = StoreDto.walkin_commission_update
_approve_store_admin = StoreDto.approve_store
_onboard_stores = StoreDto.onboard_stores
_add_commission = StoreDto.add_commission
@api.route('/')
class GetSupervisorStoreList(Resource):
    @api.doc("Fetch Supervisor Stores")
    @api.doc(security="api_key")
    @api.response(200, 'Supervisor Stores Fetched')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Items per page')
    @api.param(name='query', description='query string', required=True)
    @supervisor_token_required
    def get(self):
        """Fetch Supervisor Stores"""
        return supervisor_fetch_stores()

@api.route('/show_onboarding_stores')
class ShowOnboardingV2(Resource):
    @api.response(201, 'New Store successfully created.')
    @api.doc('Show Onboard Stores')
    @api.doc(security='api_key')
    @api.expect(_onboard_stores, validate=True)
    @supervisor_token_required
    def get(self):
        data = _onboard_stores.parse_args()
        return show_onboarding_stores(data)
    
@api.route('/status_change')
class StoreStatusChange(Resource):
    @api.doc("Change Supervisor Store Status")
    @api.doc(security="api_key")
    @api.expect(_status_change, validate=True)
    @api.response(200, 'Store Enabled')
    @api.response(200, 'Store Disabled')
    @supervisor_token_required
    def post(self):
        """Change Supervisor Store Status"""
        data = request.json
        return store_status_change(data)

@api.route('/update_store_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store Image Update')
    @api.doc(security='api_key')
    @api.expect(_update_store_image, validate = True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Store Image Upload"""

        return image_save(request, store_dir)

@api.route('/delete_store')
class StoreDelete(Resource):
    @api.doc("Delete a Store")
    @api.doc(security="api_key")
    @api.expect(_delete_store, validate=True)
    @api.response(200, 'Store Deleted Successfully')
    @supervisor_token_required
    def post(self):
        """Delete a Store"""
        data = request.json
        return supervisor_store_delete(data)


@api.route('/fetch/by_id')
class StoreListByID(Resource):
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @supervisor_token_required
    def post(self, **kwargs):
        """Show Store Data w.r.t ID"""
        data = request.json
        return show_store_by_id(data=data)

@api.route('/fetch/by_id_v2')
class StoreListByIDV2(Resource):
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @supervisor_token_required
    #@check_merchant_access
    def post(self, **kwargs):
        """Show Store Data w.r.t ID V2"""
        data = request.json
        return show_all_store_info_by_id(data=data)
    
@api.route('/get_merchant_details')
class GetMerchantDetails(Resource):
    @api.response(200, "Merchant Details Fetched Successfuly")
    @api.doc('Get Merchant Details by Store')
    @api.doc(security = 'api_key')
    @api.expect(_store_id, validate=True)
    @supervisor_token_required
    def post(self):
        """Get Merchant Details by Store"""
        data = request.json
        return get_merchant_details_by_store(data)


@api.route('/store_category_map/fetch')
class FetchStoreCategoryMap(Resource):
    @api.response(200, 'Store Category Map successfully Fetched.')
    @api.doc('Fetch Store Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_id, validate=True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Delete a Store Category Map"""
        data = request.json
        return delete_store_category(data)


@api.route('/store_category_map/create')
class CreateStoreCategoryMap(Resource):
    @api.response(201, 'Store Category successfully Mapped.')
    @api.doc('Create Store Category Map')
    @api.doc(security='api_key')
    @api.expect(_store_category_create, validate=True, as_list=True)
    @supervisor_token_required
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
    @supervisor_token_required
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
    @supervisor_token_required
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
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Delete a Store Menu Category Map"""
        data = request.json


@api.route('/store_taxes/')
class StoreTaxesUpdate(Resource):
    @api.response(201, 'Tax Details Fetched')
    @api.doc(security='api_key')
    @api.doc('Fetch store tax')
    @api.expect(_show_store_tax, validate=True)
    @supervisor_token_required
    def post(self):
        """Fetch store tax"""
        data = request.json
        return show_store_tax(data=data)


@api.route('/delivery/mode_change')
class StoreDeliveryUpdate(Resource):
    @api.doc(security='api_key')
    @api.doc('Update Delivery Details')
    @api.expect(_delivery_type, validate=True)
    @supervisor_token_required
    def post(self):
        """Update Delivery Details"""
        data = request.json
        return update_delivery_type(data=data)


@api.route('/pay_later/update')
class StoreDeliveryUpdate(Resource):
    @api.doc(security='api_key')
    @api.doc('Update Pay Later')
    @api.expect(_update_paylater, validate=True)
    @supervisor_token_required
    def post(self):
        """Update Pay Later"""
        data = request.json
        return update_paylater(data=data)

@api.route('/mis_report')
class DetailedMisReport(Resource):
    @api.response(200, "Store Mis Report From start_date to end_date' Fetched Successfully")
    @api.doc('Shows Store MIS Report in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_store_mis, validate=True)
    @supervisor_token_required
    def post(self):
        """Shows Store MIS Report in Given Timeframe"""
        data = request.json
        return store_mis_report(data)


@api.route('/mis_graph')
class DetailedMisReport(Resource):
    @api.response(200, "Store Mis Graph From start_date to end_date' Fetched Successfully")
    @api.doc('Shows Store MIS Graph in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_store_mis, validate=True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Get delivery agent for an Store"""
        data = request.json
        return get_delivery_agent(data)

@api.route('/walkin_order_tax_status_fetch')
class GetWalkinOrderTax(Resource):
    @api.doc(security='api_key')
    @api.doc('Get Walkin Order Tax Status')
    @api.expect(_walkin_tax_fetch, validate=True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Change Walkin Order Tax Status"""
        data = request.json
        return walkin_tax_status_change(data)
@api.route('/walkin_order_commission_status_fetch')
class GetWalkinOrderCommission(Resource):
    @api.doc(security='api_key')
    @api.doc('Get Walkin Order Commission Status')
    @api.expect(_walkin_commission_fetch, validate=True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Change Walkin Order Commission Status"""
        data = request.json
        return walkin_commission_status_change(data)
    
@api.route('/store_approve')
class ApproveStore(Resource):
    @api.response(201, 'New Store successfully approved.')
    @api.doc('Approve a new Store by Supervisor')
    @api.doc(security='api_key')
    @api.expect(_approve_store_admin, validate=True)
    @supervisor_token_required
    def post(self):
        """Approves the new Store By Admin"""
        data = request.json
        return approve_store(data)
    
@api.route('/add_commission')
class AddStoreCommision(Resource):
    @api.response(200, 'Commision Added successfully')
    @api.doc(security='api_key')
    @api.doc('Add Commision to a store')
    @api.expect(_add_commission, validate=True)
    @supervisor_token_required
    def post(self):
        """Commision Added successfully"""
        data = request.json
        return add_store_commison(data)