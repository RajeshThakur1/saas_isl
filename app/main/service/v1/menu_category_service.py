from sqlalchemy.sql.functions import func
from app.main.service.v1.image_service import image_save, image_upload
import datetime
from app.main import db
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.menuCategory import MenuCategory
from app.main.model.category import Category
from app.main.model.apiResponse import ApiResponse
from app.main.config import menucategory_dir
from app.main.service.v1.fileupload_ import  check_file
from app.main.util.v1.database import save_db

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/menu_category_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def create_menu_category(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        category = Category.query.filter_by(id = data['category_id']).filter_by(deleted_at = None).first()

        if category:
            
            if data['image'] == "default":
                data['image'] = menucategory_dir + "default.png"
            
            else:
                image_file, status = image_upload(data['image'],menucategory_dir,data['name'])
            
                if status == 400:
                    return image_file, status

                data['image'] = image_file
            
        

            menuCategory = MenuCategory(name=data['name'],
                                        image=data['image'],
                                        # slug=data['slug'],
                                        status=data['status'],
                                        category_id=data['category_id'],
                                        created_at=datetime.datetime.utcnow())

            try:
                db.session.add(menuCategory)
                db.session.commit()
                apiResponce = ApiResponse(True,
                                        'MenuCategory Created successfully',
                                        None, None)
                return (apiResponce.__dict__), 201
            
            except Exception as e:
                db.session.rollback()
                apiResponce = ApiResponse(False,'Error Occurred',None,f"MenuCatagory Database Error: {str(e)}")
                return (apiResponce.__dict__), 500

        else:
            apiResponce = ApiResponse(False, 'Error Occurred', None, "Given Catagory id is wrong or deleted")
            return (apiResponce.__dict__), 400

        
    except Exception as e:
        error = ApiResponse(False, 'MenuCategory Not able to Create', None,
                            str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def update_menuCategory(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        catagory = Category.query.filter_by(id=data['category_id']).filter_by(deleted_at = None).first()
        
        if catagory:
            
            # if data['image'] == "default":
            #     data['image'] = menucategory_dir + "default.png"

            # else: 
            #     image_file, status = image_upload(data['image'],menucategory_dir,data['name'])
            
            #     if status == 400:
            #         if not check_file(data['image']):
            #             return image_file, 400


            #     else:
            #         data['image'] = image_file

            menuCategory = MenuCategory.query.filter(
                MenuCategory.id == data['id'],
                MenuCategory.deleted_at == None).first()

            if menuCategory:
                menuCategory.name = data['name']
                menuCategory.category_id = data['category_id']
                menuCategory.code = data['image']
                menuCategory.slug = data['slug']
                menuCategory.status = data['status']
                menuCategory.updated_at = datetime.datetime.utcnow()
                
                try:
                    db.session.add(menuCategory)
                    db.session.commit()

                    apiResponce = ApiResponse(True,
                                            'MenuCategory Updated successfully',
                                            None, None)
                    return (apiResponce.__dict__), 202
                
                except Exception as e:
                    db.session.rollback()
                    apiResponce = ApiResponse(False,'Error Occurred',None,f"MenuCatagory Database Error: {str(e)}")
                    return (apiResponce.__dict__), 500
            
            else:
                error = ApiResponse(
                    False, 'Error Occurred , Change the Menu Category', None,
                    "Given MenuCatagory id Wrong or Deleted")
                return (error.__dict__), 400
        else:
                error = ApiResponse(
                    False, 'Error Occurred,  Change the Category', None,
                    "Given Catagory id Wrong or Deleted")
                return (error.__dict__), 400
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500

def update_menuCategory_image(data):
    try:
        
        category = Category.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not category:
            error = ApiResponse(False, 'Category Not able to fetch', None,
                                "Invalid Category ID")
            return (error.__dict__), 400
        
        menucategory = MenuCategory.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not menucategory:
            error = ApiResponse(False, 'Menu Category Not able to fetch', None,
                                "Invalid Menu Category ID")
            return (error.__dict__), 400
        
        
        image, status = image_save(request, menucategory_dir)
        
        if status != 200:
            return image, status
        
        url, status = image_upload(image['data']['image'], menucategory_dir, menucategory.name)
        
        if status != 200:
            return image, status
        
        menucategory.image = url
        menucategory.updated_at = datetime.datetime.utcnow()
        save_db(menucategory)
        
        return ApiResponse(True, "Category Image Updated successfully"), 200
    except Exception as e:
        error = ApiResponse(False, 'Category Not able to Update', None,
                            str(e))
        return (error.__dict__), 500
    
def show_menuCategory():
    try:
        # user = Auth.get_logged_in_user(request)
        # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
        records = MenuCategory.query.filter(
            MenuCategory.deleted_at == None).order_by(func.lower(MenuCategory.name)).all()
        if records:
            recordObject = []
            for record in records:
                response = {
                    'id': record.id,
                    'category_id': record.category_id,
                    'name': record.name,
                    'image': record.image,
                    'slug': record.slug,
                    'status': record.status,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                    'deleted_at': str(record.deleted_at),
                }
                recordObject.append(response)
            apiResponce = ApiResponse(True, 'List of All MenuCategories',
                                    recordObject, None)
            return (apiResponce.__dict__), 200
        
        else:
            error = ApiResponse(False, 'MenuCategory Not able to fetch', None,
                                'Internal Error inside menuCategory_service.py()')
            return (error.__dict__), 404
        # else:
        #     error = ApiResponse(False, 'User is not Authorized', None, None)
        #     return (error.__dict__), 401
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500


def delete_menuCategory(data):
    # user = Auth.get_logged_in_user(request)    
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):

    try:
        menuCategory = MenuCategory.query.filter_by(id=data['id']).first()

        if menuCategory:
            menuCategory.deleted_at = datetime.datetime.utcnow()
            db.session.commit()

            apiResponce = ApiResponse(True,
                                      'MenuCategory Deleted Successfully.',
                                      None, None)
            return (apiResponce.__dict__), 200
        else:
            error = ApiResponse(False, 'MenuCategory does not exists.', None,
                                None)
            return (error.__dict__), 409

    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def show_menu_category_by_category_id(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):

    try:
        records = MenuCategory.query.filter(
            MenuCategory.deleted_at == None,
            MenuCategory.category_id == data['category_id']).all()

        recordObject = []
        if records:
            
            for record in records:
                response = {
                    'id': record.id,
                    'category_id': record.category_id,
                    'name': record.name,
                    'image': record.image,
                    'slug': record.slug,
                    'status': record.status,
                    'created_at': str(record.created_at),
                    'updated_at': str(record.updated_at),
                    'deleted_at': str(record.deleted_at),
                }
                recordObject.append(response)
            apiResponce = ApiResponse(True, 'List of All MenuCategories',
                                      recordObject, None)
            return (apiResponce.__dict__), 200
        else:
            error = ApiResponse(True, 'MenuCategory Fetched successfully', recordObject,
                                None)
            return (error.__dict__), 200
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500

    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500


def show_store_menu_category_by_category_ids(data):
    # user = Auth.get_logged_in_user(request)
    # if ((user.role == 'super_admin') or (user.role == 'admin') or (user.role == 'merchant')):
    try:
        recordObject = []
        invalid = ""
        valid = ""
        no_data = ""
        valid_name = ""

        for category_id in data['category_id']:
            category = Category.query.filter_by(id = category_id).filter_by(deleted_at = None).first()

            if not category:
                invalid = invalid + str(category_id) + ", "

            else:
                records = MenuCategory.query.filter(
                    MenuCategory.deleted_at == None,
                    MenuCategory.category_id == category_id).all()

                
                
                if not records:
                    no_data = no_data + category.name + ", "
                
                else:
                    for record in records:
                        valid = valid + str(category_id) + ", "
                        valid_name = valid_name + category.name + ", "
                        response = {
                            'id': record.id,
                            'category_id': record.category_id,
                            'name': record.name,
                            'image': record.image,
                            'slug': record.slug,
                            'status': record.status,
                            'created_at': str(record.created_at),
                            'updated_at': str(record.updated_at),
                            'deleted_at': str(record.deleted_at),
                        }
                        # print(response)
                        recordObject.append(response)

        if invalid == "" and no_data == "":
            apiResponce = ApiResponse(True, 'List of All MenuCategories',
                                        recordObject, None)
            return (apiResponce.__dict__), 200
        
        elif no_data != "" and valid != "":
            apiResponce = ApiResponse(True, f'List of MenuCategories Belongs to Category {valid_name}',
                                        recordObject, f"{str(no_data)} are valid categories but have no Menu Catagories, and Invalid categoriy Id are {invalid} ")
            return (apiResponce.__dict__), 206

        elif no_data == "" and valid != "":
            apiResponce = ApiResponse(True, f'List of MenuCategories Belongs to Category {valid_name}',
                                        recordObject, f"Invalid categoriy Id are {invalid} ")
            return (apiResponce.__dict__), 206

        elif no_data != "" and valid == "":
            apiResponce = ApiResponse(False, f'{str(no_data)} categories have no Menu Catagory',
                                        None, f"{str(no_data)} are valid categories but have no Menu Catagories, and Invalid categories are {invalid} ")
            return (apiResponce.__dict__), 400
        
        elif valid == "" and no_data == "":
            apiResponce = ApiResponse(False, 'Error Occured',
                                        None, "Given Id's are wrong or Deleted")
            return (apiResponce.__dict__), 400
            

    except Exception as e:
        error = ApiResponse(False, 'MenuCategory Not able to fetch', None,
                            str(e))
        return (error.__dict__), 500
    # else:
    #     error = ApiResponse(False, 'User is not Authorized', None, None)
    #     return (error.__dict__), 500
