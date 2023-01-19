from app.main.service.v1.image_service import image_save
from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import CategoryDto
from ....service.v1.category_service import category_status_change, remove_category_to_city,create_category, add_category_to_city, GetCategoryByCity, show_non_selected_category, show_all__category, update_category, delete_category, show_category, update_category_image
from flask import Blueprint
from app.main.config import category_dir

main = Blueprint('main', __name__, template_folder='templates')
api = CategoryDto.api
_add_category = CategoryDto.add_category
_update_category_name = CategoryDto.update_category_name
_update_category_image = CategoryDto.update_category_image
_delete_category = CategoryDto.delete_category
add_city_cat=CategoryDto.add_city_cat
_get_category_city = CategoryDto.get_category_city
_get_not_category_city = CategoryDto.get_not_category_city
_image_upload = CategoryDto.image_upload
_status_change = CategoryDto.category_status_change


@api.route('/Create')
class CategoryCreate(Resource):
    @api.response(201, 'Category successfully Added.')
    @api.doc('Add a Category')
    @api.doc(security='api_key')
    @api.expect(_add_category, validate=True)
    @super_admin_token_required
    def post(self):
        """Add a Category """
        data = request.json
        return create_category(data=data)


@api.route('/update')
class CategoryUpdate(Resource):
    @api.response(202, 'Category Updated successfully')
    @api.doc('Update Category Name')
    @api.doc(security='api_key')
    @api.expect(_update_category_name, validate=True)
    @super_admin_token_required
    def post(self):
        """Update Category Name"""
        data = request.json
        return update_category(data=data)

@api.route('/update_category_image')
class UpdatedCategoryPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Category Image Update')
    @api.doc(security='api_key')
    @api.expect(_update_category_image)
    @super_admin_token_required
    def post(self):
        """Category Pic Update"""
        data = _update_category_image.parse_args()
        return update_category_image(data)

@api.route('/')
class ShowCategories(Resource):
    @api.response(201, 'Categories Fetched successfully.')
    @api.doc('Show Categories')
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='items', description='Items per page')    
    @super_admin_token_required
    def get(self):
        """Show Categories 
        items_per_page should be [5, 10, 25, 50, 100]"""
        data=request.args
        return show_category(data)



@api.route('/all')
class ShowAllCategories(Resource):
    @api.response(201, 'All Categories Fetched successfully.')
    @api.doc('Show all Categories')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Show all Categories"""
        data=request.args
        return show_all__category(data)


@api.route('/delete')
class CategoryDelete(Resource):
    @api.response(201, 'Category Deleted Successfully')
    @api.doc('delete a Category')
    @api.doc(security='api_key')
    @api.expect(_delete_category, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Category """
        data = request.json
        return delete_category(data=data)


@api.route('/add_city_cat')
class addCat_to_city(Resource):
    @api.response(201, 'Category added to city.')
    @api.doc('add category to  a City')
    @api.doc(security='api_key')
    @api.expect(add_city_cat)
    @super_admin_token_required
    def post(self):
        """Add Category to  a City """
        data = request.json
        return add_category_to_city(data=data)

@api.route('/remove_city_cat')
class addCat_to_city(Resource):
    @api.response(201, 'Category remove to city.')
    @api.doc('remove category from  a City')
    @api.expect(add_city_cat)
    @api.doc(security="api_key")
    @super_admin_token_required
    def post(self):
        """Remove Category from  a City """
        data = request.json
        return remove_category_to_city(data=data)

@api.route('/get_category_by_city')
class GetCategory(Resource):
    @api.response(201, 'Get Category By City.')
    @api.doc('Get Category By City ')
    @api.expect(_get_category_city, validate=True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """ Get Category By City id"""
        data=request.json
        return GetCategoryByCity(data)

@api.route('/get_not_selected_category_by_city')
class GetCategory(Resource):
    @api.response(201, 'Get Not Selected Category By City.')
    @api.doc('Get Category By City ')
    @api.expect(_get_not_category_city, validate=True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Get Not Selected Category By City"""
        data=request.json
        return show_non_selected_category(data)


@api.route('/image_upload')
class StoreImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Image Upload"""
        return image_save(request, category_dir)

@api.route('/status_change')
class StatusChange(Resource):
    @api.doc(security = 'api_key')
    @api.expect(_status_change, validate=True)
    @super_admin_token_required
    def post(self):
        """Category Status Change"""
        data = request.json
        return category_status_change(data)