from app.main.util.v1.decorator import admin_superadmin_token_required, admin_token_required, super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.admin_dto import CityDto
from ....service.v1.city_service import create_city, show_city, update_city, delete_city
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = CityDto.api
_create_city = CityDto.create_city
_update_city = CityDto.update_city
_delete_city = CityDto.delete_city


@api.route('/create')
class CityCreate(Resource):
    @api.response(201, 'City Created successfully')
    @api.doc('create a new City')
    @api.doc(security='api_key')
    @api.expect(_create_city, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """Create a new City """
        data = request.json
        return create_city(data=data)


@api.route('/update')
class CityUpdate(Resource):
    @api.response(202, 'City Updated successfully')
    @api.doc('update a City')
    @api.doc(security='api_key')
    @api.expect(_update_city, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """update a City """
        data = request.json
        return update_city(data=data)


@api.route('/')
class ShowCities(Resource):
    @api.response(201, 'All Cities Fetched successfully.')
    @api.doc(security='api_key')
    @admin_superadmin_token_required
    def get(self):
        """Show all Cities """
        return show_city()


@api.route('/delete')
class CityDelete(Resource):
    @api.response(201, 'City Deleted Successfully')
    @api.doc('delete a City')
    @api.doc(security='api_key')
    @api.expect(_delete_city, validate=True)
    @admin_superadmin_token_required
    def post(self):
        """Delete a City """
        data = request.json
        return delete_city(data=data)