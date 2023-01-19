from app.main.model import admin
from app.main.util.v1.decorator import admin_token_required, super_admin_token_required
from flask import request
from flask_restx import Resource

from ....service.v1.order_service import get_user_logs
from ....util.v1.superadmin_dto import StoreUserDto
from ....service.v1.user_service import create_user_by_super_admin,fetch_store_users,fetch_user_data_by_id
from ....service.v1.city_service import create_supervisor_city_map,fetch_supervisor_city_map,delete_supervisor_city_map
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = StoreUserDto.api
_add_user = StoreUserDto.add_user
_supervisor_City_map = StoreUserDto.supervisor_City_map
_supervisor_id = StoreUserDto.supervisor_id
_supervisor_city_map_id = StoreUserDto.userCities
_user_data = StoreUserDto.user_data
_get_users = StoreUserDto.get_users


@api.route('/createUser')
class StoreCreate(Resource):
    @api.response(201, 'Store User successfully created.')
    @api.doc('create a new User')
    @api.doc(security='api_key')
    @api.expect(_add_user, validate=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Store User API
        user_role----->
            supervisor
            admin
            distributor
        password----> password_phone_no
        optional fields-----> city_id
        """
        data = request.json
        return create_user_by_super_admin(data=data)
    
@api.route('/fetchAll')
class ShowUsers(Resource):
    @api.response(200, 'Store Users Fetched Successfully.')
    @api.doc('Fetch Store User Details')
    @api.doc(security='api_key')
    # @api.param(name='page', description='Page no.')
    # @api.param(name='items', description='Items per page')
    @api.expect(_get_users, validate=True)
    @super_admin_token_required
    def post(self):
        """Show all User Details """
        data = request.json
        return fetch_store_users(data)


@api.route('/fetch/byID')
class ShowUsers(Resource):
    @api.response(200, 'Store Users Data Fetched Successfully.')
    @api.doc('Fetch Store User Details by ID')
    @api.doc(security='api_key')
    @api.expect(_user_data, validate=True)
    @super_admin_token_required
    def post(self):
        """User Data fetch by ID"""
        data = request.json
        return fetch_user_data_by_id(data=data)
    
@api.route('/supervisor_city_map/fetch')
class StoreCreate(Resource):
    @api.response(201, 'Supervisor City Fetched successfully.')
    @api.doc('Fetch Supervisor City Map by supervisor ID')
    @api.doc(security='api_key')
    @api.expect(_supervisor_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Supervisor City Map Fetched"""
        data = request.json
        return fetch_supervisor_city_map(data=data)

@api.route('/supervisor_city_map/create')
class StoreCreate(Resource):
    @api.response(201, 'Supervisor City Mapped successfully created.')
    @api.doc('Supervisor City Map')
    @api.doc(security='api_key')
    @api.expect(_supervisor_City_map, validate=True)
    @super_admin_token_required
    def post(self):
        """Supervisor City Map"""
        data = request.json
        return create_supervisor_city_map(data=data)

@api.route('/supervisor_city_map/delete')
class StoreCreate(Resource):
    @api.response(201, 'Supervisor City Map deleted successfully.')
    @api.doc('Supervisor City Map deleted')
    @api.doc(security='api_key')
    @api.expect(_supervisor_city_map_id, validate=True)
    @super_admin_token_required
    def post(self):
        """Supervisor City Map delete by ID"""
        data = request.json
        return delete_supervisor_city_map(data=data)

@api.route('/search_user_logs')
class searchUserLogs(Resource):
    @api.response(201, 'user logs fetched successfully')
    @api.doc('this Api is used to fetched the User logs')
    @api.doc(security='api_key')
    @api.param(name='search_string', description='search string', required= True)
    @super_admin_token_required
    def get(self):
        """Supervisor City Map delete by ID"""
        data = request.args
        return get_user_logs(data=data)
