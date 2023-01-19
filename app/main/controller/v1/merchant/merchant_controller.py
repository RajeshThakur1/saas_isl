from app.main.service.v1.image_service import profle_pic_image_save
from app.main.service.v1.profile_service import change_password, update_profile, update_profile_email
from app.main.util.v1.decorator import merchant_token_required
from flask import request
from flask_restx import Resource
from app.main.service.v1.email import confirm_token, send_confirmation_email, send_email
from ....util.v1.merchant_dto import MerchantDto
from ....service.v1.merchant_service import save_new_merchant 
from app.main.service.v1.user_service import get_profile, update_name
from app.main.model.merchant import Merchant
from flask import render_template, url_for,Blueprint,redirect
from app.main import db
from app.main.service.v1.auth_helper import Auth
import datetime
from app.main.config import profile_pic_dir


main = Blueprint('main', __name__, template_folder='templates')
api = MerchantDto.api
_merchant = MerchantDto.merchant_create
merchant_profile=MerchantDto.merchant_profile
_change_password = MerchantDto.change_password
_update_profile = MerchantDto.update_profile
_update_name = MerchantDto.update_name
_image_upload = MerchantDto.image_upload


@api.route('/')
class MerchantList(Resource):
    @api.response(201, 'Merchant successfully created.')
    @api.doc('create a new merchant')
    @api.expect(_merchant, validate=True)
    def post(self):
        """sign up  """
        data = request.json
        return save_new_merchant(data=data)

@api.route('/get_profile')
class GetProfile(Resource):
    # @api.marshal_list_with(_merchant, envelope='data')
    @api.doc('Get Profile',security='api_key')
    @merchant_token_required
    def get(self):
        """Get Merchant_Profile """
        return  get_profile()

@api.route('/change_password')
class ChangePassword(Resource):
    @api.doc("Change Password")
    @api.doc(security = "api_key")
    @api.expect(_change_password, validate = True)
    @merchant_token_required
    def post(self):
        """Change Password"""
        data = request.json
        return change_password(data)

@api.route('/update_email')
class UpdateProfile(Resource):
    @api.doc("Update Profile Email")
    @api.doc(security = "api_key")
    @api.expect(_update_profile, validate = True)
    @merchant_token_required
    def post(self):
        """Update Profile"""
        data = request.json
        return update_profile_email(data,verified=False)

@api.route('/update_name')
class UpdateName(Resource):
    @api.doc("Update Name")
    @api.doc(security = "api_key")
    @api.expect(_update_name, validate = True)
    @merchant_token_required
    def post(self):
        """Update Name"""
        data = request.json
        return update_name(data)

@api.route('/<token>')
class ConfirmationView(Resource):
    """ConfirmationView API."""

    def get(self, token):
        """Check confirmation token."""
        email = confirm_token(token)
        merchant = Merchant.query.filter_by(email=email).first()
        if merchant:
            if merchant.active:
                return 'Account is already  confirmed.', 200
            merchant.active=True
            merchant.email_verified_at = datetime.datetime.utcnow()
            return 'Account confirmation was successful.', 200
        return 'Invalid confirmation token.', 406

@api.route('/update_profile_pic')
class ProfilePic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Profile Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @merchant_token_required
    def post(self):
        """Profile Pic Upload"""

        return profle_pic_image_save(request, profile_pic_dir)