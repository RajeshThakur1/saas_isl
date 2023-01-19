from flask.helpers import url_for
from app.main import config
from app.main.model.storeCategory import StoreCategory
from app.main.service.v1.fileupload_ import check_file
from app.main.service.v1.image_service import image_save, image_upload
from app.main.util.v1.database import save_db
from app.main.model.menuCategory import MenuCategory
import datetime
from app.main import db
from app.main.model.category import Category
from app.main.model.city import City
from app.main.model.apiResponse import ApiResponse
from flask import request
from app.main.service.v1.auth_helper import Auth
from app.main.model.cityCategories import CityCategories
from app.main.config import ENDPOINT_PREFIX, category_dir, bucket_link

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/category_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")
def add_category_to_city(data):
    try:
        city = City.query.filter_by(id=data['city_id']).filter_by(deleted_at=None).first()

        if city:
            invalid_id = ""
            valid_id = ""
            valid_name = ""
            for id in data['cat_id']:
                category = Category.query.filter_by(id=id).filter_by(deleted_at = None).first()
                if category:
                    valid_id = valid_id + str(id) + ", "
                    valid_name = valid_name+ category.name + ", "
                    city_cat = CityCategories.query.filter_by(city_id=city.id).filter_by(category_id=category.id).filter_by(deleted_at=None).first()
                    if not city_cat:
                        new_city_category = CityCategories(
                            city_id=city.id,
                            category_id=category.id,
                            created_at=datetime.datetime.utcnow()
                        )
                        save_db(new_city_category)
                        # try:
                        #     db.session.add(new_city_category)
                        #     db.session.commit()
                        # except Exception as e:
                        #     apiResponce = ApiResponse(False, 'Error Occurred', None,
                        #                               f"Catagory Database Error: {str(e)}")
                        #     return (apiResponce.__dict__), 500
                    else:
                        continue
                        # apiResponce = ApiResponse(False, f'category name {category.name} already added to this service', None,
                        #                           f'category name {category.name} already added to this service')
                        # return (apiResponce.__dict__), 400


                else:
                    invalid_id = invalid_id + str(id) + ", "
            
            if invalid_id == "":
                apiResponce = ApiResponse(True, f'{valid_name} Categories added to City Successfully', None,
                                            None)
                return (apiResponce.__dict__), 200
            elif valid_id == "":
                apiResponce = ApiResponse(False, "Given Catagories are Wrong or Deleted", None,
                                            f"{invalid_id} Catagory id's are invalid or deleted")
                return (apiResponce.__dict__), 400
            else:
                apiResponce = ApiResponse(True , f"{valid_name} are added to City Successfully" , None, f"Id {invalid_id} are invalid, valid id's are {valid_id}")
                return (apiResponce.__dict__), 200
            
        else:
            apiResponce = ApiResponse(False, 'Error Occurred', None, "Given city id wrong or deleted")
            return (apiResponce.__dict__), 400       
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500
        


def remove_category_to_city(data):
    try:
        city = City.query.filter_by(id=data['city_id']).filter_by(deleted_at=None).first()

        if not city:
            apiResponce = ApiResponse(False, 'City Not Found', None, 'Given City id is invalid or deleted.')
            return apiResponce.__dict__, 400

        city_cat = CityCategories.query.filter_by(city_id=data['city_id']).filter_by(deleted_at=None).all()

        if not city_cat:
            apiResponce = ApiResponse(False, 'No Categories found for the city', None, 'City Categories does not have the specified city id.')
            return apiResponce.__dict__, 400

        

        count = 0 
        i= 0
        for category in data['cat_id']:
            
            category_id = category
            categories = CityCategories.query.filter_by(category_id=category_id).filter_by(city_id=data['city_id']).all()
            
            
            if not categories:
                data['cat_id'][i] = "Invalid Category ID: " + str(data['cat_id'][i])
                count = count + 1
                continue
            
                
            if categories[0].deleted_at == None:
                categories[0].deleted_at = datetime.datetime.utcnow()
                categories[0].updated_at = datetime.datetime.utcnow()

            i+=1
        try:
            db.session.commit()
        except Exception as e:
            apiResponce = ApiResponse(False, 'Failed to write to Database.', None, 'Database error')
            return apiResponce.__dict__, 500
        
        if count >= len(data['cat_id']):
            apiResponce = ApiResponse(False, 'Invalid Category id\'s', None, 'All Category id\'s are invalid.')
            return apiResponce.__dict__, 400

        if count == 0:
            apiResponce = ApiResponse(True, 'Categories successfully removed', None, None)
            return apiResponce.__dict__, 200

        apiResponce = ApiResponse(True, 'Categories partially removed', data['cat_id'], None)
        return apiResponce.__dict__, 200
    except Exception as e:
        apiResponce = ApiResponse(False, 'Something went wrong.', None, 'Internal Server Error.')
        return apiResponce.__dict__, 500


