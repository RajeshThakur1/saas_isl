import flask_restx
from app.main.model.apiResponse import ApiResponse
from app.main.model.user import User
from app.main.service.v1.auth_helper import Auth
from flask import request
from app.main.service.v1 import image_helper
from flask_uploads import UploadNotAllowed
from app.main.config import STATIC_FOLDER, UPLOAD_FOLDER
from werkzeug.exceptions import RequestEntityTooLarge
from werkzeug.utils import secure_filename
from app.main.service.v1.fileupload_ import upload_file_to_bucket 
import os
import hashlib
import jwt
import datetime
from app.main.config import image_name_size
from wand.image import Image
import uuid
from app.main.config import item_icon_dir, item_details_dir, category_dir, menucategory_dir, profile_pic_dir
from app.main.util.v1.database import save_db

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/image_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def image_save(new_request, bucket_dir):
    try:
        try:
            data = new_request.files
        except RequestEntityTooLarge as e:
            apiResponse = ApiResponse(False,f"File is Size is Too Large",None,str(e))
            return apiResponse.__dict__, 413
        
        resp, status = Auth.get_logged_in_user(request)
        user_id = resp['data']['id']
        user_role = resp['data']['role']
        file = data['image']
        
        if 'image' not in data:
            message = 'No image part in the request'

        elif file.filename == '':
            message = 'No image selected for uploading'
            
        elif len(file.filename) > image_name_size:
            message = 'File name is too Large'
        elif file:
            # resp, status = Auth.get_logged_in_user(request)
            # user_id = resp['data']['id']
            # folder = UPLOAD_FOLDER
            file_name = bytes(secure_filename(bucket_dir+"_"+str(user_role)+"_"+str(user_id)),"utf-8")
            hash_file_name = hashlib.sha256(file_name)
            filename = hash_file_name.hexdigest()
            extension = file.filename.split(".")[-1]
            filename = f"{filename}.{extension}"

            file_path = UPLOAD_FOLDER + f"/{filename}"
            if os.path.exists(file_path) or os.path.isfile(file_path):
                os.remove(file_path)

            image_path = image_helper.save_image(data["image"],name = filename)

            image = Image(filename = image_path)
            image.resize(400, 365)

            if bucket_dir != category_dir or bucket_dir != menucategory_dir or bucket_dir != profile_pic_dir :

                logo = Image(filename=STATIC_FOLDER+"logo.png")
                logo.transparentize(0.33)
                image.composite_channel("all_channels",
                            logo,
                            "dissolve",
                            int(image.width - logo.width - 20),
                            int(image.height - logo.height - 20))

            image.compression_quality = 60
            image.save(filename=image_path)

            if bucket_dir == item_icon_dir:
                another_filename = secure_filename(item_details_dir+file_name)

                file_path = UPLOAD_FOLDER + f"/{another_filename}"
                if os.path.exists(file_path) or os.path.isfile(file_path):
                    os.remove(file_path)

                another_image_path = image_helper.save_image(data['image'], name = another_filename)
                image = Image(filename = another_image_path)
                image.resize(800, 530)
                image.composite_channel("all_channels",
                            logo,
                            "dissolve",
                            int(image.width - logo.width - 20),
                            int(image.height - logo.height - 20))
                image.compression_quality = 75
                image.save(filename=another_image_path)
            # here we only return the basename of the image and hide the internal folder structure from our user
            basename = image_helper.get_basename(image_path)
        
            #File Upload
            #url = upload_file_to_bucket(image_path, bucket_dir)
            
            # os.remove(image_path)

            data = {
                'image':basename, 
                # 'preview':url 
            }
        
            apiResponse = ApiResponse(True,f"Image Uploaded Successfully",data,None)
            return apiResponse.__dict__, 200
        
        apiResponse = ApiResponse(False,message,None,message)
        return apiResponse.__dict__, 400

            

    except UploadNotAllowed:  # forbidden file type
        extension = image_helper.get_extension(data["image"])
        apiResponse = ApiResponse(False,f"File type {extension} extension not allowed",None,"Wrong Extention Given")
        return apiResponse.__dict__, 400

    except Exception as e:
        apiResponse = ApiResponse(False,f"Error Occured",None,str(e))
        return apiResponse.__dict__, 500


