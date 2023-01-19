from app.main.service.v1.image_service import image_save, profle_pic_image_save
from app.main.util.v1.decorator import account_activation_required, token_required
from app.main.service.v1.profile_service import change_password
from flask import request
from flask_restx import Resource,reqparse
from app.main.service.v1.email import confirm_token, send_confirmation_email, send_email
from ....util.v1.user_dto import UserDto
from app.main.service.v1.fileupload_ import *
from ....service.v1.user_service import save_new_user, get_a_user,get_userby_email, update_name,update_profile,get_profile
from app.main.model.user import User
from flask import render_template, url_for,Blueprint,redirect
from app.main.util.v1.logs import log
from app.main import db
from app.main.service.v1.auth_helper import Auth
from flask import jsonify
import datetime
from werkzeug.datastructures import FileStorage
from app.main.model.apiResponse import ApiResponse
import werkzeug
from werkzeug.utils import secure_filename
from app.main.config import UPLOAD_FOLDER, profile_pic_dir
from app.main.service.v1.sms import verify_confirmation_otp


api = UserDto.api
_user = UserDto.user_create
user_profile=UserDto.user_profile
_user_auth =  UserDto.user_auth
_user_name = UserDto.user_name
_change_password = UserDto.change_password
_image_upload = UserDto.image_upload
_confirm_phone_otp = UserDto.confirm_phone_otp
_confirm_email_otp = UserDto.confirm_email_otp
# user_photo=UserDto.user_photo




@api.route('/')
class UserList(Resource):
    @api.response(201, 'User successfully created.')
    @api.doc('create a new user')
    @api.expect(_user, validate=True)
    def post(self):
        """sign up for User """
        data = request.json
        return save_new_user(data=data)

# @main.route('/profile/')
# def profile():
#     output_data={
#                 "key": "QFmWTn",
#                 "salt": "wED49yV7sC6Ik6gGQuqrpYmOASR9aTQp",
#                 "txnid": "ec5322f7-4978-40ec-bb57-7bf25288cdb5123",
#                 "amount": "1234",
#                 "productinfo": "data['productinfo']",
#                 "firstname": "data['firstname']",
#                 "email": "string",
#                 "surl": "https://paymentgateway.com",
#                 "furl": "https://paymentgateway.com",
#                 "action": 'https://sandboxsecure.payu.in/_payment',
#                 "hash_key": "94e1fe7a12f4cda563da1c559a8078b25f2e210c8db73f32076d97b019fbd456141920078c06446fb04d94e4ed8f0a6c7a847c3d66aca1f799092f65eb304e72"
#                 }

#     return render_template('current.html',output_data=output_data)

# @api.route('/update_profile')
# class UpdateProfile(Resource):
#     @api.response(201, 'Profile successfully updated.')
#     @api.doc('Update Profile',security='api_key')
#     @api.expect(user_profile, validate=True)
#     @token_required
#     def post(self):
#         """Update  User Profile """
#         data = request.json
#         return update_profile(data=data)

@api.route('/update_name')
class UpdateProfile(Resource):
    @api.response(201, 'User Name Successfully Updated')
    @api.doc('Update Profile Name',security='api_key')
    @api.expect(_user_name, validate=True)
    @token_required
    def post(self):
        """Update User Name"""
        data = request.json
        return update_name(data=data)


@api.route('/change_password')
class ChangePassword(Resource):
    @api.doc("Change Password")
    @api.doc(security = "api_key")
    @api.expect(_change_password, validate = True)
    @token_required
    def post(self):
        """Change Password"""
        data = request.json
        return change_password(data)

@api.route('/confirm_phone_otp')
class ConfirmPhoneOtp(Resource):
    @api.doc("Confirm phone otp")
    @api.doc(security = "api_key")
    @api.expect(_confirm_phone_otp, validate = True)
    
    def post(self):
        """Confirm phone otp"""
        data = request.json
        return verify_confirmation_otp(data=data, route=1)

@api.route('/confirm_email_otp')
class ConfirmPhoneOtp(Resource):
    @api.doc("Confirm email otp")
    @api.doc(security = "api_key")
    @api.expect(_confirm_email_otp, validate = True)
    
    def post(self):
        """Confirm email otp"""
        data = request.json
        return verify_confirmation_otp(data=data, route=0)

@api.route('/get_profile')
class GetProfile(Resource):
    @api.doc('Get Profile',security='api_key')
    @token_required 
    def get(self):
        """Get User Profile Details"""
        response, status =  get_profile()

        # if response['success'] == True:
        #     log_msg = log(response['message'])
        #     api.logger.info(log_msg)
        # elif response['success'] == False:
        #     log_msg = log(response['error'])
        #     api.logger.exception(log_msg)
        
        return response, status


# upload_parser = api.parser()
# upload_parser.add_argument('file', location='files',type=FileStorage,required=True)


@api.route('/<token>')
class ConfirmationView(Resource):
    """ConfirmationView API For User"""

    def get(self, token):
        """Check confirmation token."""
        try:
            email = confirm_token(token)
            user = User.query.filter_by(email=email).first()
            if user:
                if user.active:
                    apiResponce = ApiResponse(True, 'Successfully already confirm.', None, None)
                    return (apiResponce.__dict__), 201
                    # return 'Account is already  confirmed.', 200
                user.active=True
                user.email_verified_at = datetime.datetime.utcnow()
                db.session.add(user)
                db.session.commit()
                apiResponce = ApiResponse(True, 'Successfully confirm.', None, None)
                return (apiResponce.__dict__), 201
                # return 'Account confirmation was successful.', 200
            
            apiResponce = ApiResponse(False, 'Not Confirmed', None, None)
            return (apiResponce.__dict__), 400
        
        except Exception as e:
            error = ApiResponse(False, 'Internal Server Error', None, str(e))
            return (error.__dict__), 400


# @api.route('/file-upload')
# @api.expect(upload_parser)
# class ConfirmationView12(Resource):
#     def post(self):
#         # check if the post request has the file part
#         print(request.files,"<<<====")
#         if 'file' not in request.files:
#             resp = jsonify({'message' : 'No file part in the request'})
#             resp.status_code = 400
#             return resp
#         file = request.files['file']
#         if file.filename == '':
#             resp = jsonify({'message' : 'No file selected for uploading'})
#             resp.status_code = 400
#             return resp
#         if file:
#             filename = secure_filename(file.filename)
#             x=file.save(os.path.join(UPLOAD_FOLDER, filename))
#             y=os.path.join(UPLOAD_FOLDER, filename)
#             return upload_file_to_bucket(y, config.category_dir)

#         else:
#             resp = jsonify({'message' : 'Allowed file types are txt, pdf, png, jpg, jpeg, gif'})
#             resp.status_code = 400
#             return resp

@api.route('/auth')
class UserAuth(Resource):
    @api.response(200, 'User Logged in succesfully')
    @api.expect(_user_auth, validate=True)
    @account_activation_required
    def post(self):
        '''Login For Customer'''
        data = request.json
        return Auth.login_user(data)

@api.route('/update_profile_pic')
class ProfilePic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Profile Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @token_required
    def post(self):
        """Profile Pic Upload"""

        return profle_pic_image_save(request, profile_pic_dir)


