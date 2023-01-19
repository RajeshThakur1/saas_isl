from app.main.service.v1.order_service import merchant_place_order
from flask import request
from flask_restx import Resource

from ....util.v1.merchant_dto import CartDto
from ....service.v1.cart_service import *
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = CartDto.api
_addCart = CartDto.add_to_cart
_removeCart = CartDto.remove_cart
_get_from_cart=CartDto.get_from_cart
_delivery_fee = CartDto.delivery_fee
_globalSearch = CartDto.globelSearch
_storeId = CartDto.storeId
_removeItem = CartDto.remove_item
_update_item_count = CartDto.update_item_count
_place_order = CartDto.place_order
_cart_count = CartDto.cart_count

#_remove_item_completely = CartDto.remove_item_completely
@api.route('/search_store_item')
class GlobalSearch(Resource):
    @api.doc(security='api_key')
    @api.expect(_globalSearch, validate=True)
    @merchant_token_required
    def post(self):
        """Merchant--> Add item to Cart Data"""
        data = request.json
        return globelSearch_func(data=data)

@api.route('/merchant_add_to_cart')
class AddToCart(Resource):
    @api.response(200, 'Cart Data Added Successfully')
    @api.doc('Add item to Cart API')
    @api.expect(_addCart, validate=True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Merchant--> Add item to Cart Data"""
        data = request.json
        return merchat_add_to_cart(data=data)

@api.route('/')
class FetchCartData(Resource):
    @api.response(201, 'User Cart Data Fetched')
    @api.response(500, 'User Data Can not be fetched')
    @api.doc('Show Store Cart Data')
    @api.doc(security='api_key')
    @api.expect(_storeId, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self, **kwargs):
        """Show Store Cart Data"""
        data = request.json
        return fetch_merchant_cart(data)

@api.route('/stores')
class StoreList(Resource):
    @api.doc(security='api_key')
    #@api.param(name='page', description='Page no.')
    #@api.param(name='item_per_page', description='Item Per Page')
    @merchant_token_required
    def get(self, **kwargs):
        """Show all Stores"""
        return show_all_store()


# @api.route('/')
# class FetchCartData(Resource):
#     @api.response(201, 'User Cart Data Fetched')
#     @api.response(500, 'User Data Can not be fetched')
#     @api.doc('Show all Cart Data')
#     @api.doc(security='api_key')
#     #@api.doc(params={'city': 'City Name'})
#     @merchant_token_required
#     def get(self, **kwargs):
#         """Merchant--> Show all Cart Data """
#         data=fetch_merchant_cart()
#         return data

        # data=fetch_merchant_cart()
        # return data

# @api.route('/')
# class FetchCartData(Resource):
#     @api.response(201, 'User Cart Data Fetched')
#     @api.response(500, 'User Data Can not be fetched')
#     @api.doc('Show all Cart Data')
#     @api.doc(security='api_key')
#     #@api.doc(params={'city': 'City Name'})
#     @merchant_token_required
#     def get(self, **kwargs):
#         """Merchant--> Show all Cart Data """
#         data=fetch_merchant_cart()
#         return data
# >>>>>>> 2d50574d98b0f461de721cc6896cf65fac8e7e30

@api.route('/remove_cart')
class RemoveCart(Resource):
    @api.response(200, 'Cart Removed Successfully')
    @api.doc('Remove Cart API')
    @api.doc(security='api_key')
    @api.expect(_removeCart, validate=True)
    @merchant_token_required
    def post(self):
        """Merchant--> Remove Cart Data"""
        data = request.json
        return remove_cart(data=data)

@api.route('/cart_count')
class CartCount(Resource):
    @api.response(200, 'Success')
    @api.doc('Cart Count Api')
    @api.doc(security='api_key')
    #@api.doc(params={'city': 'City Name'})
    @api.expect(_cart_count, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Merchant--> cart count"""
        data = request.json
        return cart_count_merchant(data)


@api.route('/cartbyId')
class CartbyId(Resource):
    @api.response(200, 'Cart Data get Successfully')
    @api.doc('Get  Cart by id  API')
    @api.doc(security='api_key')
    @api.expect(_get_from_cart, validate=True)
    @merchant_token_required
    def post(self):
        """Merchant --> cart get by id"""
        data = request.json
        # print(data['id'],"ndkhdkwehdw")
        return getcartByid(data=data)


@api.route('/calculate_delivery_fee')
class CalculateDeliveryFee(Resource):
    @api.response(200, 'Delivery Fee Added')
    @api.response(200, 'Delivery Fee Updated')
    @api.doc('Calculate Delivery Fee')
    @api.doc(security='api_key')
    @api.expect(_delivery_fee, validate=True)
    @merchant_token_required
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
    @merchant_token_required
    def post(self):
        """Calculate Delivery Fee"""
        data = request.json
        return get_order_calculated(data=data)


@api.route('/update_item_count')
class UpdateItemCount(Resource):
    @api.doc('Update item count from Cart API')
    @api.doc(security='api_key')
    @api.expect(_update_item_count, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Update Item Count -> Method = '+' / '-' """
        data = request.json
        return update_item_from_cart_merchant(data=data)

@api.route('/remove_items')
class Removefrom_Cart(Resource):
    @api.response(200, 'Cart Data remove Successfully')
    @api.doc('Remove item from Cart API')
    @api.doc(security='api_key')
    @api.expect(_removeItem, validate=True)
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """Merchant--> cart remove"""
        data = request.json
        return remove_specific_item_completely_merchant(data=data)

@api.route('/place_order')
class placeOrder(Resource):
    @api.response(201, 'Order place successfully')
    @api.response(500, 'Order can not placed')
    @api.doc('place the order')
    @api.doc(security='api_key')
    @api.expect(_place_order, validate=True)
    @merchant_token_required
    #@api.marshal_list_with(_order, envelope='data')
    def post(self):
        """place the order"""
        data = request.json
        return merchant_place_order(data)