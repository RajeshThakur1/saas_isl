from flask.globals import request
from flask_restx import Resource
import datetime
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.service.v1.email import confirm_token
from app.main.service.v1.image_service import profle_pic_image_save
from app.main.service.v1.profile_service import change_password, get_profile, update_name
from app.main.util.v1.decorator import delivery_associate_token_required
from app.main.util.v1.delivery_associate_dto import DeliveryAssociateDto
from app.main.config import profile_pic_dir


api = DeliveryAssociateDto.api
_change_password = DeliveryAssociateDto.change_password
_update_name = DeliveryAssociateDto.update_name
_image_upload = DeliveryAssociateDto.image_upload


@api.route('/get_profile')
class GetProfile(Resource):
    """
    Get Delivery Associate Profile
    """
    @api.doc('Get Profile',security='api_key')
    @delivery_associate_token_required
    def get(self):
        return  get_profile()

@api.route('/change_password')
class ChangePassword(Resource):
    """
    Change delivery associate account password
    """
    @api.doc("Change Password")
    @api.doc(security = "api_key")
    @api.expect(_change_password, validate = True)
    @delivery_associate_token_required
    def post(self):
        data = request.json
        return change_password(data)

# @api.route('/update_profile')
# class UpdateProfile(Resource):
#     @api.doc("Update Profile")
#     @api.doc(security = "api_key")
#     @api.expect(_update_profile, validate = True)
#     @delivery_associate_token_required
#     def post(self):
#         """Update Profile"""
#         data = request.json
#         return update_profile(data)

@api.route('/update_name')
class UpdateName(Resource):
    """
    Update Name of the Delivery Associate
    """
    @api.doc("Update Name")
    @api.doc(security = "api_key")
    @api.expect(_update_name, validate = True)
    @delivery_associate_token_required
    def post(self):
        
        data = request.json
        return update_name(data)

# @api.route('/update_email')
# class UpdateEmail(Resource):
#     @api.doc("Update email")
#     @api.doc(security = "api_key")
#     @api.expect(_update_email, validate = True)
#     @delivery_associate_token_required
#     def post(self):
#         """Update email"""
#         data = request.json
#         return update_email(data)

@api.route('/<token>')
class ConfirmationView(Resource):
    """
    ConfirmationView API.
    """

    def get(self, token):
        """Check confirmation token."""
        email = confirm_token(token)
        da = DeliveryAssociate.query.filter_by(email=email).first()
        if da:
            if da.active:
                return 'Account is already  confirmed.', 200
            da.active=True
            da.email_verified_at = datetime.datetime.utcnow()
            return 'Account confirmation was successful.', 200
        return 'Invalid confirmation token.', 406

@api.route('/update_profile_pic')
class ProfilePic(Resource):
    """Profile Pic Upload"""
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Profile Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @delivery_associate_token_required
    def post(self):
        """Profile Pic Upload"""

        return profle_pic_image_save(request, profile_pic_dir)