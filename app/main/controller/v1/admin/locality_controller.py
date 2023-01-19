from app.main.util.v1.decorator import admin_superadmin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.admin_dto import LocalityDto
from ....service.v1.locality_service import create_locality,show_locality_with_cities_by_city_id,show_locality_with_cities, update_locality, delete_locality
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = LocalityDto.api
_create_locality = LocalityDto.create_locality
_update_locality = LocalityDto.update_locality
_delete_locality = LocalityDto.delete_locality
_city = LocalityDto.city


@api.route('/create')
class LocalityCreate(Resource):
    @api.response(201, 'Locality successfully created.')
    @api.doc('create a new Locality')
    @api.doc(security='api_key')
    @api.expect(_create_locality, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """Creates a new Locality """
        data = request.json
        return create_locality(data=data)


@api.route('/update')
class LocalityUpdate(Resource):
    @api.response(201, 'Locality successfully Updated.')
    @api.doc('update a Locality')
    @api.doc(security='api_key')
    @api.expect(_update_locality, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """updates a Locality """
        data = request.json
        return update_locality(data=data)

@api.route('/delete')
class LocalityDelete(Resource):
    @api.response(201, 'Locality successfully Deleted.')
    @api.doc('delete a Locality')
    @api.doc(security='api_key')
    @api.expect(_delete_locality, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """Delete a Locality """
        data = request.json
        return delete_locality(data=data)
    
@api.route('/')
class LocalityList(Resource):
    @api.doc(security='api_key')
    @admin_superadmin_token_required
    def get(self, **kwargs):
        """Show al Localities """
        data=show_locality_with_cities()
        return data
    
@api.route('/fetch/by_city_id')
class ShowMenuCategories(Resource):
    @api.response(201, 'All Localities by City ID Fetched successfully.')
    @api.doc('Fetch Locality by city Id')
    @api.doc(security='api_key')
    @api.expect(_city, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """Show al Localities by City ID """
        data = request.json
        return show_locality_with_cities_by_city_id(data=data)