def image_upload(filename, bucket_dir, name):

    resp, data = Auth.get_logged_in_user(request)
    user = resp['data']

    file_path = UPLOAD_FOLDER + f"/{filename}"

    if not os.path.exists(file_path) or not os.path.isfile(file_path):
        error = ApiResponse(False, 'Image File not Found', None,
                            'Given Image Link Not Found')
        return (error.__dict__), 400

    extension = image_helper.get_extension(file_path)
        
    # payload = {
    #             'exp': datetime.datetime.utcnow(),
    #             'iat': datetime.datetime.utcnow(),
    #             'sub': f"{name}_{user['role']}_{user['id']}", 
                
    #         }
    # file_name = jwt.encode(
    #             payload,
    #             image_key,
    #             algorithm='HS256'
    #         )
    # file_name = file_name.split(".")[1]
    # file_name = bytes(filename+str(datetime.datetime.utcnow()),"utf-8")
    # hash_file_name = hashlib.sha256(file_name)
    # file_name = hash_file_name.hexdigest()
    unique = uuid.uuid4()
    new_file_path = UPLOAD_FOLDER + "/" +secure_filename(f"{bucket_dir}_{name}_{datetime.datetime.utcnow()}_{unique}") + extension  
    os.rename(file_path, new_file_path)
    image_path = new_file_path
    url = upload_file_to_bucket(image_path, bucket_dir)
    os.remove(image_path)

    if bucket_dir == item_icon_dir:
        another_file_path = UPLOAD_FOLDER + f"/{secure_filename(item_details_dir + filename)}"

        another_new_file_path = UPLOAD_FOLDER + "/" +secure_filename(f"{item_details_dir}_{name}_{datetime.datetime.utcnow()}_{unique}") + extension  
        os.rename(another_file_path, another_new_file_path)

        image_path = another_new_file_path
        url = upload_file_to_bucket(image_path, item_details_dir)
        os.remove(image_path)

    return url, 200

