from app.main.util.v1.decorator import admin_merchant_superadmin_token_required, super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import OrderDto,StoreDto
from ....service.v1.order_service import get_orders_by_id_admin, show_all_order_admin, cancel_order_admin
from app.main import db


api = OrderDto.api 
_order_details = OrderDto.order_details_admin
_cancel_order = OrderDto.cancel_order_admin



@api.route('/')
class ShowOrders(Resource):
    @api.doc(" Get all orders ")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='id', description='Search ID')
    @super_admin_token_required
    def get(self):
        """Show all Orders
           item_per_page should be [5, 10, 25, 50, 100]"""
        return show_all_order_admin()


@api.route('/order_details')
class OrderDetails(Resource):
    @api.doc("Show details of a particular order")
    @api.doc(security='api_key')
    @api.expect(_order_details, validate = True)
    @super_admin_token_required
    def post(self): 
        """Show details of a particular order"""
        data = request.json
        return get_orders_by_id_admin(data)


@api.route('/cancel_order')
class CancelOrder(Resource):
    @api.doc("Cancel a particular order")
    @api.doc(security='api_key')
    @api.expect(_cancel_order, validate = True)
    @super_admin_token_required
    def post(self):
        """Cancel a particular order"""
        data = request.json
        return cancel_order_admin(data)