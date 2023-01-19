from app.main.util.v1.decorator import token_required
from flask import request
from flask_restx import Resource
from ....util.v1.user_dto import CouponDto
from ....service.v1.coupon_service import cart_coupon_removal, fetch_coupons_by_city_id, fetch_user_coupons, get_coupon_discount
from flask import Blueprint

main = Blueprint('main', __name__, template_folder='templates')
api = CouponDto.api
_fetch_coupon = CouponDto.city_specific
_get_discount = CouponDto.discount_specific
_coupon_removal = CouponDto.coupon_removal

@api.route('/current_offers')
class CouponFetch(Resource):
    @api.response(201, 'Coupon Fetched successfully')
    @api.doc('Fetch all new Coupon')
    @api.expect(_fetch_coupon, validate=True)
    def post(self):
        """ Fetch all City Specific Coupons and global coupons
            if city will pass as a null then all the global coupon will get fetched
        """
        data = request.json
        return fetch_coupons_by_city_id(data=data)
    
@api.route('/my_coupons')
class CouponFetch(Resource):
    @api.response(201, 'Coupon Fetched successfully')
    @api.doc('Fetch all User Coupon')
    @api.doc(security='api_key')
    @token_required
    def get(self):
        """ Fetch all City Specific Coupons 
        """
        return fetch_user_coupons()

@api.route('/get_discount')
class GetDiscount(Resource):
    @api.response(201, 'Discount Calculated successfully')
    @api.doc('discount calculated')
    @api.doc(security='api_key')
    @api.expect(_get_discount, validate=True)
    @token_required
    def post(self):
        """ Fetch all City Specific Coupons
        """
        data = request.json
        return get_coupon_discount(data)

@api.route('/remove_coupon')
class GetDiscount(Resource):
    @api.response(201, 'Coupon Removed')
    @api.doc('Coupon Removal')
    @api.doc(security='api_key')
    @api.expect(_coupon_removal, validate=True)
    @token_required
    def post(self):
        """ Fetch all City Specific Coupons
        """
        data = request.json
        return cart_coupon_removal(data)
