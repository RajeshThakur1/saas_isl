from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.userOtp import *
from app.main.model.user import User
import base64
import datetime
import pyotp
from app.main import db
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.service.v1.email import send_email
from flask import render_template
from app.main.model.admin import Admin
from app.main.model.merchant import Merchant
from app.main.model.supervisor import Supervisor
from app.main.config import SERVICE_LOGGING_DIR

import os
import logging

from app.main.util.v1.database import save_db

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/otp_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def save_changes(data):
    db.session.add(data)
    db.session.commit()

def show_all_otp_types():

		try:
			types = OTPType.query.filter_by(deleted_at=None).all()

			response_data = []
			for type in types:

				response_data.append({
					'id': type.id,
					'type': type.type,
					'created_at': type.created_at
				})

			if not len(response_data) > 0:
				response = ApiResponse(True, 'No OTP Types created', response_data, None)

				return response.__dict__, 200

			response = ApiResponse(True, 'OTP Types fetched successfully', response_data, None)

			return response.__dict__, 200

		except Exception as e:
			error = ApiResponse(False, 'Something went wrong!', None, str(e))
			return error.__dict__, 500


def add_otp_type(data):
	try:
		type_name = data['type_name']

		type = OTPType(
			type = type_name,
			created_at = datetime.datetime.utcnow(),
			updated_at = datetime.datetime.utcnow()
		)

		try:
			save_changes(type)

			response = ApiResponse(True, 'Otp Type Added Succesfully!', None, None)

			return response.__dict__, 200

		except Exception as e:

			response = ApiResponse(False, 'Something went wrong!', None, str(e))

			return response.__dict__, 500


	except Exception as e:
		return ApiResponse(False, 'Something went wrong!', None, str(e)).__dict__, 500


def remove_otp_type(data):
	try:
		type_id =  data['type_id']
		type = OTPType.query.filter_by(id=type_id).filter_by(deleted_at=None).first()

		type.deleted_at = None

		save_db(type)

		response = ApiResponse(True, 'Otp Type Removed!', None, None)

		return response.__dict__, 200
	
	except Exception as e:
		error = ApiResponse(False, 'Something went wrong!', None, str(e))

		return error.__dict__, 500

def get_otp_routes():
	try:
		routes = OTPRoute.query.filter_by(deleted_at=None).all()

		response_data = []
		for route in routes:

			response_data.append({
				'id': route.id,
				'route': route.route,
				'created_at': route.created_at
			})

		if not len(response_data) > 0:
			response = ApiResponse(True, 'No OTP Routes created', response_data, None)

			return response.__dict__, 200

		response = ApiResponse(True, 'OTP Routes fetched successfully', response_data, None)

		return response.__dict__, 200

	except Exception as e:
		error = ApiResponse(False, 'Something went wrong!', None, str(e))
		return error.__dict__, 500


def add_otp_route(data):
	try:
		route_name = data['route_name']

		route = OTPRoute(
			route = route_name,
			created_at = datetime.datetime.utcnow(),
			updated_at = datetime.datetime.utcnow()
		)

		try:
			save_changes(route)

			response = ApiResponse(True, 'Otp Route Added Succesfully!', None, None)

			return response.__dict__, 200

		except Exception as e:

			response = ApiResponse(False, 'Something went wrong!', None, str(e))

			return response.__dict__, 500


	except Exception as e:
		return ApiResponse(False, 'Something went wrong!', None, str(e)).__dict__, 500


def remove_otp_route(data):
	try:
		route_id =  data['route_id']
		route = OTPRoute.query.filter_by(id=route_id).filter_by(deleted_at=None).first()

		route.deleted_at = None

		save_db(route)

		response = ApiResponse(True, 'Otp Route Removed!', None, None)

		return response.__dict__, 200
	
	except Exception as e:
		error = ApiResponse(False, 'Something went wrong!', None, str(e))

		return error.__dict__, 500

class generateKey:


	@staticmethod
	def returnValue(email):
	    return (str(email) + str(datetime.datetime.utcnow()).split()[0] + "Some Random Secret Key")

	
	

			

