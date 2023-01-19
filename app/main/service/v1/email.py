from app.main.model.supervisor import Supervisor
from app.main.model.superAdmin import SuperAdmin
from app.main.model.merchant import Merchant
from flask import render_template, url_for, flash
from flask_mail import Message
from itsdangerous import URLSafeTimedSerializer
from app.main.config import Config
from app.main import mail
from app.main import db
from app.main.model.user import User
from app.main.model.apiResponse import ApiResponse
from app.main import db
from flask import request
import requests
# from app.main.model.user import User
import app.main.service.v1.mailgun as mailgun
import datetime
from app.main.util.v1.database import save_db

import logging
import os
logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/email/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a", force=True)
#
# logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
# log_dir = "logs"
# os.makedirs(log_dir, exist_ok=True)
# logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
#                     filemode="a")

def generate_confirmation_token(email):
    """Confirmation email token."""
    serializer = URLSafeTimedSerializer(Config.SECRET_KEY)
    return serializer.dumps(email, salt=Config.SECURITY_PASSWORD_SALT)


def confirm_token(token, expiration=900000):
    """Plausibility check of confirmation token."""
    serializer = URLSafeTimedSerializer(Config.SECRET_KEY)
    print(serializer)
    try:
        email = serializer.loads(token, salt=Config.SECURITY_PASSWORD_SALT, max_age=expiration)
        print("this is email",email)
    except:
        return False
    return email


def send_email(to, subject, template):
    """Send an email."""
    #msg = Message(subject, recipients=[to], html=template,sender=Config.MAIL_DEFAULT_SENDER)
    # mail.send(msg)
    email = mailgun.send_mail(email=to, html=template, subject=subject)
    if email.status_code == 200:
        return True
    else:
        logging.info("Mail not sent: Error code: {email.status_code}")
        return False

    
def send_confirmation_email(to,message, placeholder):
    """Send a confirmation email to the registered user."""
    try:     
        token = generate_confirmation_token(to)
        confirm_url = url_for('api.User Profile_confirmation_view', token=token, _external=True)
        logging.info(confirm_url)
        html = render_template('confirmation.html', confirm_url=confirm_url)
        logging.info(html)
        subscription = mailgun.send_mail(email=to, html=message, subject=str.capitalize(placeholder))
        logging.info(subscription.status_code)
        logging.info(subscription.text)
        if subscription.status_code == 200:
            return True,  subscription.status_code
        else:
            return False,  subscription.status_code
        
    except Exception as e:
        return False
    
    # send_email(to, 'Test server - confirm your registration', html)
    # confirm_url = url_for('', token=token, _external=True)
    # html = render_template('confirmation.html', confirm_url=confirm_url)
    # send_email(to, 'Test server - confirm your registration', html)

def send_confirmation_email_forget_password(to,user_type):
    """Send a confirmation email to the registered user."""
    token = generate_confirmation_token(to)
    # print(request.url,"<<<<===")
    confirm_url = request.url +user_type+'/' + token 
    html = render_template('forgetpassword.html', confirm_url=confirm_url)
    send_email(to, 'Forget Password ', html)






def confirm_email(token):
    try:
        email = confirm_token(token)
    except:
        flash('The confirmation link is invalid or has expired.', 'danger')
    user = User.query.filter_by(email=email).first_or_404()
    if user.confirmed:
        apiResponce = ApiResponse(True, 'Successfully confirm.', None, None)
        return (apiResponce.__dict__), 201
        # flash('Account already confirmed. Please login.', 'success')
    else:
        user.active = True
        user.email_verified_at = datetime.datetime.utcnow()
        save_db(user,'user')
        # db.session.add(user)
        # db.session.commit()
        flash('You have confirmed your account. Thanks!', 'success')
    return True



def confirm_email_forget_password(token,newpassword,request_type):
    try:
        email = confirm_token(token)
    except:
        flash('The confirmation link is invalid or has expired.', 'danger')
    if request_type=='user':
        user = User.query.filter_by(email=email).first_or_404()
        if user and newpassword:
            user.password=newpassword
            save_db(user,"user")
            # db.session.add(user)
            # db.session.commit()
            apiResponce = ApiResponse(True, 'Successfully Change.', None, None)
            return (apiResponce.__dict__), 201
            # flash('Account already confirmed. Please login.', 'success')
        else:
            apiResponce = ApiResponse(True, 'Link expired.', None, None)
            return (apiResponce.__dict__), 401
    elif request_type=='merchant':
        user = Merchant.query.filter_by(email=email).first_or_404()
        if user and newpassword:
            user.password=newpassword
            save_db(user,"user")
            # db.session.add(user)
            # db.session.commit()
            apiResponce = ApiResponse(True, 'Successfully Change.', None, None)
            return (apiResponce.__dict__), 201
            # flash('Account already confirmed. Please login.', 'success')
        else:
            apiResponce = ApiResponse(True, 'Link expired.', None, None)
            return (apiResponce.__dict__), 401
    elif request_type=='super_admin':
        user = SuperAdmin.query.filter_by(email=email).first_or_404()
        if user and newpassword:
            user.password=newpassword
            save_db(user,"user")
            # db.session.add(user)
            # db.session.commit()
            apiResponce = ApiResponse(True, 'Successfully Change.', None, None)
            return (apiResponce.__dict__), 201
            # flash('Account already confirmed. Please login.', 'success')
        else:
            apiResponce = ApiResponse(True, 'Link expired.', None, None)
            return (apiResponce.__dict__), 401
    elif request_type=='supervisor':
        user = Supervisor.query.filter_by(email=email).first_or_404()
        if user and newpassword:
            user.password=newpassword
            save_db(user,"user")
            # db.session.add(user)
            # db.session.commit()
            apiResponce = ApiResponse(True, 'Successfully Change.', None, None)
            return (apiResponce.__dict__), 201
            # flash('Account already confirmed. Please login.', 'success')
        else:
            apiResponce = ApiResponse(True, 'Link expired.', None, None)
            return (apiResponce.__dict__), 401

