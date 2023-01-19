from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import StoreItemDto
from ....service.v1.store_item_service import *
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = StoreItemDto.api
_add_store_item = StoreItemDto.add_store_item
_update_store_item_image = StoreItemDto.update_store_item_image
_image_upload = StoreItemDto.image_upload
_fetch_store_item_by_store_id = StoreItemDto.fetch_store_item_by_store_id
_fetch_store_item_by_store_id_count = StoreItemDto.fetch_store_item_by_store_id_count
_update_store_item_variable = StoreItemDto.update_item_variable
_update_store_item_status = StoreItemDto.update_item_status
_update_store_item_variable_stock = StoreItemDto.update_item_variable_stock
_delete_store_item_variable = StoreItemDto.delete_store_item_variable
_max_stock = StoreItemDto.max_stock

@api.route('/create')
class StoreCreate(Resource):
    @api.response(201, 'Store Item successfully created.')
    @api.doc('create a new Store item')
    @api.doc(security='api_key')
    @api.expect(_add_store_item, validate=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Store Item"""
        data = request.json
        return create_store_item(data=data)


@api.route('/')
class ShowStores(Resource):
    @api.response(200, 'Store Item successfully wrt Store Id.')
    @api.doc('Fetch Store Items wrt store id')
    @api.doc(security='api_key')
    @api.expect(_fetch_store_item_by_store_id, validate=True)
    # @api.param(name='page', description='Page no.')
    # @api.param(name='item_per_page', description='Item Per Page')
    @super_admin_token_required
    def post(self):
        """Fetch Store items wrt Store ID
         item_per_page should be [5, 10, 25, 50, 100]"""
        data = request.json
        return fetch_store_items_by_id1(data=data)

@api.route('/update_store_item_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Update')
    @api.doc(security='api_key')
    @api.expect(_update_store_item_image, validate = True)
    @super_admin_token_required
    def post(self):
        """Store Item Image Update"""
        data = _update_store_item_image.parse_args()
        return update_store_item_image(data)
@api.route('/image_upload')
class StoreItemImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Image Upload"""

        return image_save(request, item_icon_dir)
@api.route('/update_item_variable')
class StoreUpdate(Resource):
    @api.response(201, 'Store Item Variable successfully updated.')
    @api.doc('Update a Store item Variable')
    @api.doc(security='api_key')
    @api.expect(_update_store_item_variable, validate=True)
    @super_admin_token_required
    def post(self):
        """Update a Store item Variable"""
        data = request.json
        return update_store_item_variable(data=data)

@api.route('/add_stock')
class StoreAddStock(Resource):
    @api.response(201, 'Store Item Variable stock successfully added.')
    @api.doc('Update a Store item Variable\'s Stock')
    @api.doc(security='api_key')
    @api.expect(_update_store_item_variable_stock, validate=True)
    @super_admin_token_required
    def post(self):
        """Update a Store item Variable's stock"""
        data = request.json
        return update_store_item_variable_stock(data=data)

@api.route('/delete_item_variable')
class StoreDelete(Resource):
    @api.response(201, 'Store Item Variable successfully deleted.')
    @api.doc('Delete a Store item Variable')
    @api.doc(security='api_key')
    @api.expect(_delete_store_item_variable, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Store item Variable"""
        data = request.json
        return delete_store_item_variable(data=data)

@api.route('/count')
class CountStores(Resource):
    @api.response(200, 'Store Item Count Successfully Fetched')
    @api.doc('Fetch Number of Items by store id')
    @api.doc(security='api_key')
    @api.expect(_fetch_store_item_by_store_id_count, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch number of store items by store id"""
        return get_item_count_by_id(request.json)

@api.route('/max_stock')
class ShowStores(Resource):
    @api.doc(security='api_key')
    @api.expect(_max_stock, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch Max Stock Value """
        data = request.json
        return get_max_stock(data=data)


@api.route('/status')
class StoreStatusUpdate(Resource):
    @api.response(201, 'Store Item Variable Status successfully updated.')
    @api.doc('Update a Store item Variable status')
    @api.doc(security='api_key')
    @api.expect(_update_store_item_status, validate=True)
    @super_admin_token_required
    def post(self):
        """Update a Store item Variable's Status"""
        data = request.json
        return update_store_item_status(data=data)