def profle_pic_image_save(new_request, bucket_dir):
    
    """
    Saves image to s3 bucket for profile picture selection
    
    Parameters: request, bucket_dir
    Return type: __dict__, Integer
    """
    try:
        try:
            data = new_request.files
        except RequestEntityTooLarge as e:
            apiResponse = ApiResponse(False,f"File is Size is Too Large",None,str(e))
            return apiResponse.__dict__, 413
        
        resp, status = Auth.get_logged_in_user(request)
        user_name = resp['data']['name']
        user_id = resp['data']['id']
        user_role = resp['data']['role']
        file = data['image']
        
        user_object = User.query.filter_by(id = user_id).first()
        if user_object.deleted_at != None:
            apiResponse = ApiResponse(True,f"User is Deleted",data,None)
            return apiResponse.__dict__, 400
        
        if not user_object.active:
            apiResponse = ApiResponse(True,f"User is not active",data,None)
            return apiResponse.__dict__, 400

        if 'image' not in data:
            message = 'No image part in the request'

        elif file.filename == '':
            message = 'No image selected for uploading'
            
        elif len(file.filename) > image_name_size:
            message = 'File name is too Large'
        
        elif file:
            # resp, status = Auth.get_logged_in_user(request)
            # user_id = resp['data']['id']
            # folder = UPLOAD_FOLDER
            file_name = secure_filename(str(user_role)+"_"+str(user_name['name'])+"_"+str(user_id))
            # hash_file_name = hashlib.sha256(file_name)
            extension = file.filename.split(".")[-1]
            filename = f"{file_name}.{extension}"

            file_path = UPLOAD_FOLDER + f"/{filename}"
            if os.path.exists(file_path) or os.path.isfile(file_path):
                os.remove(file_path)

            image_path = image_helper.save_image(data["image"],name = filename)

            image = Image(filename = image_path)
            image.resize(400, 365)

            image.compression_quality = 60
            image.save(filename=image_path)

            # here we only return the basename of the image and hide the internal folder structure from our user
            # basename = image_helper.get_basename(image_path)
        
            #File Upload
            url = upload_file_to_bucket(image_path, bucket_dir)
            
            os.remove(image_path)
            
            user_object.image = url
            save_db(user_object)
            
            
            apiResponse = ApiResponse(True,f"Image Uploaded Successfully",data,None)
            return apiResponse.__dict__, 200
        
        apiResponse = ApiResponse(False,message,None,message)
        return apiResponse.__dict__, 400

            

    except UploadNotAllowed:  # forbidden file type
        extension = image_helper.get_extension(data["image"])
        apiResponse = ApiResponse(False,f"File type {extension} extension not allowed",None,"Wrong Extention Given")
        return apiResponse.__dict__, 400

    except Exception as e:
        apiResponse = ApiResponse(False,f"Error Occured",None,str(e))
        return apiResponse.__dict__, 500
    

    
    """
    Saves image to s3 bucket for profile picture selection
    
    Parameters: request, bucket_dir
    Return type: __dict__, Integer
    """
    try:
        try:
            data = new_request.files
        except RequestEntityTooLarge as e:
            apiResponse = ApiResponse(False,f"File is Size is Too Large",None,str(e))
            return apiResponse.__dict__, 413
        
        resp, status = Auth.get_logged_in_user(request)
        user_name = resp['data']['name']
        user_id = resp['data']['id']
        user_role = resp['data']['role']
        file = data['image']
        
        user_object = User.query.filter_by(id = user_id).first()
        if user_object.deleted_at != None:
            apiResponse = ApiResponse(True,f"User is Deleted",data,None)
            return apiResponse.__dict__, 400
        
        if not user_object.active:
            apiResponse = ApiResponse(True,f"User is not active",data,None)
            return apiResponse.__dict__, 400

        if 'image' not in data:
            message = 'No image part in the request'

        elif file.filename == '':
            message = 'No image selected for uploading'
            
        elif len(file.filename) > image_name_size:
            message = 'File name is too Large'
        
        elif file:
            # resp, status = Auth.get_logged_in_user(request)
            # user_id = resp['data']['id']
            # folder = UPLOAD_FOLDER
            file_name = secure_filename(str(user_role)+"_"+str(user_name['name'])+"_"+str(user_id))
            # hash_file_name = hashlib.sha256(file_name)
            extension = file.filename.split(".")[-1]
            filename = f"{file_name}.{extension}"

            file_path = UPLOAD_FOLDER + f"/{filename}"
            if os.path.exists(file_path) or os.path.isfile(file_path):
                os.remove(file_path)

            image_path = image_helper.save_image(data["image"],name = filename)

            image = Image(filename = image_path)
            image.resize(400, 365)
            
            if bucket_dir != category_dir or bucket_dir != menucategory_dir or bucket_dir != profile_pic_dir :

                logo = Image(filename=STATIC_FOLDER+"logo.png")
                logo.transparentize(0.33)
                image.composite_channel("all_channels",
                            logo,
                            "dissolve",
                            int(image.width - logo.width - 20),
                            int(image.height - logo.height - 20))

            image.compression_quality = 60
            image.save(filename=image_path)

            # here we only return the basename of the image and hide the internal folder structure from our user
            # basename = image_helper.get_basename(image_path)
        
            #File Upload
            url = upload_file_to_bucket(image_path, bucket_dir)
            
            os.remove(image_path)
            
            user_object.image = url
            save_db(user_object)
            
            
            apiResponse = ApiResponse(True,f"Image Uploaded Successfully",data,None)
            return apiResponse.__dict__, 200
        
        apiResponse = ApiResponse(False,message,None,message)
        return apiResponse.__dict__, 400

            

    except UploadNotAllowed:  # forbidden file type
        extension = image_helper.get_extension(data["image"])
        apiResponse = ApiResponse(False,f"File type {extension} extension not allowed",None,"Wrong Extention Given")
        return apiResponse.__dict__, 400

    except Exception as e:
        apiResponse = ApiResponse(False,f"Error Occured",None,str(e))
        return apiResponse.__dict__, 500