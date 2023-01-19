from flask import request
from app.main.service.v1.auth_helper import Auth



def log(message):
    resp , status = Auth.get_logged_in_user(request)
    user = resp['data']
    
    log_text = f"user : {user['name']}, role : {user['role']}, message: {message}"
    
    return log_text

    # if level.lower() == "info":
    #      api.logger.info(log_text)
    
    # if level.lower() == "error":
    #     api.logger.error(log_text)

    # else:
    #     raise "Invalid Log Level"