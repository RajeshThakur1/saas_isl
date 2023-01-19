from app.main.service.v1.order_service import get_order_details_distributor, get_orders_distributor
from app.main.service.v1.hub_order_payment_service import get_hub_order_payment
from app.main.util.v1.decorator import supervisor_token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.supervisor_dto import HubOrderDto


api = HubOrderDto.api 
_order_details = HubOrderDto.order_details
_get_payment = HubOrderDto.get_payment


@api.route('/')
class ShowOrders(Resource):
    @api.doc(" Get all orders ")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='item_per_page')
    @api.param(name='id', description='Search ID')
    @supervisor_token_required
    def get(self):
        """Show all Orders
        item_per_page should be [5, 10, 25, 50, 100]"""
        return get_orders_distributor()

@api.route('/order_details')
class OrderDetails(Resource):
    @api.doc("Show details of a particular order")
    @api.doc(security='api_key')
    @api.expect(_order_details, validate = True)
    @supervisor_token_required
    def post(self): 
        """Show details of a particular order"""
        data = request.json
        return get_order_details_distributor(data)

@api.route('/payment/')
class GetOrderPayment(Resource):
    @api.doc("""Get Payment Details""")
    @api.doc(security='api_key')
    @api.expect(_get_payment, validate=True)
    @supervisor_token_required
    def post(self):
        """Get Payment Details"""
        data = request.json
        return get_hub_order_payment(data)