@staticmethod	
def create_otp(data):
	try:
		
		logging.info("Recieved generate otp request")
		if data['login_request']=='customer':
			logging.info("User role: " + data['login_request'])
			user_obj=User.query.filter_by(email=data['user_email']).first()
			email_otp=UserOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = UserOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)

				
		elif data['login_request']=='merchant':
			logging.info("User role: " + data['login_request'])
			user_obj=Merchant.query.filter_by(email=data['user_email']).first()
			email_otp=MerchantOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = MerchantOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)
		elif data['login_request']=='supervisor':
			logging.info("User role: " + data['login_request'])
			user_obj=Supervisor.query.filter_by(email=data['user_email']).first()
			email_otp=SupervisorOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = SupervisorOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)
		elif data['login_request']=='admin':
			logging.info("User role: " + data['login_request'])
			user_obj=Admin.query.filter_by(email=data['user_email']).first()
			email_otp=AdminOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = AdminOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)

		elif data['login_request']=='distributor':
			logging.info("User role: " + data['login_request'])
			user_obj=Distributor.query.filter_by(email=data['user_email']).first()
			email_otp=DistributorOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = DistributorOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)
		
		elif data['login_request']=='delivery_associate':
			logging.info("User role: " + data['login_request'])
			user_obj=DeliveryAssociate.query.filter_by(email=data['user_email']).first()
			email_otp=DeliveryAssociateOtp.query.filter_by(otp=user_obj.id).first()
			if email_otp==None:
				email_otp = DeliveryAssociateOtp(isVerified=0,counter=0,otp=user_obj.id)
				save_changes(email_otp)

		else:
			logging.info("User role: invalid")
			error = ApiResponse(False, 'Wrong Login request')
			return (error.__dict__), 500
		
		logging.info("Otp generation completed;")


		email_otp.counter += 1
		save_changes(email_otp)  # Save the data
		keygen = generateKey()
		logging.info("Otp key generation completed;")
		key = base64.b32encode(keygen.returnValue(data['user_email']).encode())  # Key is generated
		OTP = pyotp.HOTP(key)
		print(OTP,"this is the key")
		logging.info(f"this is the key: {OTP}")
		html = render_template('otp.html', otp=OTP.at(email_otp.counter))
		if send_email(data['user_email'], 'Forget Password ', html):
			logging.info("Email sent successfully")
		response_object = {
		'status': True,
		'message': 'Email Send',
		'data': None,
		'error': None
		}
		return response_object, 200
	except Exception as e:
		error = ApiResponse(False, 'Error Occurred', None,
							str(e))
		return (error.__dict__), 500




@staticmethod
def verify_otp(data):
	try:
		if data['login_request']=='customer':
			user_obj=User.query.filter_by(email=data['user_email']).first()
			otp_user=UserOtp.query.filter_by(otp=user_obj.id).first()
		elif data['login_request']=='merchant':
			user_obj=Merchant.query.filter_by(email=data['user_email']).first()
			otp_user=MerchantOtp.query.filter_by(otp=user_obj.id).first()
		elif data['login_request']=='supervisor':
			user_obj=Supervisor.query.filter_by(email=data['user_email']).first()
			otp_user=SupervisorOtp.query.filter_by(otp=user_obj.id).first()
		elif data['login_request']=='admin':
			user_obj=Admin.query.filter_by(email=data['user_email']).first()
			otp_user=AdminOtp.query.filter_by(otp=user_obj.id).first()
		elif data['login_request']=='admin':
			user_obj=Admin.query.filter_by(email=data['user_email']).first()
			otp_user=AdminOtp.query.filter_by(otp=user_obj.id).first()
		elif data['login_request']=='distributor':
			user_obj=Distributor.query.filter_by(email=data['user_email']).first()
			otp_user=DistributorOtp.query.filter_by(otp=user_obj.id).first()
		else:
			error = ApiResponse(False, 'Wrong Login request')
			return (error.__dict__), 500

		keygen = generateKey()
		key = base64.b32encode(keygen.returnValue(data['user_email']).encode())  # Generating Key
		OTP = pyotp.HOTP(key)  # HOTP Model
		if OTP.verify(data['otp'], otp_user.counter) and data['newpassword'] == data['confirmpassword'] :  # Verifying the OTP
			otp_user.isVerified = True
			save_changes(otp_user)
			user_obj.update_to_db({"password": data['confirmpassword']})
			apiResponce = ApiResponse(True, 'Password Updte successful', None, None)
			return (apiResponce.__dict__), 201
		apiResponce = ApiResponse(False, 'Password Updte not successful', None, None)
		return (apiResponce.__dict__), 400


	except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

