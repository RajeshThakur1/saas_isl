from flask import request
from flask_restx import Resource
from ....util.v1.user_dto import CartDto
# from ....service.cart_service import add_to_cart,fetch_user_cart,remove_from_cart
from ....service.v1.cart_service import *
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')

api = CartDto.api
_addCart = CartDto.add_to_cart
_removeCart = CartDto.remove_cart
_removeItem = CartDto.remove_item
_get_from_cart=CartDto.get_from_cart
_delivery_fee = CartDto.delivery_fee

@api.route('/add_to_cart')
class AddToCart(Resource):
    @api.response(200, 'Cart Data Added Successfully')
    @api.doc('Add item to Cart API')
    @api.expect(_addCart, validate=True)
    @api.doc(security='api_key')
    @token_required
    def post(self):
        """Customer--> Add item to Cart Data"""
        data = request.json
        return add_to_cart(data=data)
    
@api.route('/')
class FetchCartData(Resource):
    @api.response(201, 'User Cart Data Fetched')
    @api.response(500, 'User Data Can not be fetched')
    @api.doc('Show all Cart Data')
    @api.doc(security='api_key')
    @api.doc(params={'city': 'City Name'})
    @token_required
    def get(self, **kwargs):
        """Customer--> Show all Cart Data """
        data=fetch_user_cart_new()
        return data

@api.route('/remove_cart')
class RemoveCart(Resource):
    @api.response(200, 'Cart Removed Successfully')
    @api.doc('Remove Cart API')
    @api.doc(security='api_key')
    @api.expect(_removeCart, validate=True)
    @token_required
    def post(self):
        """Customer--> Remove Cart Data"""
        data = request.json
        return remove_cart(data=data)


@api.route('/cart_count')
class CartCount(Resource):
    @api.response(200, 'Success')
    @api.doc('Cart Count Api')
    @api.doc(security='api_key')
    @api.doc(params={'city': 'City Name'})
    @token_required
    def get(self,**kwargs):
        """Customer--> cart count"""
        return cart_count()

@api.route('/cartbyId')
class CartbyId(Resource):
    @api.response(200, 'Cart Data get Successfully')
    @api.doc('Get  Cart by id  API')
    @api.doc(security='api_key')
    @api.expect(_get_from_cart, validate=True)
    @token_required
    def post(self):
        """Customer--> cart get by id"""
        data = request.json
        # print(data['id'],"ndkhdkwehdw")
        return getcartByid(data=data)


@api.route('/remove_items')
class Removefrom_Cart(Resource):
    @api.response(200, 'Cart Data remove Successfully')
    @api.doc('Remove item from Cart API')
    @api.doc(security='api_key')
    @api.expect(_removeItem, validate=True)
    @token_required
    def post(self):
        """Customer--> cart remove"""
        data = request.json
        return remove_from_cart(data=data)

@api.route('/calculate_delivery_fee')
class CalculateDeliveryFee(Resource):
    @api.response(200, 'Delivery Fee Added')
    @api.response(200, 'Delivery Fee Updated')
    @api.doc('Calculate Delivery Fee')
    @api.doc(security='api_key')
    @api.expect(_delivery_fee, validate=True)
    @token_required
    def post(self):
        """Calculate Delivery Fee"""
        data = request.json
        return get_delivery_price(data=data)

@api.route('/calculate_order')
class CalculateOrder(Resource):
    @api.response(200, '')
    @api.doc('Calculate Order')
    @api.doc(security='api_key')
    @api.expect(_get_from_cart, validate=True)
    @token_required
    def post(self):
        """Calculate Delivery Fee"""
        data = request.json
        return get_order_calculated(data=data)
