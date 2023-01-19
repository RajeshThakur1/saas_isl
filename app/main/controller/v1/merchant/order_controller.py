from app.main.util.v1.decorator import admin_merchant_superadmin_token_required, check_merchant_access, merchant_token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.merchant_dto import OrderDto
from app.main.service.v1.order_service import delivered_order_merchant, get_orders_merchant, merchant_order_ready_to_pack, merchant_update_order, \
    get_order_details_merchant, reject_order_merchant, merchant_accept_order, cancel_order_merchant, \
    merchant_place_order, pick_up_order_merchant

api = OrderDto.api 
_order_details = OrderDto.order_details
_reject_order = OrderDto.reject_order
_cancel_order = OrderDto.cancel_order
_update_order = OrderDto.update_order
_accept_order = OrderDto.accept_order
_ready_to_pack = OrderDto.ready_to_pack
# _set_agent = OrderDto.set_agent
# _place_order = OrderDto.place_order
_picked_up_order = OrderDto.picked_up_order
_deliver_order = OrderDto.deliver_order


@api.route('/')
class ShowOrders(Resource):
    @api.doc(" Get all orders ")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='item_per_page')
    @api.param(name='id', description='Search ID')
    @merchant_token_required
    def get(self):
        """Show all Orders
        item_per_page should be [5, 10, 25, 50, 100]"""
        return get_orders_merchant()


@api.route('/update_order')
class UpdateOrder(Resource):
    @api.doc("Update Order Details")
    @api.doc(security='api_key')
    @api.expect(_update_order, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        "Edit items in a Order"
        return merchant_update_order(request)


@api.route('/order_details')
class OrderDetails(Resource):
    @api.doc("Show details of a particular order")
    @api.doc(security='api_key')
    @api.expect(_order_details, validate = True)
    @merchant_token_required
    @check_merchant_access
    def post(self): 
        """Show details of a particular order"""
        data = request.json
        return get_order_details_merchant(data)



@api.route('/reject_order')
class RejectOrder(Resource):
    @api.doc("Reject a particular order")
    @api.doc(security='api_key')
    @api.expect(_reject_order, validate = True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Reject a particular order"""
        data = request.json
        return reject_order_merchant(data)



@api.route('/cancel_order')
class CancelOrder(Resource):
    @api.doc("Cancel a particular order")
    @api.doc(security='api_key')
    @api.expect(_cancel_order, validate = True)
    @admin_merchant_superadmin_token_required
    @check_merchant_access
    def post(self):
        """Cancel a particular order"""
        data = request.json
        return cancel_order_merchant(data)



@api.route('/accept_order')
class AcceptOrder(Resource):
    @api.doc("""Accept and order by order id""")
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized Access')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @api.expect(_accept_order, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Accept and order by order id"""
        return merchant_accept_order(request)

@api.route('/ready_to_pack')
class ReadyToPackOrder(Resource):
    @api.doc("""Change Order Status to Ready to Pack""")
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized Access')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @api.expect(_ready_to_pack, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Change Order Status to Ready to Pack"""
        return merchant_order_ready_to_pack(request)

#Remove
# @api.route('/place_order')
# class placeOrder(Resource):
#     @api.response(201, 'Order place successfully')
#     @api.response(500, 'Order can not placed')
#     @api.doc('place the order')
#     @api.doc(security='api_key')
#     @api.expect(_place_order, validate=True)
#     @merchant_token_required
#     #@api.marshal_list_with(_order, envelope='data')
#     def post(self):
#         """place the order"""
#         data = request.json
#         return merchant_place_order(data)

@api.route('/pick_up')
class ReadyToPackOrder(Resource):
    @api.doc("""Change Order Status to Picked Up""")
    @api.doc(security='api_key')
    @api.expect(_picked_up_order, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Change Order Status to Picked Up"""
        data = request.json
        return pick_up_order_merchant(data)

@api.route('/delivered')
class ReadyToPackOrder(Resource):
    @api.doc("""Change Order Status to Delivered""")
    @api.doc(security='api_key')
    @api.expect(_deliver_order, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Change Order Status to Delivered"""
        data = request.json
        return delivered_order_merchant(data)
