from app.main.service.v1.image_service import profle_pic_image_save
from app.main.service.v1.profile_service import change_password, update_profile, create_template
from app.main.service.v1.email import confirm_token
from app.main.model.superAdmin import SuperAdmin
from app.main.service.v1.profile_service import get_profile
from app.main.service.v1.store_bankdetails_service import create_store_bankdetails
from app.main.util.v1.decorator import super_admin_token_required, supervisor_token_required
from flask import request
from flask_restx import Resource
import datetime
from app.main.util.v1.superadmin_dto import SuperAdminDto
from app.main.config import profile_pic_dir

api = SuperAdminDto.api 
_change_password = SuperAdminDto.change_password
_update_profile = SuperAdminDto.update_profile
_image_upload = SuperAdminDto.image_upload
_create_template = SuperAdminDto.create_template

@api.route('/get_profile')
class GetProfile(Resource):
    @api.doc('Get Profile',security='api_key')
    @super_admin_token_required
    def get(self):
        """Get SuperAdmin Profile """
        return get_profile()


@api.route('/<token>')
class ConfirmationView(Resource):
    """ConfirmationView API."""

    def get(self, token):
        """Check confirmation token."""
        email = confirm_token(token)
        user = SuperAdmin.query.filter_by(email=email).first()
        if user:
            if user.active:
                return 'Account is already  confirmed.', 200
            user.active=True
            user.email_verified_at = datetime.datetime.utcnow()
            return 'Account confirmation was successful.', 200
        return 'Invalid confirmation token.', 406

@api.route('/change_password')
class ChangePassword(Resource):
    @api.doc("Change Password")
    @api.doc(security = "api_key")
    @api.expect(_change_password, validate = True)
    @super_admin_token_required
    def post(self):
        """Change Password"""
        data = request.json
        return change_password(data)

@api.route('/update_profile')
class UpdateProfile(Resource):
    @api.doc("Update Profile")
    @api.doc(security = "api_key")
    @api.expect(_update_profile, validate = True)
    @super_admin_token_required
    def post(self):
        """Update Profile"""
        data = request.json
        return update_profile(data)

@api.route('/update_profile_pic')
class ProfilePic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Profile Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Profile Pic Upload"""
        data = request.json
        return create_template(data)

@api.route('/create_template')
class createTemplate(Resource):
    @api.response(201, 'Template created successfully')
    #@api.response(413, 'Image Size is Too Large')
    @api.doc('create Template')
    @api.doc(security='api_key')
    @api.expect(_create_template)
    @super_admin_token_required
    def post(self):
        """create the template"""
        data = request.json
        return create_template(data)
    

@api.route('/checkfunction')
class CheckFunction(Resource):
    def get(self):
        return create_store_bankdetails()