def GetCategoryByCity(data):
    try:
        city = City.query.filter_by(id=data['id']).filter_by(deleted_at = None).first()

        if city:
            
            city_categories = CityCategories.query.filter_by(city_id = city.id).filter_by(deleted_at = None).all()
            response=[]

            if not city_categories:
                apiResponce = ApiResponse(True, 'No Category mapped to city yet: ' + city.name,
                                            response, 'City Categories query returned empty.')
                return (apiResponce.__dict__), 200

            for category in city_categories:

                result = Category.query.filter_by(id=category.category_id).filter_by(deleted_at=None).first()
                if result:
                    response.append({
                    'id':result.id,
                    'name':result.name,
                    'image':result.image,
                    'status':result.status,
                # 'created_at':str(result.created_at),
                # 'updated_at':str(result.updated_at),
                # 'deleted_at':str(result.deleted_at)
                    })
                
            apiResponce = ApiResponse(True, 'List of  Categories by City ' + city.name,
                                            response, None)
            return (apiResponce.__dict__), 200
        
        else:
            apiResponce = ApiResponse(False, 'Error Occurred', None, "Given city id wrong or deleted")
            return (apiResponce.__dict__), 400   
            
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500


def GetCategoryByCityName(data):
    try:
        city = City.query.filter_by(name=data['city_name']).first()
        page = 1
        items_per_page = 10

        try:
            page = int(data['page'])
        except Exception as e:
            pass

        try:
            items_per_page = int(data['items'])
        except Exception as e:
            pass
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        

        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400

        if city:
            city_categories = CityCategories.query.filter_by(city_id = city.id).filter_by(deleted_at = None).paginate(page, items_per_page, False)
            response=[]
            for city_category in city_categories.items:
                result = Category.query.filter_by(id = city_category.category_id).filter_by(status = 1).filter_by(deleted_at = None).first()
                if result:
                    response.append({
                    'id':result.id,
                    'name':result.name,
                    'image':result.image,
                    'status':result.status,
                    'created_at':str(result.created_at),
                    'updated_at':str(result.updated_at),
                    'deleted_at':str(result.deleted_at)
                    })
            return_obj= {
                        'page': city_categories.page,
                        'total_pages': city_categories.pages,
                        'has_next_page': city_categories.has_next,
                        'has_prev_page': city_categories.has_prev,
                        'prev_page': city_categories.prev_num,
                        'next_page': city_categories.next_num,
                        'prev_page_url': ENDPOINT_PREFIX + url_for(f'api.Merchant Order_show_orders', page=city_categories.prev_num) if city_categories.has_prev else None,
                        'next_page_url': ENDPOINT_PREFIX + url_for(f'api.Merchant Order_show_orders', page=city_categories.next_num) if city_categories.has_next else None,
                        'current_page_url': None,
                        'items_per_page': city_categories.per_page,
                        'items_current_page': len(city_categories.items),
                        'total_items': city_categories.total,
                        'items': response
                    }
            apiResponce = ApiResponse(True, 'List of  Categories by City ' + city.name,
                                            return_obj, None)
            return (apiResponce.__dict__), 200
        
        else:
            apiResponce = ApiResponse(True, 'We dont Serve this City',None , None)
            return (apiResponce.__dict__), 200
    
    except Exception as e:
        apiResponce = ApiResponse(False,'Internal Server Error',"",str(e))
        return (apiResponce.__dict__), 500


def GetAllCategoryByCityName(data):
    try:
        city = City.query.filter_by(name=data['city_name']).first()


        if city:
            city_categories = CityCategories.query.filter_by(city_id = city.id).filter_by(deleted_at = None).all()
            response=[]
            for city_category in city_categories:
                result = Category.query.filter_by(id = city_category.category_id).filter_by(status = 1).filter_by(deleted_at = None).first()
                if result:
                    response.append({
                    'id':result.id,
                    'name':result.name,
                    'image':result.image,
                    'status':result.status,
                    'created_at':str(result.created_at),
                    'updated_at':str(result.updated_at),
                    'deleted_at':str(result.deleted_at)
                    })
            
            apiResponce = ApiResponse(True, 'List of  Categories by City ' + city.name,
                                            response, None)
            return (apiResponce.__dict__), 200
        
        else:
            apiResponce = ApiResponse(True, 'We dont Serve this City',None , None)
            return (apiResponce.__dict__), 200
    
    except Exception as e:
        apiResponce = ApiResponse(False,'Internal Server Error',"",str(e))
        return (apiResponce.__dict__), 500




