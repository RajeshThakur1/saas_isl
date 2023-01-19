import base64
import datetime
import logging
from flask.templating import render_template

import pyotp
from app.main.model.admin import Admin
from app.main.model.apiResponse import ApiResponse
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.merchant import Merchant
from app.main.model.superAdmin import SuperAdmin
from app.main.model.supervisor import Supervisor
from app.main.model.user import User
from app.main.model.userOtp import  MerchantOtp, UserOtp
from app.main.service.v1.email import send_confirmation_email
from app.main.service.v1.notification_service import CreateNotification
from app.main.service.v1.otp_service import generateKey, save_changes
from app.main.service.v1.fast2sms import Fast2SMS
portal_role_map = {
         'customer': User,
         'merchant': Merchant,
         'supervisor': Supervisor,
         'distributor': Distributor,
         'delivery_associate': DeliveryAssociate,
         'admin': Admin,
         'super_admin': SuperAdmin
      }

def send_confirmation_otp(new_user_phone, role):

    try:
			
        logging.info("Recieved generate otp request")
        
        logging.info("User role: " + role)
        user_obj=portal_role_map[role].query.filter_by(phone=new_user_phone).first()
        phone_otp=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(deleted_at=None).filter_by(otp_route=1).filter(UserOtp.expiring_at<=datetime.datetime.utcnow()).filter(UserOtp.emailVerificationAttempted<=3).first()
        email_otp=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(deleted_at=None).filter_by(otp_route=0).filter(UserOtp.expiring_at<=datetime.datetime.utcnow()).filter(UserOtp.phoneVerificationAttempted<=3).first()
        if not phone_otp:
            phone_otp = UserOtp(counter=0,user_id=user_obj.id,user_role=user_obj.role, otp_type=0, otp_route=1,created_at=datetime.datetime.utcnow(), expiring_at=datetime.datetime.utcnow() + datetime.timedelta(minutes=3))
            # save_changes(phone_otp)

        if not email_otp:
            email_otp = UserOtp(counter=0,user_id=user_obj.id,user_role=user_obj.role, otp_type=0, otp_route=0,created_at=datetime.datetime.utcnow(), expiring_at=datetime.datetime.utcnow() + datetime.timedelta(minutes=3))
            # save_changes(email_otp)

        
        
        logging.info("Otp generation completed;")
        phone_otp.counter += 1
        email_otp.counter += 1
          # Save the data
        keygen1 = generateKey()
        keygen2 = generateKey()
        logging.info("Otp key generation completed;")
        key1 = base64.b32encode(keygen1.returnValue(new_user_phone).encode()) 
        key2 = base64.b32encode(keygen2.returnValue(user_obj.email).encode()) # Key is generated
        OTP1 = pyotp.HOTP(key1)
        OTP2 = pyotp.HOTP(key2)
        # print(OTP,"this is the key")
        save_changes(phone_otp)
        save_changes(email_otp)
        phone_otp.otp = str(OTP1.at(phone_otp.counter))
        email_otp.otp = str(OTP2.at(email_otp.counter))

        save_changes(phone_otp)
        save_changes(email_otp)
        placeholder_message="confirm your 24x7 Saas account"
        
        logging.info(f"This is the key: {OTP1.at(phone_otp.counter)}")
        sms_message = render_template('otpsms.html',otp=OTP1.at(phone_otp.counter), message=placeholder_message)

        email_message = render_template('otp.html', otp=OTP2.at(email_otp.counter), message=placeholder_message)
        sms = Fast2SMS.send_sms(phone=new_user_phone,message=sms_message)
        email, code = send_confirmation_email(to=user_obj.email,message=email_message, placeholder=placeholder_message)

        if email:
            if sms:
                return True

    
    except Exception as e:
        error=ApiResponse(False, 'Something went wrong', None, str(e))
        return (error.__dict__), 500

def generateOTPsms(data, template_type):
    try:
        role = data['role']
        phone = data['phone']
        email = data['email']
        messageTitle = data['placeholder']
        otp_type = data['type']


        user_obj=portal_role_map[role].query.filter_by(phone=phone).filter_by(email=email).first()

        if not user_obj:
            return False, None

        phone_otp=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(deleted_at=None).filter_by(otp_route=1).filter(UserOtp.expiring_at<=datetime.datetime.utcnow()).filter(UserOtp.emailVerificationAttempted<=3).first()
        email_otp=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(deleted_at=None).filter_by(otp_route=0).filter(UserOtp.expiring_at<=datetime.datetime.utcnow()).filter(UserOtp.phoneVerificationAttempted<=3).first()
        if not phone_otp and 'sms' in template_type:
            phone_otp = UserOtp(counter=0,user_id=user_obj.id,user_role=user_obj.role, otp_type=otp_type, otp_route=1,created_at=datetime.datetime.utcnow(), expiring_at=datetime.datetime.utcnow() + datetime.timedelta(minutes=3))
            # save_changes(phone_otp)
            phone_otp.counter += 1
            keygen1 = generateKey()
            key1 = base64.b32encode(keygen1.returnValue(phone).encode()) 
            OTP1 = pyotp.HOTP(key1)
            save_changes(phone_otp)
            phone_otp.otp = str(OTP1.at(phone_otp.counter))
            save_changes(phone_otp)
        if not email_otp and 'email' in template_type:
            email_otp = UserOtp(counter=0,user_id=user_obj.id,user_role=user_obj.role, otp_type=otp_type, otp_route=0,created_at=datetime.datetime.utcnow(), expiring_at=datetime.datetime.utcnow() + datetime.timedelta(minutes=3))
            # save_changes(email_otp)
            logging.info("Otp generation completed;")
        
            email_otp.counter += 1
                # Save the data
            
            keygen2 = generateKey()
            logging.info("Otp key generation completed;")
            
            key2 = base64.b32encode(keygen2.returnValue(user_obj.email).encode()) # Key is generated
            
            OTP2 = pyotp.HOTP(key2)
            # print(OTP,"this is the key")
        
            save_changes(email_otp)
            
            email_otp.otp = str(OTP2.at(email_otp.counter))

        
            save_changes(email_otp)
        
        
        

        notification_data = {
            'template_name': 'enter_otp_to',
            'action': messageTitle,
            'otp_email': email_otp.otp,
            'otp_phone': phone_otp.otp
        }
        status, msg_mail, msg_phone = CreateNotification.gen_notification(data=notification_data)

        if not status == 500:
            return True, msg_phone, msg_mail
    
    except Exception as e:

        return False, '500', str(e)


