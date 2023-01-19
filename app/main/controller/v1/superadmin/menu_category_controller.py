from app.main.service.v1.image_service import image_save
from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import MenuCategoryDto
from ....service.v1.menu_category_service import create_menu_category, show_store_menu_category_by_category_ids, show_menu_category_by_category_id, update_menuCategory, show_menuCategory, delete_menuCategory, update_menuCategory_image
from flask import Blueprint
from app.main.config import menucategory_dir
main = Blueprint('main', __name__, template_folder='templates')

api = MenuCategoryDto.api
add_menu_category = MenuCategoryDto.add_menu_category
update_menu_category = MenuCategoryDto.update_menu_category
_update_menucategory_image = MenuCategoryDto.update_menucategory_image
_image_upload = MenuCategoryDto.image_upload
delete_menu_category = MenuCategoryDto.delete_menu_category
category_id = MenuCategoryDto.category_id
store_menu_category_id = MenuCategoryDto.store_menu_category_id


@api.route('/create')
class MenuCategoryCreate(Resource):
    @api.response(201, 'MenuCategory Created successfully')
    @api.doc('create a new MenuCategory')
    @api.doc(security='api_key')
    @api.expect(add_menu_category, validate=True)
    @super_admin_token_required
    def post(self):
        """Create a new MenuCategory """
        data = request.json
        return create_menu_category(data=data)


@api.route('/update')
class MenuCategoryUpdate(Resource):
    @api.response(202, 'MenuCategory Updated successfully')
    @api.doc('update a MenuCategory')
    @api.doc(security='api_key')
    @api.expect(update_menu_category, validate=True)
    @super_admin_token_required
    def post(self):
        """update a MenuCategory """
        data = request.json
        return update_menuCategory(data=data)

@api.route('/update_menucategory_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Menucategory Image Update')
    @api.doc(security='api_key')
    @api.expect(_update_menucategory_image, validate = True)
    @super_admin_token_required
    def post(self):
        """Menucategory Image Update"""
        data = _update_menucategory_image.parse_args()
        return update_menuCategory_image(data)

@api.route('/image_upload')
class StoreImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Image Save"""
        return image_save(request, menucategory_dir)
    
@api.route('/')
class ShowMenuCategories(Resource):
    @api.response(201, 'All MenuCategories Fetched successfully.')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Show all MenuCategories """
        data = show_menuCategory()
        return data


@api.route('/delete')
class MenuCategoryDelete(Resource):
    @api.response(201, 'MenuCategory Deleted Successfully')
    @api.doc('delete a MenuCategory')
    @api.doc(security='api_key')
    @api.expect(delete_menu_category, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a MenuCategory """
        data = request.json
        return delete_menuCategory(data=data)


@api.route('/fetch_by_category_id')
class ShowMenuCategories(Resource):
    @api.response(201,
                  'All MenuCategories by Category ID Fetched successfully.')
    @api.doc('Fetch MenuCategory by Category Id')
    @api.doc(security='api_key')
    @api.expect(category_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Show all MenuCategories by Category ID """
        data = request.json
        return show_menu_category_by_category_id(data=data)


@api.route('/fetch_store_menucategory_by_category_ids')
class ShowStoreMenuCategories(Resource):
    @api.response(
        201, 'All Store MenuCategories by Category ID Fetched successfully.')
    @api.doc('Fetch MenuCategory by Category Ids')
    @api.doc(security='api_key')
    @api.expect(store_menu_category_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Show all MenuCategories by Category ID """
        data = request.json
        return show_store_menu_category_by_category_ids(data=data)
