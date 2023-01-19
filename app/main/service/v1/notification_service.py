import json
from app.main.model import notification
from app.main.model.userOtp import *
from app.main.model.user import User
#import pyotp
import base64
import datetime
from app.main import db
from app.main.service.v1.auth_helper import Auth
from app.main.model.apiResponse import ApiResponse
from app.main.service.v1.email import send_email
from flask import render_template
from app.main.model.admin import Admin
from app.main.model.notification import Notification,NotificationTemplates
from app.main.model.merchant import Merchant
from app.main.model.supervisor import Supervisor
import uuid
from app.main.service.v1.fast2sms import Fast2SMS
from app.main.service.v1 import mailgun
import flask


app = flask.Flask('app.main')


import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/notification_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")


def save_changes(data):
    db.session.add(data)
    db.session.commit()


def generate_data(service, **kwargs):
	response_data ={}
	for key, value in kwargs.items():
		response_data[key] = value

	templates_obj=NotificationTemplates.query.filter(NotificationTemplates.name.in_([service,service+"_sms"])).all()

	response_data['templates_obj'] = templates_obj

		

	return response_data


	
class CreateNotification:

	def gen_notification(data):
		try:
			
			user_obj=User.query.filter_by(email=data['user_email']).first()
			templates_obj=NotificationTemplates.query.filter_by(name=data['template_name']).first()
			send_to=user_obj.email
			uuid1=str(uuid.uuid4()) + str(templates_obj.t_type) + str(templates_obj.name)
			notification_data={
			'user_id': user_obj.id,
			'uid': uuid1,
			'status':0,
			'target': user_obj.email,
			'text': templates_obj.template,
			'not_type':data['type'],
			'created_at':datetime.datetime.utcnow(),
			'updated_at':datetime.datetime.utcnow()
			}

			mystr=str(templates_obj.template)
			for k in data.keys():
				x='[['+ k +']]'
				newstr='' + mystr.replace(x ,data[k])
				mystr=newstr
			if data['type']== 'email':
				x=CreateNotification.send_mail_noti(send_to,mystr)
				if x[1]==200:
					status=1
				else:
					status=0
				# print(**notification_data,"<<==")
				newins=Notification(
						user_id= user_obj.id,
						uid= uuid1,
						status=status,
						target= user_obj.email,
						text= templates_obj.template,
						not_type=data['type'],
						created_at=datetime.datetime.utcnow(),
						updated_at=datetime.datetime.utcnow()
					)
				if status==0:
					newins.message=str(x[0])
				try:
					db.session.add(newins)
					db.session.commit()
				except Exception as e:
					db.session.rollback()
					apiResponce = ApiResponse(
						False, 'Error Occurd while sending the Notification',
						'null', f"Database {str('Notification')} : {str(e)}")
					return (apiResponce.__dict__), 500

				response_object = {
				'status': True,
				'message': 'Notification Create',
				'data': None,
				'error': None
				}
				return response_object, 200

		except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

	
	def gen_notification_message(data,template_type=['email', 'phone']):
		try:
			templates_obj=NotificationTemplates.query.filter_by(name=data['template_name']).filter(NotificationTemplates.t_type.in_(template_type)).all()
			
			if len(templates_obj) >= 1:

				i=0
				for template_obj in templates_obj:

					uuid1=str(uuid.uuid4()) + str(template_obj.t_type) + str(template_obj.name)
		
					mystr=str(template_obj.template)
					for k in data.keys():
						x='[['+ k +']]'
						newstr='' + mystr.replace(x ,data[k])
						mystr=newstr

					templates_obj[i].template = mystr
					i+=1
				
			return 200, templates_obj[0].template, templates_obj[1].template
		except Exception as e:
			return 500, str(e), None


	def gen_notification_v2(user_objs, data, service=None, template_type=['email', 'sms']):
		try:
			# user_obj=User.query.filter_by(email=data['user_email']).first()
			with app.app_context():
				templates_obj=data['templates_obj']

				for user_obj in user_objs:
					if len(templates_obj) >= 1:

					
						send_to_email=user_obj.email
						
						send_to_phone=user_obj.phone
					
						
						i=0
						for template_obj in templates_obj:

							uuid1=str(uuid.uuid4()) + str(template_obj.t_type) + str(template_obj.name)
				
							mystr=str(template_obj.template)
							for k in data.keys():

								if not k == 'templates_obj':
									x='[['+ k +']]'
									newstr='' + mystr.replace(x ,data[k])
									mystr=newstr

							templates_obj[i].template = mystr
							i+=1

							if template_obj.t_type in template_type and 'email' in template_type:
								x=CreateNotification.send_mail_noti_v2(send_to_email,user_obj.name,str(templates_obj[0].template))
								if x[1]==200:
									status=1
								else:
									status=0
								try:
									newins=Notification(
									user_id= user_obj.id,
									user_role=user_obj.role,
									uid= uuid1,
									status=status,
									target= user_obj.email,
									text= template_obj.template,
									not_type='email',
									created_at=datetime.datetime.utcnow(),
									updated_at=datetime.datetime.utcnow()
									)
									if status==0:
										newins.message=str(x[0])
									try:
										# app = Flask(__name__)
										db.session.add(newins)
										db.session.commit()
									except Exception as e:
										db.session.rollback()
								except Exception as e:
									logging.warn(f"Error while saving notification: {str(e)}")
									continue

							if template_obj.t_type in template_type and  'sms' in template_type:
								x=CreateNotification.send_phone_noti_v2(phone=send_to_phone,user_name = user_obj.name,messageText = str(templates_obj[0].template))
								if x[1] == 200:
									status=1
								else:
									status=0
								try:
									newins=Notification(
									user_id= user_obj.id,
									user_role=user_obj.role,
									uid= uuid1,
									status=status,
									target= user_obj.email,
									text= template_obj.template,
									not_type='email',
									created_at=datetime.datetime.utcnow(),
									updated_at=datetime.datetime.utcnow()
									)
									if status==0:
										newins.message=str(x[0])
									try:
										# app = Flask(__name__)
										db.session.add(newins)
										db.session.commit()
									except Exception as e:
										db.session.rollback()
								except Exception as e:
									logging.warn(f"Error while saving notification: {str(e)}")
									continue

							

		except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

	@staticmethod
	def send_mail_noti(target,messageText, template = 'notification.html' ):
		try:
			html = render_template(template,messageText=messageText,target=target)
			send_email(target, 'Notification', html)
			response_object = {
				'status': True,
				'message': 'Notification Create',
				'data': None,
				'error': None
				}
			return response_object, 200


		except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

	@staticmethod
	def send_mail_noti_v2(email, user_name,messageText, template = 'notification.html'):
		try:
			with app.app_context():
				html = render_template(template,messageText=messageText,target=user_name)
				send_email = mailgun.send_mail(email=email, subject='24x7 | Notification', html=html)

				if send_email.status_code == 200:
					logging.info(f"Notification sent successfully to: {email}")
					return json.loads(send_email.text)['message'], int(send_email.status_code)
				else:
					logging.warn(f"Notification not sent successfully to: {email}")
					return json.loads(send_email.text)['message'], int(400)

		except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

	@staticmethod
	def send_phone_noti_v2(phone, user_name,messageText, template = 'notificationsms.html'):
		try:
			with app.app_context():
				html = render_template(template,messageText=messageText,target=user_name)
				send_sms = Fast2SMS.send_sms(phone=phone,message=html)

				if not send_sms.status_code == 200:
					raise Exception

				response_object = {
					'status': True,
					'message': 'Notification Created',
					'data': None,
					'error': None
				}
				return response_object, 200

		except Exception as e:
			error = ApiResponse(False, 'Error Occurred', None,
								str(e))
			return (error.__dict__), 500

