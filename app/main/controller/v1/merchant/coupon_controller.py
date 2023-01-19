from app.main.service.v1.image_service import image_save, image_upload
from app.main.util.v1.decorator import admin_merchant_superadmin_token_required, admin_token_required, merchant_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.merchant_dto import CouponDto
from ....service.v1.coupon_service import create_coupon_by_merchant, fetch_coupons, activate_coupon, deactivate_coupon
from flask import Blueprint
from app.main.config import coupon_banner1_dir, coupon_banner2_dir

main = Blueprint('main', __name__, template_folder='templates')
api = CouponDto.api
_create_coupon_merchant = CouponDto.add_coupon_merchant
_fetch_coupon = CouponDto.fetch_coupon
_coupon_id = CouponDto.coupon_id
_image_upload = CouponDto.image_upload

@api.route('/create')
class CouponCreate(Resource):
    @api.response(201, 'Coupon Created successfully')
    @api.doc('create a new Coupon by merchant')
    @api.doc(security='api_key')
    @api.expect(_create_coupon_merchant, validate=True)
    @merchant_token_required
    def post(self):
        """ Create a new Coupon
        
            optional fields----->
            
            user_mobile,previous_order_track,title,banner_1,banner_2,
            category_id,city_id,max_deduction,
            expired_at="YYYY-MM-DD"
            
            required Field----->
            
            level: [{  1,  "All" },{  2,  "Web" },{  3,  "Apps" }],
            target: [{  1,  "Product Price" },{  2,  "Delivery Fees" }],
            deduction_type: [{  1,  "Amount" },{  2,  "Percentage" }],
            is_display: [{  1,  "Display" },{  0,  "Hidden" }]
        """
        data = request.json
        return create_coupon_by_merchant(data=data)


@api.route('/')
class CouponFetch(Resource):
    @api.response(201, 'Coupon Fetched successfully')
    @api.doc('Fetch all new Coupon')
    @api.doc(security='api_key')
    @api.expect(_fetch_coupon, validate=True)
    @admin_merchant_superadmin_token_required
    def post(self):
        """ Fetch all Coupons 
        filter:----> null,Active,Deactive,Expired, User Specific,
        """
        data = request.json
        return fetch_coupons(data=data)


@api.route('/activate')
class CouponCreate(Resource):
    @api.response(201, 'Coupon Activated successfully')
    @api.doc('Activate a new Coupon')
    @api.doc(security='api_key')
    @api.expect(_coupon_id, validate=True)
    @admin_merchant_superadmin_token_required
    def post(self):
        """ Activate a Coupon"""
        data = request.json
        return activate_coupon(data=data)


@api.route('/de_activate')
class CouponCreate(Resource):
    @api.response(201, 'Coupon Deactivated successfully')
    @api.doc('Deactivated a new Coupon')
    @api.doc(security='api_key')
    @api.expect(_coupon_id, validate=True)
    @admin_merchant_superadmin_token_required
    def post(self):
        """ Deactivate a Coupon"""
        data = request.json
        return deactivate_coupon(data=data)

@api.route('/upload_banner_1')
class StoreImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @merchant_token_required
    def post(self):
        """Delete a Store item Variable"""

        return image_save(request, coupon_banner1_dir)

@api.route('/upload_banner_2')
class StoreImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Store item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @merchant_token_required
    def post(self):
        """Delete a Store item Variable"""

        return image_save(request, coupon_banner2_dir)