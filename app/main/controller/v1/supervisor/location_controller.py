from app.main.service.v1.locality_service import get_supervisor_city_localities, supervisor_update_localities
from flask.globals import request
from app.main.service.v1.city_service import get_supervisor_city
from app.main.util.v1.decorator import supervisor_token_required
from flask_restx import Resource
from app.main.util.v1.supervisor_dto import LocationDto



api = LocationDto.api  
_get_localities = LocationDto.get_locality_details
_update_localities = LocationDto.update_localities

@api.route('/city/getlist')
class GetCityList(Resource):
    @api.doc("Get City List")
    @api.doc(security="api_key")
    @api.response(200, 'Supervisor Cities Fetched')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='pagination', description="1 for pagination 0 if not" )
    @supervisor_token_required
    def get(self):
        """Get City List"""

        return get_supervisor_city()

@api.route('/getlocalityBy_CityId')
class GetCityLocalites(Resource):
    @api.doc("Get Locality List")
    @api.doc(security="api_key")
    @api.expect(_get_localities, validate=True)
    @api.response(200, 'Supervisor Localities Fetched')
    @supervisor_token_required
    def post(self):
        """Get Locality List"""
        data = request.json
        return get_supervisor_city_localities(data)

@api.route('/updateLocalities')
class GetCityLocalites(Resource):
    @api.doc("Update Locality Parameters")
    @api.doc(security="api_key")
    @api.expect(_update_localities, validate=True)
    @api.response(200, 'Parameter Updated Successfully')
    @supervisor_token_required
    def post(self):
        """Update Locality Parameters"""
        data = request.json
        return supervisor_update_localities(data)



