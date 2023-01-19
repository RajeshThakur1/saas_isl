from genericpath import exists
from app.main.model.admin import Admin
from app.main.model.apiResponse import ApiResponse
from functools import wraps
from flask import request
from app.main.config import key
from app.main.model.deliveryAssociate import DeliveryAssociate
from app.main.model.distributor import Distributor
from app.main.model.itemOrderLists import ItemOrderLists
from app.main.model.itemOrders import ItemOrder
from app.main.model.store import Store
from app.main.model.storeItemVariable import StoreItemVariable
from app.main.model.storeItems import StoreItem
from app.main.model.supervisor import Supervisor
from app.main.service.v1.auth_helper import Auth
from flask import jsonify
import jwt
from app.main.model.user import User
from app.main.model.superAdmin import SuperAdmin
from app.main.model.merchant import Merchant

portal_role_map = {
         'customer': User,
         'merchant': Merchant,
         'supervisor': Supervisor,
         'distributor': Distributor,
         'delivery_associate': DeliveryAssociate,
         'admin': Admin,
         'super_admin': SuperAdmin
      }


def token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      if token == None:
         return response, status
      
      role = token['role']
      if role != 'customer':
         response_object = ApiResponse(False, "Customer access Required", None, "User is not Customer")
         return response_object.__dict__, 403
      
      return f(*args, **kwargs)

   return decorated

def token_required_without_account_activation(f):
   @wraps(f)
   def decorated(*args, **kwargs):

      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      if token == None:
         return response, status
      
      role = token['role']
      if role != 'customer':
         response_object = ApiResponse(False, "Customer access Required", None, "User is not Customer")
         return response_object.__dict__, 403
      
      return f(*args, **kwargs)

   return decorated

def admin_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'admin':
         response_object = ApiResponse(False, "Admin access Required", None, "User is not admin")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def super_admin_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'super_admin':
         response_object = ApiResponse(False, "Admin access Required", None, "User is not admin")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated



def merchant_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'merchant':
         response_object = ApiResponse(False, "Merchant access Required", None, "User is not merchant")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def supervisor_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'supervisor':
         response_object = ApiResponse(False, "Supervisor access Required", None, "User is not Supervisor")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def distributor_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'distributor':
         response_object = ApiResponse(False, "Distributor access Required", None, "User is not Distributor")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def delivery_associate_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role != 'delivery_associate':
         response_object = ApiResponse(False, "Delivery Associate access Required", None, "User is not Delivery Associate")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def admin_superadmin_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      roles = ['admin', 'super_admin']
      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      if token == None:
         return response, status

      role = token['role']
      if role not in roles:
         response_object = ApiResponse(False, "User is not Authorized", None, "User is not admin or super_admin")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def admin_superadmin_merchant_supervisor_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):

      roles = ['admin', 'super_admin', 'supervisor', 'merchant']
      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      if token == None:
         return response, status

      role = token['role']
      if role not in roles:
         response_object = ApiResponse(False, "User is not Authorized", None, "User is not admin or super_admin")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated

def system_token_required(f):
   @wraps(f)
   def decorated(*args, **kwargs):

      roles = ['system']
      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      if not token == None:
         role = token['role']
         if role not in roles:
            response_object = ApiResponse(False, "Sender is not System", None, "Cron Jobs require System level Access")
            return response_object.__dict__, 403

         return f(*args, **kwargs)

      return response, status
   
   return decorated

