from flask.globals import request
from flask_restx import Resource
import datetime
from app.main.model.distributor import Distributor
from app.main.service.v1.email import confirm_token
from app.main.service.v1.image_service import profle_pic_image_save
from app.main.service.v1.profile_service import change_password, get_profile, update_name
from app.main.util.v1.decorator import distributor_token_required
from app.main.util.v1.distributor_dto import DistributorDto
from app.main.config import profile_pic_dir


api = DistributorDto.api
_change_password = DistributorDto.change_password
_update_name = DistributorDto.update_name
_image_upload = DistributorDto.image_upload


@api.route('/get_profile')
class GetProfile(Resource):
    @api.doc('Get Profile',security='api_key')
    @distributor_token_required
    def get(self):
        """Get Distributor Profile """
        return  get_profile()

@api.route('/change_password')
class ChangePassword(Resource):
    @api.doc("Change Password")
    @api.doc(security = "api_key")
    @api.expect(_change_password, validate = True)
    @distributor_token_required
    def post(self):
        """Change Password"""
        data = request.json
        return change_password(data)

# @api.route('/update_profile')
# class UpdateProfile(Resource):
#     @api.doc("Update Profile")
#     @api.doc(security = "api_key")
#     @api.expect(_update_profile, validate = True)
#     @distributor_token_required
#     def post(self):
#         """Update Profile"""
#         data = request.json
#         return update_profile(data)

@api.route('/update_name')
class UpdateName(Resource):
    @api.doc("Update Name")
    @api.doc(security = "api_key")
    @api.expect(_update_name, validate = True)
    @distributor_token_required
    def post(self):
        """Update Name"""
        data = request.json
        return update_name(data)

# @api.route('/update_email')
# class UpdateEmail(Resource):
#     @api.doc("Update email")
#     @api.doc(security = "api_key")
#     @api.expect(_update_email, validate = True)
#     @distributor_token_required
#     def post(self):
#         """Update email"""
#         data = request.json
#         return update_email(data)

@api.route('/<token>')
class ConfirmationView(Resource):
    """ConfirmationView API."""

    def get(self, token):
        """Check confirmation token."""
        email = confirm_token(token)
        distributor = Distributor.query.filter_by(email=email).first()
        if distributor:
            if distributor.active:
                return 'Account is already  confirmed.', 200
            distributor.active=True
            distributor.email_verified_at = datetime.datetime.utcnow()
            return 'Account confirmation was successful.', 200
        return 'Invalid confirmation token.', 406

@api.route('/update_profile_pic')
class ProfilePic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Profile Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @distributor_token_required
    def post(self):
        """Profile Pic Upload"""

        return profle_pic_image_save(request, profile_pic_dir)