from app.main.util.v1.decorator import token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.user_dto import OrderDto,StoreDto
from app.main.service.v1.order_service import cancel_order_customer, check_order_payu, find_order, place_order, get_orders_pagination, get_orders_by_id, place_order_payu


api = OrderDto.api
_order=OrderDto.order_details
_find_store_by_location_category=StoreDto.find_store_by_location_category
_place_order = OrderDto.place_order
_place_order_payu = OrderDto.place_order_payu
_check_order_payu = OrderDto.check_order_payu
_get_order_by_id=OrderDto.get_order_by_id
_cancel_order = OrderDto.cancel_order_cust

# _get_discount_list= OrderDto.get_discount_list
# _orders_list=OrderDto.get_orders_list
# _get_order=OrderDto.get_orders

@api.route('/get_latest_orders_store_by_coordinate')
class GetLatestOrdersByStoreCoordinate(Resource):
    @api.response(201, 'Orders Found')
    @api.marshal_list_with(_order, envelope='data')
    @api.expect(_find_store_by_location_category, validate=True)
    def post(self):
        """Find a Order Letest by Lat Log And Max Dist  """
        data = request.json
        return find_order(data=data)

@api.route('/get_orders')
class getOrders(Resource):
    @api.response(201, 'user Orders Fetched')
    @api.response(500, 'user Orders can not be fetched')
    @api.doc('Show all order details')
    @api.doc(security='api_key')
    @api.param(name = 'page',  description="Page no.",required=False)
    @api.param(name='search_string', description= 'search string', required=False)
    @token_required
    def get(self,**kwargs):
        """Show all order details """
        data = request.args
        return get_orders_pagination(data)

@api.route('/get_orders_by_id')
class getOrdersById(Resource):
    @api.response(201, 'user Orders Fetched by cart Id')
    @api.response(500, 'user Orders can not be fetched')
    @api.doc('Show all order details by Id')
    @api.expect(_get_order_by_id, validate=True)
    @api.doc(security='api_key')
    @token_required
    def post(self):
        """Show all order details by Id"""
        data = request.json
        return get_orders_by_id(data)

@api.route('/place_order')
class placeOrder(Resource):
    @api.response(201, 'Order place successfully')
    @api.response(500, 'Order can not placed')
    @api.doc('place the order')
    @api.doc(security='api_key')
    @api.expect(_place_order, validate=True)
    @token_required
    #@api.marshal_list_with(_order, envelope='data')
    def post(self):
        """place the order"""
        data = request.json
        return place_order(data)

@api.route('/place_order_payu')
class placeOrderPayU(Resource):
    @api.doc('Place the order PayU')
    @api.doc(security='api_key')
    @api.expect(_place_order_payu, validate=True)
    @token_required
    def post(self):
        """Place the order PayU"""
        data = request.json
        return place_order_payu(data)
    
@api.route('/check_order_payu')
class checkOrderPayU(Resource):
    @api.doc('Check the order PayU')
    @api.doc(security='api_key')
    @api.expect(_check_order_payu, validate=True)
    @token_required
    def post(self):
        """Check the order PayU"""
        data = request.json
        return check_order_payu(data)

@api.route('/cancel_order')
class CancelOrder(Resource):
    @api.doc('Cancel Order by ID')
    @api.expect(_cancel_order, validate=True)
    @api.doc(security='api_key')
    @token_required
    def post(self):
        """Cancel Order by ID"""
        data = request.json
        return cancel_order_customer(data)


# @api.route('/get_discount')
# class getDiscount(Resource):
#     @api.response(201, 'get discount')
#     @api.marshal_list_with(_order, envelope='data')
#     @api.expect(_get_discount_list, validate=True)
#     def post(self):
#         """Find a Order Letest by Lat Log And Max Dist  """
#         data = request.json
#         return get_discount(data=data)


# @api.route('/GetLatestOrderdStoreByCoordinate')
# class StoreCreate(Resource):
#     @api.response(201, 'Store successfully created.')
#     @api.doc('create a new Store')
#     @api.expect(find_store, validate=True)
#     @api.marshal_list_with(_order, envelope='data')
#     def post(self):
#         """Creates a new Store """
#         data = request.json
#         return create_store(data=data)


# @api.route('/')
# class OrderList(Resource):
#     # @api.response(201, 'All Orders Fetched')
#     # @api.response(500, 'Orders can not be fetched')
#     # @api.doc('Show all order details')
#     @api.doc(security='api_key')
#     def get(self, **kwargs):
#         """Find all Orders  """
#         return show_all_order()

# @api.route('/GetLatestOrderdStoreByCoordinate')
# class StoreCreate(Resource):
#     @api.response(201, 'Store successfully created.')
#     @api.doc('create a new Store')
#     @api.expect(_order, validate=True)
#     def post(self):
#         """Creates a new Store """
#         data = request.json
#         return create_store(data=data)