def check_merchant_access(f):
   @wraps(f)
   def decorated(*args, **kwargs):

      response, status = Auth.get_logged_in_user(request)
      token = response.get('data')

      data=request.json

      if data == None:
         data = request.args

         if data == None:
            response_object = ApiResponse(False, "Something went wrong!", None, "Wrong use of @check_merchant_access decorator")
            return response_object.__dict__, 500
   

      if token == None:
         return response, status
      roles = ['merchant']
      id = token['id']
      role = token['role']
      stores = Store.query.filter_by(merchant_id=id).filter_by(deleted_at=None).all()

      flag=0
      for store in stores:
         try:
            store_id = data['store_id']
         except:

            try:
               store_item_id = data['store_item_id']

               store_id = StoreItem.query.filter_by(id=store_item_id).filter_by(deleted_at=None).first().store_id
            except:

               try:

                  store_item_variable_id = data['store_item_variable_id']

                  store_id = StoreItem.query.filter_by(id=StoreItemVariable.query.filter_by(id=store_item_variable_id).filter_by(deleted_at=None).first().store_item_id).filter_by(deleted_at=None).first().store_id

               except:

                  try:
                     item_order_id = data['item_order_id']

                     store_id = ItemOrder.query.filter_by(id=item_order_id).filter_by(deleted_at=None).first().store_id

                  except:

                     try:
                        item_order_variable_id = data['item_order_variable_id']

                        store_id  = ItemOrder.query.filter_by(id=ItemOrderLists.query.filter_by(id=item_order_variable_id).filter_by(deleted_at=None).first().item_order_id).filter_by(deleted_at=None).first().store_id
                     except:

                        response_object = ApiResponse(False, "Something went wrong!", None, "Wrong use of @check_merchant_access decorator")
                        return response_object.__dict__, 500

         if store_id == store.id:
            flag=1
            return f(*args, **kwargs)
      
      if flag == 0  and role in roles:
         response_object = ApiResponse(False, "Merchant does not have access here.", None, "Merchant id does not match.")
         return response_object.__dict__, 401

      
   
   return decorated



# def admin_superadmin_customer_token_required(f):
#    @wraps(f)
#    def decorated(*args, **kwargs):

#       roles = ['admin', 'super_admin', 'customer']
#       response, status = Auth.get_logged_in_user(request)
#       token = response.get('data')

#       if token == None:
#          return response, status

#       role = token['role']
#       if role not in roles:
#          response_object = ApiResponse(False, "User is not Authorized", None, "User is not admin or super_admin or customer")
#          return response_object.__dict__, 401

#       return f(*args, **kwargs)

#    return decorated

def admin_merchant_superadmin_token_required(f):
   @account_activation_required
   @wraps(f)
   def decorated(*args, **kwargs):
      
      roles = ['admin', 'super_admin', 'merchant']
      data, status = Auth.get_logged_in_user(request)
      token = data.get('data')

      if token == None:
         return data, status

      role = token['role']
      if role not in roles:
         response_object = ApiResponse(False, "User is not Authorized", None, "User is not admin or super_admin or merchant")
         return response_object.__dict__, 403

      return f(*args, **kwargs)

   return decorated



def account_activation_required(f):
   @wraps(f)
   def decorated(*args, **kwargs):
   
      data = request.json
      try:
         email = data['email']
      except:
         email = None
      try:
         role = data['login_request']
      except:
         role = None
      
      
      try:
         if not email:
            
            user, status = Auth.get_logged_in_user(request)

            
            if not user:
               response_object = ApiResponse(False, 'User email not specified', None, 'Email not specified')
               return response_object.__dict__, 400

            try:
               if user['success'] == False:
                  error = ApiResponse(False, user['message'], None, user['error'])
                  return error.__dict__, 400
            except:
               pass
            
            role = user['data']['role']
            id= user['data']['id']

            user_details = portal_role_map[role].query.filter_by(id=id).filter_by(deleted_at=None).filter(portal_role_map[role].email_verified_at!=None).filter(portal_role_map[role].phone_verified_at!=None).first()

            if user_details:
               return f(*args, **kwargs)


         if not role:
            role = 'customer'
            customer = portal_user = portal_role_map[role].query.filter_by(email=email).filter_by(deleted_at=None).filter(portal_role_map[role].email_verified_at!=None).filter(portal_role_map[role].phone_verified_at!=None).filter(portal_role_map[role].email_verified_at>=portal_role_map[role].created_at).filter(portal_role_map[role].phone_verified_at>=portal_role_map[role].created_at).first()

            if not customer:
               response_object = ApiResponse(False, "User is not verified", None, "User has not completed email or mobile verification")
               return response_object.__dict__, 403

            return f(*args, **kwargs)

         portal_user = portal_role_map[role].query.filter_by(email=email).filter_by(deleted_at=None).filter(portal_role_map[role].email_verified_at!=None).filter(portal_role_map[role].phone_verified_at!=None).filter(portal_role_map[role].email_verified_at>=portal_role_map[role].created_at).filter(portal_role_map[role].phone_verified_at>=portal_role_map[role].created_at).first()

         if not portal_user:
            response_object = ApiResponse(False, f"{str.capitalize(role)} account activation required.", None, "User has not completed email or mobile verification")
            return response_object.__dict__, 403

            
         return f(*args, **kwargs)
      except Exception as e:
         response_object = ApiResponse(False, 'Something went wrong!', None, str(e))
         return response_object.__dict__, 400
   
   return decorated