def create_category(data):
    
    try:
        if data['image'] == "default":
                data['image'] = category_dir + "default.png"
            
        else:
            image_file, status = image_upload(data['image'],category_dir,data['name'])
        
            if status == 400:
                return image_file, status

            data['image'] = image_file

        category = Category(name=data['name'],
                            image=data['image'],
                            status=data['status'],
                            created_at=datetime.datetime.utcnow())
        save_db(category)

        # db.session.add(category)
        # db.session.commit()
        apiResponce = ApiResponse(True, 'Created Category Successfully',
                                    None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Category Not able to Create', None,
                            str(e))
        return (error.__dict__), 500


def update_category(data):
    try:
        category = Category.query.filter(
            Category.id == data['id'],
            Category.deleted_at == None).first()
        if category:
            if not len(data['name']) <= 50:
                apiResponce = ApiResponse(False,
                                        'Category not Updated',
                                        [], 'Category name must be less than 50 characters')
                return (apiResponce.__dict__), 400

            category.name = data['name']
                         
            category.updated_at = datetime.datetime.utcnow()

            save_db(category, 'Categories')
            

            apiResponce = ApiResponse(True,
                                        'Category Updated successfully',
                                        None, None)
            return (apiResponce.__dict__), 202
        else:
            error = ApiResponse(False, 'Category Not able to fetch', None,
                                "Invalid Category ID")
            return (error.__dict__), 400

    except Exception as e:
        error = ApiResponse(False, 'Category Not able to Update', None,
                            str(e))
        return (error.__dict__), 500

def update_category_image(data):
    try:
        
        category = Category.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not category:
            error = ApiResponse(False, 'Category Not able to fetch', None,
                                "Invalid Category ID")
            return (error.__dict__), 400
        
        image, status = image_save(request, category_dir)
        
        if status != 200:
            return image, status
        
        url, status = image_upload(image['data']['image'], category_dir, category.name)
        
        if status != 200:
            return image, status
        
        category.image = url
        category.updated_at = datetime.datetime.utcnow()
        save_db(category)
        
        return ApiResponse(True, "Category Image Updated successfully"), 200
    except Exception as e:
        error = ApiResponse(False, 'Category Not able to Update', None,
                            str(e))
        return (error.__dict__), 500
    