def verify_confirmation_otp(data,route):
    try:
        ROLE_MAP = {
            'customer': User,
            'merchant': Merchant,
            'supervisor': Supervisor,
            'admin': Admin,
            'super_admin': SuperAdmin,
            'distributor': Distributor,
            'delivery_associate': DeliveryAssociate
        }
        if route == 0:

            if data['login_request'] in ROLE_MAP.keys():
                user_obj=ROLE_MAP[data['login_request']].query.filter_by(email=data['email']).first()

                password = data['password']

                if not user_obj.check_password(password):
                    response_object=ApiResponse(False, 'Password does not match', None, 'User password is wrong')
                    return response_object.__dict__, 400

                otp_user=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(otp_route=0).filter_by(isEmailVerified=False).filter_by(otp_type=0).first()

                if not otp_user:
                    response_object = ApiResponse(False, 'Otp not generated', None, 'No confirmation otp generated for user')
                    return response_object.__dict__, 400

                
                keygen = generateKey()
                key = base64.b32encode(keygen.returnValue(data['email']).encode())  # Generating Key
                OTP = pyotp.HOTP(key)  # HOTP Model
                otp_user.emailVerificationAttempted += 1

                if otp_user.emailVerificationAttempted > 3:
                    if send_confirmation_otp(user_obj.phone,data['login_request']):
                        response_object = ApiResponse(False, 'New OTP generated', None, 'Too many otp verification attempts')
                if OTP.verify(data['otp'], otp_user.counter):
                    if otp_user.expiring_at > datetime.datetime.utcnow():  # Verifying the OTP
                        otp_user.isEmailVerified = True
                        save_changes(otp_user)
                        user_obj.update_to_db({"email_verified_at": datetime.datetime.utcnow()})
                        apiResponce = ApiResponse(True, 'Email verification successful', None, None)
                        return (apiResponce.__dict__), 201
                    
                    if send_confirmation_otp(user_obj.phone,data['login_request']):
                            response_object = ApiResponse(False, 'New OTP generated', None, 'OTP Verification Failed')
                            return response_object.__dict__, 200
                
                response_object = ApiResponse(False, 'OTP Verification Failed', None, 'Given OTP is wrong or invalid')
                return response_object.__dict__, 400
                
        elif route == 1:
            if data['login_request'] in ROLE_MAP.keys():
                user_obj=ROLE_MAP[data['login_request']].query.filter_by(phone=data['phone']).first()

                password = data['password']

                if not user_obj.check_password(password):
                    response_object=ApiResponse(False, 'Password does not match', None, 'User password is wrong')
                    return response_object.__dict__, 400

                otp_user=UserOtp.query.filter_by(user_id=user_obj.id).filter_by(otp_route=1).filter_by(isEmailVerified=False).filter_by(otp_type=0).first()

                if not otp_user:
                    response_object = ApiResponse(False, 'Otp not generated', None, 'No confirmation otp generated for user')
                    return response_object.__dict__, 400

                if otp_user.phoneVerificationAttempted > 3:
                    if send_confirmation_otp(user_obj.phone,data['login_request']):
                        response_object = ApiResponse(False, 'New OTP generated', None, 'Too many otp verification attempts')
                        return response_object.__dict__, 200
                
                keygen = generateKey()
                key = base64.b32encode(keygen.returnValue(data['phone']).encode())  # Generating Key
                OTP = pyotp.HOTP(key)  # HOTP Model
                if OTP.verify(data['otp'], otp_user.counter):
                    if  otp_user.expiring_at > datetime.datetime.utcnow():  # Verifying the OTP
                        otp_user.isPhoneVerified = True
                        save_changes(otp_user)
                        user_obj.update_to_db({"phone_verified_at": datetime.datetime.utcnow()})
                        apiResponce = ApiResponse(True, 'Phone verification successful', None, None)
                        return (apiResponce.__dict__), 201
    
                    if send_confirmation_otp(user_obj.phone,data['login_request']):
                            response_object = ApiResponse(False, 'New OTP generated', None, 'OTP Verification Failed')
                            return response_object.__dict__, 400

                response_object = ApiResponse(False, 'OTP Verification Failed', None, 'Given OTP is wrong or invalid')
                return response_object.__dict__, 400
    except Exception as e:
            error = ApiResponse(False, 'Error Occurred', None,
                                str(e))
            return (error.__dict__), 500


