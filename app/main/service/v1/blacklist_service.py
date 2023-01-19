from app.main import db
from app.main.model.blacklist import BlacklistToken
from itsdangerous import URLSafeTimedSerializer
from app.main import config

# import logging
# import os
#
# logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
# log_dir = "logs"
# os.makedirs(log_dir, exist_ok=True)
# logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
#                     filemode="a")
def save_token(token):
    blacklist_token = BlacklistToken(token=token)
    try:
        # insert the token
        db.session.add(blacklist_token)
        db.session.commit()
        response_object = {
            'success': True,
            'message': 'Successfully logged out.',
            'data':'',
            'error':None
        }
        return response_object, 200
    except Exception as e:
        response_object = {
            'success': False,
            'message': 'Not logout',
            'data':None,
            'error':e
        }
        return response_object, 401




def generate_confirmation_token(email):
    serializer = URLSafeTimedSerializer(config.config['SECRET_KEY'])
    return serializer.dumps(email, salt=config.config['SECURITY_PASSWORD_SALT'])


def confirm_token(token, expiration=3600):
    serializer = URLSafeTimedSerializer(config.config['SECRET_KEY'])
    try:
        email = serializer.loads(
            token,
            salt=config.config['SECURITY_PASSWORD_SALT'],
            max_age=expiration
        )
    except:
        return False
    return email
