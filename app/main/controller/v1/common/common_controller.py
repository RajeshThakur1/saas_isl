from app.main.service.v1.city_service import get_city_names
from app.main.service.v1.order_service import get_hub_order_details_by_slug, get_order_details_by_slug
from app.main.util.v1.common_dto import CommonDto
from flask import request
from flask_restx import Resource

api = CommonDto.api 
_order_by_slug = CommonDto.order_by_slug
_hub_order_by_slug = CommonDto.hub_order_by_slug


@api.route('/city_names')
class CityName(Resource):
    """
    Get Names of all the servicable cities.
    """
    @api.response(200, "City Details Fetched")
    @api.doc('Show City Names')
    def get(self):
        return get_city_names()

@api.route('/order')
class CityName(Resource):
    """
    Get any order detail by it's slug.
    """
    @api.response(200, "Order Details Fetched")
    @api.doc('Get Order Details')
    @api.expect(_order_by_slug, validate = True)
    def post(self):
        return get_order_details_by_slug(request.json)
    
@api.route('/hub_order')
class CityName(Resource):
    """
    Get any hub order detail by its slug
    """
    @api.response(200, "City Details Fetched")
    @api.doc('Get Hub Order Details')
    @api.expect(_hub_order_by_slug, validate = True)
    def post(self):
        return get_hub_order_details_by_slug(request.json)