# def merchant_token_required(f):
#     @wraps(f)
#     def decorated(*args, **kwargs):

#         data, status = Auth.get_logged_in_user(request)
#         token = data.get('data')

#         if not token:
#             return data, status

#         merchant = token.get('merchant')
#         if not merchant:
#             response_object = {
#                 'status': 'fail',
#                 'message': 'merchant token required'
#             }
#             return response_object, 401

#         return f(*args, **kwargs)

#     return decorated

# def token_required(f):
#    @wraps(f)
#    def decorator(*args, **kwargs):

#       token = None

#       if 'Authorization' in request.headers:
#          print("shifuuf")
#          token = request.headers['Authorization']
#          print("shishir",token)

#       if not token:
#          return jsonify({'success':False,'data':None,'error':'token is missing','message': 'a valid token is missing'}),400

#       try:
#          print("jdvbhebv",key)
#          data = jwt.decode(token, key)
#          # print(data,"<<====")
#          print(data['sub'],"<<<<======<yasyavsyuvuyayuabyuabyubax")
#          current_user = User.query.filter_by(id=int(data['sub'])).first()

#       except:
#          return jsonify({'success':False,'data':None,'error':'provide valid token','message': 'token is invalid'}),400

#       return f(*args, **kwargs)
#    return decorator



# def token_required(f):  
#     @wraps(f)  
#     def decorator(*args, **kwargs):

#        token = None 

#        if 'Authorization' in request.headers:  
#           token = request.headers['Authorization'] 


#        if not token:  
#           return jsonify({'message': 'a valid token is missing'})   


#        try:  
#           data = jwt.decode(token, app.config[SECRET_KEY]) 
#           current_user = Users.query.filter_by(public_id=data['public_id']).first()  
#        except:  
#           return jsonify({'message': 'token is invalid'})  


#           return f(current_user, *args,  **kwargs)  
#     return decorator 

# def Merchent_token_required(f):
#    @wraps(f)
#    def decorator(*args, **kwargs):

#       token = None

#       if 'Authorization' in request.headers:
#          print("shifuuf")
#          token = request.headers['Authorization']
#          print("shishir",token)

#       if not token:
#          return jsonify({'success':False,'data':None,'error':'token is missing','message': 'a valid token is missing','code':'400'})

#       try:
#          print("jdvbhebv",key)
#          data = jwt.decode(token, key)
#          # print(data,"<<====")
#          print(data['sub'],"<<<<======<yasyavsyuvuyayuabyuabyubax")
#          current_user = Merchant.query.filter_by(id=int(data['sub'])).first()

#       except:
#          return jsonify({'success':False,'data':None,'error':'provide valid token','message': 'token is invalid','code':'400'})

#       return f(*args, **kwargs)
#    return decorator

#       return f(*args, **kwargs)
#    return decorator


# def SuperAdmin_token_required(f):
#    @wraps(f)
#    def decorator(*args, **kwargs):

#       token = None

#       if 'Authorization' in request.headers:
#          print("shifuuf")
#          token = request.headers['Authorization']
#          print("shishir",token)

#       if not token:
#          return jsonify({'success':False,'data':None,'error':'token is missing','message': 'a valid token is missing','code':'400'})

#       try:
#          print("jdvbhebv",key)
#          data = jwt.decode(token, key)
#          # print(data,"<<====")
#          print(data['sub'],"<<<<======<yasyavsyuvuyayuabyuabyubax")
#          current_user = SuperAdmin.query.filter_by(id=int(data['sub'])).first()

#       except:
#          return jsonify({'success':False,'data':None,'error':'provide valid token','message': 'token is invalid','code':'400'})

#       return f(*args, **kwargs)
#    return decorator

#       return f(*args, **kwargs)
#    return decorator





