from flask import request
from flask_restx import Resource
from flask import Blueprint
from app.main.service.v1.auth_helper import Auth
from app.main.service.v1.profile_service import create_super_admin
from app.main.util.v1.LastmileHelper import LastMileHelper 
from app.main.service.v1.otp_service import generateKey
from app.main.service.v1.notification_service import CreateNotification
from app.main.model.user import User
from app.main.model.merchant import Merchant
from app.main.model.supervisor import *
from app.main.service.v1.email import confirm_token
from app.main.util.v1.decorator import account_activation_required
from ....util.v1.dto import AuthDto
import datetime
from app.main import db
api = AuthDto.api
user_auth = AuthDto.user_auth
user_pass=AuthDto.user_pass
user_newpass=AuthDto.user_newpass
merchant_auth = AuthDto.merchant_auth
_create_sup = AuthDto.create_sup
from app.main.model.apiResponse import ApiResponse


@api.route('/login', methods=['POST', 'GET'])
class UserLogin(Resource):
    """
        User Login Resource
    """
    # @api.doc('user login')
    # # @api.expect(user_auth, validate=True)
    # @api.doc('merchant login')
    @api.expect(merchant_auth, validate=True)
    @account_activation_required
    def post(self):
        post_data = request.json        
        # if post_data.get('login_request') == "customer" or post_data.get('login_request') == "":
        #     return Auth.login_user(data=post_data)
        # print(post_data)
      
        if post_data.get('login_request') == "super_admin":
            return Auth.login_super_admin(data=post_data)
        
        elif post_data.get('login_request') == "merchant":
            return Auth.login_merchant(data=post_data)

        elif post_data.get('login_request') == "supervisor":
            return Auth.login_supervisor(data=post_data)      
        
        elif post_data.get('login_request') == "admin":
            return Auth.login_admin(data=post_data)
        
        elif post_data.get('login_request') == "distributor":
            return Auth.login_distributor(data=post_data)
        
        elif post_data.get('login_request') == "delivery_associate":
            return Auth.login_delivery_associate(data=post_data)

        else:
            error = ApiResponse(False, "Invalid Login Request", 'null', 'Please check the login request')
            return error.__dict__, 400
        
@api.route('/logout')
class LogoutAPI(Resource):
    """
    Logout Resource
    """
    @api.doc('logout a user')
    @api.doc(security='api_key')
    def post(self):
        # get auth token
        auth_header = request.headers.get('Authorization')
        return Auth.logout_user(data=auth_header)


@api.route('/forgot_password')
class ForgetPassowrdAPI(Resource):
    """
    ForgetPassword Resource
    """
    @api.doc('ForgetPassword')
    @api.expect(user_pass, validate=True)
    def post(self):
        # get auth token
        data=request.json
        return generateKey.create_otp(data)


@api.route('/forgot_password_verify')
class ConfirmationView(Resource):
    """ConfirmationView API For User"""
    
    @api.expect(user_newpass, validate=True)
    def post(self):
        data=request.json
        return generateKey.verify_otp(data)
        """Check confirmation token."""

@api.route('/testing_notification')
class ForgetPassowrdAPI(Resource):
    """
    ForgetPassword Resource
    """
    @api.doc('testing_notification')
    @api.expect(user_pass, validate=True)
    def post(self):
        # get auth token
        data={

        'user_email' : 'rajeshthakur1r@gmail.com',
        'user_name' :'rajesh',
        'template_name':'store_new_order',
        'type':'email',
        'order_id':"123"
        #'key1':'12345'
        }
        #return LastMileHelper.fun()
        return CreateNotification.gen_notification(data)

@api.route('/create_super_admin')
class CreateSuperAdmin(Resource):
    @api.doc('Create Super Admin')
    @api.expect(_create_sup, validate=True)
    def post(self):
        """Create Super Admin"""
        data = request.json
        return create_super_admin(data)


# @api.route('/forgetPassword/<token>')
# class ConfirmationView(Resource):
#     """ConfirmationView API For User"""
    
#     @api.expect(user_newpass, validate=True)
#     def post(self, token):
#         """Check confirmation token."""
#         try:
#             email = confirm_token(token)
#             print(email,"<<<<<=====")
#             post_data=request.json
#             print(post_data.get('userType'),"tisjkgf")
#             # user = User.query.filter_by(email=email).first()
#             if post_data.get('userType')=='User' and email:
#                 user = User.query.filter_by(email=email).first()
#             elif post_data.get('userType')=='Merchant' and email:
#                 user=Merchant.query.filter_by(email=email).first()
#             elif post_data.get('userType')=='Supervisor' and email:
#                 user=Supervisor.query.filter_by(email=email).first()
#             else:
#                 apiResponce = ApiResponse(False, 'User Does not Exist', None, None)
#                 return (apiResponce.__dict__), 400


#             if user and post_data.get('confirmpassword')==post_data.get('newpassword'):
#                 if user.active:
#                     user.update_to_db({"password": post_data.get('confirmpassword')})
#                     apiResponce = ApiResponse(True, 'Password Updte successful', None, None)
#                     return (apiResponce.__dict__), 201
#                     # return 'Account is already  confirmed.', 200
#                 # return 'Account confirmation was successful.', 200
            
#             apiResponce = ApiResponse(False, 'Not Confirmed', None, None)
#             return (apiResponce.__dict__), 400
        
#         except Exception as e:
#             error = ApiResponse(False, 'Internal Server Error', None, str(e))
#             return (error.__dict__), 400


