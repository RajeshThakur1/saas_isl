from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import QuantityUnitDto
from ....service.v1.quantity_unit_service import create_quantity_unit,update_quantity_unit, show_quantity_unit, delete_quantity_unit
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')

api = QuantityUnitDto.api
_add_quantity_unit = QuantityUnitDto.add_quantity_unit
_update_quantity_unit = QuantityUnitDto.update_quantity_unit
_delete_quantity_unit = QuantityUnitDto.delete_quantity_unit


@api.route('/create')
class QuantityUnitCreate(Resource):
    @api.response(201, 'Quantity Unit Created successfully')
    @api.doc('create a new Quantity Unit')
    @api.doc(security='api_key')
    @api.expect(_add_quantity_unit, validate=True)
    @super_admin_token_required
    def post(self):
        """Create a new Quantity Unit"""
        data = request.json
        return create_quantity_unit(data=data)


@api.route('/update')
class QuantityUnitUpdate(Resource):
    @api.response(202, 'Quantity Updated successfully')
    @api.doc('update a Quantity Unit')
    @api.doc(security='api_key')
    @api.expect(_update_quantity_unit, validate=True)
    @super_admin_token_required
    def post(self):
        """update a Quantity Unit """
        data = request.json
        return update_quantity_unit(data=data)


@api.route('/')
class ShowQuantityUnit(Resource):
    @api.response(201, 'All Quantity Unit Fetched successfully.')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Show all Quantity Unit """
        return show_quantity_unit()


@api.route('/delete')
class QuantityUnitDelete(Resource):
    @api.response(201, 'Quantity Deleted Successfully')
    @api.doc('delete a Quantity Unit')
    @api.doc(security='api_key')
    @api.expect(_delete_quantity_unit, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete a Quantity Unit"""
        data = request.json
        return delete_quantity_unit(data=data)
