from sqlalchemy.sql.expression import desc
from app.main.util.v1.supervisor_dto import OrderDto
from flask import request
from flask_restx import Resource
from app.main.util.v1.decorator import supervisor_token_required
from app.main.service.v1.order_service import get_order_details_supervisor, get_orders_supervisor, supervisor_accept_order, supervisor_cancel_order, supervisor_reject_order

api = OrderDto.api
_order_details = OrderDto.order_details
_accept_order = OrderDto.accept_order
_reject_order = OrderDto.reject_order
_cancel_order = OrderDto.cancel_order


@api.route('/')
class GetOrders(Resource):
    @api.doc('Gets All orders fo the Supervisor')
    @api.doc(security="api_key")
    @api.response(200, 'Data Successfully Fetched')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='id', description='Search ID')
    @supervisor_token_required
    def get(self):
        """ Gets All orders fo the Supervisor
        item_per_page should be [5, 10, 25, 50, 100] """
        return get_orders_supervisor()

@api.route('/get_order_details')
class GetOrderDetails(Resource):
    @api.doc('Gets order details to the Supervisor by order id')
    @api.doc(security="api_key")
    @api.response(200, 'Data Successfully Fetched')
    @api.expect(_order_details, validate=True)
    @supervisor_token_required
    def post(self):
        return get_order_details_supervisor(request.json)

@api.route('/accept')
class AcceptOrder(Resource):
    @api.doc('Accept order by order id')
    @api.doc(security='api_key')
    @api.response(200, 'Order Accepted Successfully')
    @api.expect(_accept_order, validate=True)
    @supervisor_token_required
    def post(self):
        return supervisor_accept_order(request.json)


@api.route('/reject')
class RejectOrder(Resource):
    @api.doc('Reject order by order id')
    @api.doc(security='api_key')
    @api.response(200, 'Order rejected successfully')
    @api.expect(_reject_order, validate=True)
    @supervisor_token_required
    def post(self):
        return supervisor_reject_order(request.json)


@api.route('/cancel')
class CancelOrder(Resource):
    @api.doc('Cancel order by order id')
    @api.doc(security='api_key')
    @api.response(200, 'Order cancelled successfully')
    @api.expect(_cancel_order, validate=True)
    @supervisor_token_required
    def post(self):
        return supervisor_cancel_order(request.json)
