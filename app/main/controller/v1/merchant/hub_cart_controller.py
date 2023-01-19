from flask_restx import Resource
from flask import request
from app.main.service.v1.hub_cart_service import add_to_wishlist, create_hub_cart, fetch_store_hub_carts, get_hub_cart, hubs_by_store_id, move_to_cart, place_store_hub_order, remove_all_item_from_wishlist, remove_hub_cart, remove_item_from_wishlist, reset_hub_cart, update_item_quantity, wishlist_by_store
from app.main.util.v1.decorator import check_merchant_access, merchant_token_required
from app.main.util.v1.merchant_dto import HubCartDto



api = HubCartDto.api


@api.route('/item/')
class GetHubCartByStore(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.temp_cart, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return wishlist_by_store(data=request.json)

@api.route('/item/add')
class AddToHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.add_items, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return add_to_wishlist(data=request.json)

@api.route('/item/update_quantity')
class UpdateItemQuantity(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.update_item_quantity, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return update_item_quantity(data=request.json)


@api.route('/item/remove')
class RemoveItemFromHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.remove_item, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return remove_item_from_wishlist(data=request.json)

@api.route('/item/remove_all')
class RemoveAllItemFromHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.remove_all_item, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return remove_all_item_from_wishlist(data=request.json)
@api.route('/hubs')
class HubByStoreId(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.fetch_hubs, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return hubs_by_store_id(data=request.json)


@api.route('/create') 
class SelectHub(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.select_hub, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return create_hub_cart(data=request.json)

@api.route('/remove_hub_cart')
class RemoveHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.remove_hub_cart, validate=True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return remove_hub_cart(data=request.json)

@api.route('/hub_cart/by_id')
class GetHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.clear_hub_cart, validate=True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return get_hub_cart(data=request.json)

@api.route('/reset_hub_cart')
class ResetHubCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.clear_hub_cart, validate=True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return reset_hub_cart(data=request.json)

@api.route('/move_to_cart')
class MovetoCart(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.move_to_cart, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return move_to_cart(data=request.json)


@api.route('/')
class FetchMerchantStoreCarts(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.hub_cart, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    @check_merchant_access
    def post(self):
        return fetch_store_hub_carts(data=request.json)

@api.route('/place_store_hub_order')
class PlaceStoreHubOrder(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubCartDto.place_order, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return place_store_hub_order(data=request.json)