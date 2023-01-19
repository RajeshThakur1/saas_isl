from app.main.service.v1.image_service import profle_pic_image_save
from app.main.service.v1.order_service import get_user_logs, get_supervisor_user_logs
from app.main.service.v1.profile_service import change_password, update_profile
from app.main.service.v1.email import confirm_token
from app.main.model.supervisor import Supervisor
from app.main.service.v1.profile_service import get_profile
from app.main.util.v1.decorator import supervisor_token_required
from flask import request
from flask_restx import Resource
import datetime
from app.main.util.v1.supervisor_dto import SupervisorDto
from app.main.config import profile_pic_dir

api = SupervisorDto.api 
_change_password = SupervisorDto.change_password
_update_profile = SupervisorDto.update_profile
_image_upload = SupervisorDto.image_upload

@api.route('/get_profile')
class GetProfile(Resource):
    @api.doc('Get Profile',security='api_key')
    @supervisor_token_required
    def get(self):
        """Get Supervisor Profile """
        return get_profile()


@api.route('/<token>')
class ConfirmationView(Resource):
    """ConfirmationView API."""

    def get(self, token):
        """Check confirmation token."""
        email = confirm_token(token)
        user = Supervisor.query.filter_by(email=email).first()
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
    @supervisor_token_required
    def post(self):
        """Change Password"""
        data = request.json
        return change_password(data)

@api.route('/update_profile')
class UpdateProfile(Resource):
    @api.doc("Update Profile")
    @api.doc(security = "api_key")
    @api.expect(_update_profile, validate = True)
    @supervisor_token_required
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
    @supervisor_token_required
    def post(self):
        """Profile Pic Upload"""

        return profle_pic_image_save(request, profile_pic_dir)

@api.route('/search_user_logs')
class searchUserLogs(Resource):
    @api.response(201, 'user logs fetched successfully')
    @api.doc('this Api is used to fetched the User logs')
    @api.doc(security='api_key')
    @api.param(name='search_number', description='search string', required= True)
    @supervisor_token_required
    def get(self):
        """Supervisor City Map delete by ID"""
        data = request.args
        return get_supervisor_user_logs(data=data)