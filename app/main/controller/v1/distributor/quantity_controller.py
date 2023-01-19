from flask_restx import Resource
from app.main.service.v1.quantity_unit_service import show_quantity_unit
from app.main.util.v1.decorator import distributor_token_required
from app.main.util.v1.distributor_dto import QuantityUnitDto

api = QuantityUnitDto.api


@api.route('/')
class ShowQuantityUnit(Resource):
    @api.response(201, 'All Quantity Unit Fetched successfully.')
    @api.doc(security='api_key')
    @distributor_token_required
    def get(self):
        """Show all Quantity Unit"""
        return show_quantity_unit()