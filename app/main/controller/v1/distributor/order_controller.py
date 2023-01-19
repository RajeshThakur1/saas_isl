from sqlalchemy.sql.expression import desc
from app.main.service.v1.order_service import distributor_accept_order, distributor_cancel_order,distributor_order_assigin_to_da, distributor_price_update_order, distributor_quantity_update_order, distributor_reject_order, get_order_details_distributor, get_orders_distributor
from app.main.service.v1.hub_order_payment_service import add_hub_order_payment, delete_hub_order_payment, get_hub_order_payment, update_hub_order_payment
from app.main.util.v1.decorator import distributor_token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.distributor_dto import HubOrderDto


api = HubOrderDto.api 
_order_details = HubOrderDto.order_details
_reject_order = HubOrderDto.reject_order
_cancel_order = HubOrderDto.cancel_order
_update_order_quantity = HubOrderDto.update_order_quantity
_update_order_price = HubOrderDto.update_order_price
_accept_order = HubOrderDto.accept_order
_assign_to_da = HubOrderDto.assign_to_da
# _picked_up_order = HubOrderDto.picked_up_order
# _deliver_order = HubOrderDto.deliver_order
_add_payment = HubOrderDto.add_payment
_update_payment = HubOrderDto.update_payment
_get_payment = HubOrderDto.get_payment
_delete_payment = HubOrderDto.delete_payment

@api.route('/')
class ShowOrders(Resource):
    @api.doc(" Get all orders ")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='item_per_page')
    @api.param(name='id', description='Search ID')
    @distributor_token_required
    def get(self):
        """Show all Orders
        item_per_page should be [5, 10, 25, 50, 100]"""
        return get_orders_distributor()


@api.route('/update_order_quantity')
class UpdateOrder(Resource):
    @api.doc("Update Order Quantity Details")
    @api.doc(security='api_key')
    @api.expect(_update_order_quantity, validate=True)
    @distributor_token_required
    def post(self):
        "Edit items in a Order"
        return distributor_quantity_update_order(request)

@api.route('/update_order_price')
class UpdateOrder(Resource):
    @api.doc("Update Order price Details")
    @api.doc(security='api_key')
    @api.expect(_update_order_price, validate=True)
    @distributor_token_required
    def post(self):
        "Edit items in a Order"
        return distributor_price_update_order(request)

@api.route('/order_details')
class OrderDetails(Resource):
    @api.doc("Show details of a particular order")
    @api.doc(security='api_key')
    @api.expect(_order_details, validate = True)
    @distributor_token_required
    def post(self): 
        """Show details of a particular order"""
        data = request.json
        return get_order_details_distributor(data)



@api.route('/reject_order')
class RejectOrder(Resource):
    @api.doc("Reject a particular order")
    @api.doc(security='api_key')
    @api.expect(_reject_order, validate = True)
    @distributor_token_required
    def post(self):
        """Reject a particular order"""
        data = request.json
        return distributor_reject_order(data)



@api.route('/cancel_order')
class CancelOrder(Resource):
    @api.doc("Cancel a particular order")
    @api.doc(security='api_key')
    @api.expect(_cancel_order, validate = True)
    @distributor_token_required
    def post(self):
        """Cancel a particular order"""
        data = request.json
        return distributor_cancel_order(data)



@api.route('/accept_order')
class AcceptOrder(Resource):
    @api.doc("""Accept and order by order id""")
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized Access')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @api.expect(_accept_order, validate=True)
    @distributor_token_required
    def post(self):
        """Accept and order by order id"""
        return distributor_accept_order(request)

@api.route('/assign_to_da')
class AssignedToDA(Resource):
    @api.doc("""Change Order Status to Assigned to DA""")
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized Access')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @api.expect(_assign_to_da, validate=True)
    @distributor_token_required
    def post(self):
        """Change Order Status to Assigned to DA"""
        return distributor_order_assigin_to_da(request)

# @api.route('/pick_up')
# class ReadyToPackOrder(Resource):
#     @api.doc("""Change Order Status to Picked Up""")
#     @api.doc(security='api_key')
#     @api.expect(_picked_up_order, validate=True)
#     @distributor_token_required
#     def post(self):
#         """Change Order Status to Picked Up"""
#         data = request.json
#         return delivery_associate_pick_up_order(data)

# @api.route('/delivered')
# class ReadyToPackOrder(Resource):
#     @api.doc("""Change Order Status to Delivered""")
#     @api.doc(security='api_key')
#     @api.expect(_deliver_order, validate=True)
#     @distributor_token_required
#     def post(self):
#         """Change Order Status to Delivered"""
#         data = request.json
#         return delivery_associate_deliverd_order(data)

@api.route('/payment/add')
class AddOrderPayment(Resource):
    @api.doc("""Add Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(_add_payment, validate=True)
    @distributor_token_required
    def post(self):
        """Add Order Payment Details"""
        data = request.json
        return add_hub_order_payment(data)

@api.route('/payment/')
class GetOrderPayment(Resource):
    @api.doc("""Get Payment Details""")
    @api.doc(security='api_key')
    @api.expect(_get_payment, validate=True)
    @distributor_token_required
    def post(self):
        """Get Payment Details"""
        data = request.json
        return get_hub_order_payment(data)

@api.route('/payment/update')
class UpdateOrderPayment(Resource):
    @api.doc("""Update Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(_update_payment, validate=True)
    @distributor_token_required
    def post(self):
        """Update Order Payment Details"""
        data = request.json
        return update_hub_order_payment(data)

@api.route('/payment/delete')
class DeleteOrderPayment(Resource):
    @api.doc("""Delete Order Payment Details""")
    @api.doc(security='api_key')
    @api.expect(_delete_payment, validate=True)
    @distributor_token_required
    def post(self):
        """Delete Order Payment Details"""
        data = request.json
        return delete_hub_order_payment(data)