def show_category(data):
    try:

        page = 1
        items_per_page = 10
        try:
            page = int(data.get('page'))
        except Exception as e:
            pass

        try:
            items_per_page = int(data.get('items'))
        except Exception as e:
            pass
        
        if page < 1 :
            apiresponse = ApiResponse(False, "Page Number Can't be Negetive")
            return apiresponse.__dict__ , 400
        
        
        if items_per_page not in config.item_per_page:
            apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
            return apiresponse.__dict__, 400


        records = Category.query.filter(Category.deleted_at == None).order_by(Category.id).paginate(page, items_per_page, False)
        recordObject = []
        for record in records.items:
            response = {
                'id': record.id,
                'name': record.name,
                'image': record.image,
                'status': record.status,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        return_obj = {
                        'page': records.page,
                        'total_pages': records.pages,
                        'has_next_page': records.has_next,
                        'has_prev_page': records.has_prev,
                        'prev_page': records.prev_num,
                        'next_page': records.next_num,
                        'items_per_page': records.per_page,
                        'items_current_page': len(records.items),
                        'total_items': records.total,
                        'items': recordObject
                    }
        apiResponce = ApiResponse(True, 'List of All Categories',
                                    return_obj, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Category Not able to fetch', None,
                            str(e))
        return (error.__dict__), 500


def show_category_without_pagination():
    try:

        # page = 1
        # items_per_page = 10
        # try:
        #     page = int(data.get('page'))
        # except Exception as e:
        #     pass
        #
        # try:
        #     items_per_page = int(data.get('items'))
        # except Exception as e:
        #     pass
        #
        # if items_per_page not in config.item_per_page:
        #     apiresponse = ApiResponse(False, "Only 5, 10, 25, 50, 100 item per page allowed", None, None)
        #     return apiresponse.__dict__, 400


        records = Category.query.filter(Category.deleted_at == None).order_by(Category.id)
        recordObject = []
        for record in records:
            response = {
                'id': record.id,
                'name': record.name,
                'image': record.image,
                'status': record.status,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        return_obj = {
                        # 'page': records.page,
                        # 'total_pages': records.pages,
                        # 'has_next_page': records.has_next,
                        # 'has_prev_page': records.has_prev,
                        # 'prev_page': records.prev_num,
                        # 'next_page': records.next_num,
                        # 'items_per_page': records.per_page,
                        # 'items_current_page': len(records.items),
                        # 'total_items': records.total,
                        'items': recordObject
                    }
        apiResponce = ApiResponse(True, 'List of All Categories',
                                    recordObject, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Category Not able to fetch', None,
                            str(e))
        return (error.__dict__), 500





def show_all__category(data): 
    try:

        records = Category.query.filter(Category.deleted_at == None).filter_by(status = 1).order_by(Category.name).all()
        recordObject = []
        for record in records:
            response = {
                'id': record.id,
                'name': record.name,
                'image': record.image,
                'status': record.status,
                'created_at': str(record.created_at),
                'updated_at': str(record.updated_at),
            }
            recordObject.append(response)

        apiResponce = ApiResponse(True, 'List of All Categories',
                                    recordObject, None)
        return (apiResponce.__dict__), 200
    except Exception as e:
        error = ApiResponse(False, 'Category Not able to fetch', None,
                            str(e))
        return (error.__dict__), 500






def delete_category(data):
    
    try:
        category_menu_category_map = MenuCategory.query.filter(
            MenuCategory.category_id == data['id'],
            MenuCategory.deleted_at == None).first()

        if category_menu_category_map:
            error = ApiResponse(
                False, 'Delete Menu Categories First',
                None, 'Category has Menu Category Mapped delete them first')
            return (error.__dict__), 400

        else:
            category = Category.query.filter_by(id=data['id']).first()
            if category:

                if category.deleted_at != None:
                    apiResponce = ApiResponse(False, 'Category does not exists.',
                                          None, 'Given Category is Deleted')
                    return (apiResponce.__dict__), 400
    
                category.deleted_at = datetime.datetime.utcnow()

                save_db(category)
                # try:
                #     db.session.add(category)
                #     db.session.commit()
                #
                #     apiResponce = ApiResponse(True,
                #                             'Category Deleted Successfully',
                #                             None, None)
                #     return (apiResponce.__dict__), 201
                #
                # except Exception as e:
                #     db.session.rollback()
                #     apiResponce = ApiResponse(False,'Error Occurred',None,f"Catagory Database Error: {str(e)}")
                #     return (apiResponce.__dict__), 500
                #

            else:
                apiResponce = ApiResponse(False, 'Category does not exists.',
                                          None, 'Given Category is Wrong')
                return (apiResponce.__dict__), 400
    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500


def show_non_selected_category(data):
    try:
        city_id = data['city_id']

        city_categories = CityCategories.query.filter_by(deleted_at = None).filter_by(city_id = city_id).all()

        id = []    
        for city_category in city_categories:
            id.append(city_category.category_id)

        categories = Category.query.filter_by(deleted_at = None).filter_by(status = 1 ).filter_by(~Category.id.in_(id)).all()

        recordObject = []
        for category in categories:
            response = {
                'id': category.id,
                'name': category.name,
                'image': category.image,
            }
            recordObject.append(response)
        apiResponce = ApiResponse(True, 'List of All Categories',
                                    recordObject, None)
        return (apiResponce.__dict__), 200
        

    
    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500

def category_status_change(data):
    try:

        category = Category.query.filter_by(id = data['id']).filter_by(deleted_at = None).first()
        
        if not category:
            error = ApiResponse(
                False, 'No Category Found',
                None)
            return (error.__dict__), 400

        if data['status'] not in [0,1]:
            error = ApiResponse(
                False, 'Wrong Status Code Provided',
                None)
            return (error.__dict__), 400

        if data['status'] == 0:
            msg = "Category Disabled"
        
        else:
            msg = "Category Enabled"
        
        category.status = data['status']
        save_db(category, "Category")
        

        apiResponce = ApiResponse(True, msg,
                                    None, None)
        return (apiResponce.__dict__), 200

    except Exception as e:
        error = ApiResponse(False, 'Internal Server Error', None, str(e))
        return (error.__dict__), 500   