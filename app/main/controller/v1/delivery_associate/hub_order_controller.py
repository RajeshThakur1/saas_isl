from flask import request
from flask_restx import Resource
from app.main.service.v1.order_service import delivery_associate_deliverd_order, delivery_associate_pick_up_order, get_order_details_distributor, get_orders_distributor
from app.main.service.v1.hub_order_payment_service import add_hub_order_payment, delete_hub_order_payment, get_hub_order_payment, update_hub_order_payment
from app.main.util.v1.decorator import delivery_associate_token_required
from app.main.util.v1.delivery_associate_dto import HubOrderDto


api = HubOrderDto.api 

@api.route('/')
class ShowOrders(Resource):
    """
    Show all hub orders associated with the DA
    """
    @api.doc(" Get all hub orders ")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='item_per_page')
    @api.param(name='id', description='Search ID')
    @delivery_associate_token_required
    def get(self):
        """Show all Orders
        item_per_page should be [5, 10, 25, 50, 100]"""
        return get_orders_distributor()

@api.route('/order_details')
class OrderDetails(Resource):
    """
    Show details of a particular hub order associated with the DA
    """
    @api.doc("Show details of a particular order")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto._order_details, validate = True)
    @delivery_associate_token_required
    def post(self): 
        """Show details of a particular order"""
        data = request.json
        return get_order_details_distributor(data)

@api.route('/pick_up')
class ReadyToPackOrder(Resource):
    """
    Pick up an assigned order associated with the DA
    """
    @api.doc("""Change Order Status to Picked Up""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto._picked_up_order, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Change Order Status to Picked Up"""
        data = request.json
        return delivery_associate_pick_up_order(data)

@api.route('/delivered')
class ReadyToPackOrder(Resource):
    """
    Deliver an assigned order associated with the DA
    """
    @api.doc("""Change Order Status to Delivered""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto._deliver_order, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Change Order Status to Delivered"""
        data = request.json
        return delivery_associate_deliverd_order(data)
    
@api.route('/payment/add')
class AddOrderPayment(Resource):
    @api.doc("""Add Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto.add_payment, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Add Order Payment Details"""
        data = request.json
        return add_hub_order_payment(data)

@api.route('/payment/')
class GetOrderPayment(Resource):
    @api.doc("""Get Payment Details""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto.get_payment, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Get Payment Details"""
        data = request.json
        return get_hub_order_payment(data)

@api.route('/payment/update')
class UpdateOrderPayment(Resource):
    @api.doc("""Update Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto.update_payment, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Update Order Payment Details"""
        data = request.json
        return update_hub_order_payment(data)

@api.route('/payment/delete')
class DeleteOrderPayment(Resource):
    @api.doc("""Delete Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(HubOrderDto.delete_payment, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Delete Order Payment Details"""
        data = request.json
        return delete_hub_order_payment(data)