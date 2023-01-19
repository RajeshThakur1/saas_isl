from flask_restx import Api
from flask import Blueprint


#System related controllers
from app.main.controller.v1.system.cron_controller import api as cron_ns

# user related controllers
from .main.controller.v1.user.user_controller import api as user_ns
from .main.controller.v1.user.cart_controller import api as user_cart_ns
from .main.controller.v1.user.address_controller import api as address_ns
from .main.controller.v1.user.order_controller import api as order_ns
from .main.controller.v1.user.store_controller import api as user_store_ns
from .main.controller.v1.user.category_controller import api as user_category_ns
from .main.controller.v1.user.coupon_controller import api as user_coupon_ns

# merchant related controllers
from .main.controller.v1.merchant.merchant_controller import api as merchant_ns
from .main.controller.v1.merchant.store_controller import api as merchant_store_ns
from .main.controller.v1.merchant.store_item_controller import api as mechant_store_item_ns
from .main.controller.v1.merchant.menu_category_controller import api as merchant_menu_category_ns
from .main.controller.v1.merchant.quantity_controller import api as merchant_quantity_ns
from app.main.controller.v1.merchant.order_controller import api as merchant_order_ns
from .main.controller.v1.merchant.coupon_controller import api as merchant_coupon_ns
from app.main.controller.v1.merchant.dashboard_controller import api as merchant_dashboard_ns
from app.main.controller.v1.merchant.cart_controller import api as merchant_cart_ns
from app.main.controller.v1.merchant.delivery_agent_controller import api as merchant_da_ns
from app.main.controller.v1.merchant.hub_order_controller import api as merchant_hub_order_ns
from app.main.controller.v1.merchant.hub_cart_controller import api as merchant_hub_cart_ns
from app.main.controller.v1.merchant.store_payment_controller import api as merchant_store_payment_ns

# from .main.controller.v1.merchant.coupon_controller import api as merchant_coupon_ns



from .main.controller.v1.merchant.store_bankdetails_controller import api as merchant_store_bankdetails_ns

# superadmin related controllers
from .main.controller.v1.superadmin.store_controller import api as superadmin_store_ns
from .main.controller.v1.superadmin.city_controller import api as superadmin_city_ns
from .main.controller.v1.superadmin.locality_controller import api as superadmin_locality_ns
from .main.controller.v1.superadmin.store_item_controller import api as superadmin_store_item_ns
from .main.controller.v1.superadmin.coupon_controller import api as superadmin_coupon_ns
from .main.controller.v1.superadmin.category_controller import api as superadmin_category_ns
from .main.controller.v1.superadmin.menu_category_controller import api as superadmin_menu_category_ns
from .main.controller.v1.superadmin.quantity_controller import api as superadmin_quantity_ns
from .main.controller.v1.superadmin.user_controller import api as superadmin_store_user_ns
from .main.controller.v1.superadmin.order_controller import api as superadmin_order_ns
from .main.controller.v1.superadmin.dashboard_controller import api as superadmin_dashboard_ns
from .main.controller.v1.superadmin.delivery_agent_controller import api as superadmin_delivery_agent_ns
from app.main.controller.v1.superadmin.store_bankdetails_controller import api as superadmin_store_bankdetails_ns
from app.main.controller.v1.superadmin.hub_controller import api as superadmin_hub_ns
from app.main.controller.v1.superadmin.hub_bank_details_controller import api as superadmin_hub_bank_details_ns
from app.main.controller.v1.superadmin.hub_order_controller import api as superadmin_hub_order_ns
from app.main.controller.v1.superadmin.super_admin_controller import api as super_admin_controller_ns
from app.main.controller.v1.superadmin.otp_controller import api as superadmin_otp_controller_ns
from app.main.controller.v1.superadmin.store_payment_controller import api as super_admin_store_payment_ns
# admin related controllers
# from .main.controller.v1.admin.city_controller import api as admin_city_ns
# from .main.controller.v1.admin.locality_controller import api as admin_locality_ns

#download related controllers
from .main.controller.v1.download.download_controler import api as download_ns
# auth related controllers
from .main.controller.v1.auth.auth_controller import api as auth_ns

#Supervisor Related Controllers
from app.main.controller.v1.supervisor.order_controller import api as supervisor_order_ns
from app.main.controller.v1.supervisor.category_controller import api as supervisor_category_ns
from app.main.controller.v1.supervisor.location_controller import api as supervisor_location_ns
from app.main.controller.v1.supervisor.store_controler import api as supervisor_store_ns
from app.main.controller.v1.supervisor.dashboard_controller import api as supervisor_dashboard_ns
from app.main.controller.v1.supervisor.menu_category_controller import api as supervisor_menu_category_ns
from app.main.controller.v1.supervisor.quantity_controller import api as supervisor_quantity_ns
from app.main.controller.v1.supervisor.store_bankdetails_controller import api as supervisor_store_bankdetails_ns
from app.main.controller.v1.supervisor.supervisor_controller import api as supervisor_ns
from app.main.controller.v1.supervisor.coupon_controller import api as supervisor_coupon_ns
from app.main.controller.v1.supervisor.hub_order_controller import api as supervisor_hub_order_ns
from app.main.controller.v1.supervisor.hub_controller import api as supervisor_hub_ns
from app.main.controller.v1.supervisor.hub_bank_details_controller import api as supervisor_hub_bank_details_ns
from app.main.controller.v1.supervisor.store_payment_controller import api as supervisor_store_payment_ns
#Common Operations
from app.main.controller.v1.common.common_controller import api as common_ns 

#Distributors
from app.main.controller.v1.distributor.distributor_controller import api as distributor_ns
from app.main.controller.v1.distributor.hub_controller import api as distributor_hub_ns
from app.main.controller.v1.distributor.hub_bank_details_controller import api as distributor_hub_bank_details_ns
from app.main.controller.v1.distributor.quantity_controller import api as distributor_quantity_ns
from app.main.controller.v1.distributor.order_controller import api as distributor_order_ns
from app.main.controller.v1.distributor.dashboard_controller import api as distributor_dashboard_ns

#DeliveryAssociates
from app.main.controller.v1.delivery_associate.dashboard_controller import api as da_dashboard_ns
from app.main.controller.v1.delivery_associate.hub_controller import api as da_hub_ns
from app.main.controller.v1.delivery_associate.hub_order_controller import api as da_hub_order_ns
from app.main.controller.v1.delivery_associate.quantity_controller import api as da_quantity_ns
from app.main.controller.v1.delivery_associate.delivery_associate_controller import api as da_ns

from app.main.config import version

blueprint = Blueprint('api', __name__)

api = Api(blueprint, title='DOT', description='Apis')


# login APIs
api.add_namespace(auth_ns, path = version('/auth'))

# End user related APIS
api.add_namespace(user_ns, path=version('/user'))
api.add_namespace(user_cart_ns, path=version('/user/cart'))
api.add_namespace(address_ns,path=version('/user/address'))
api.add_namespace(order_ns, path=version('/user/order'))
api.add_namespace(user_store_ns, path=version('/user/store'))
api.add_namespace(user_category_ns, path=version('/user/category'))
api.add_namespace(user_coupon_ns, path=version('/user/coupon'))

# Merchant related APIS
api.add_namespace(merchant_ns, path=version('/merchant'))
api.add_namespace(merchant_store_ns, path=version('/merchant/store'))
api.add_namespace(merchant_quantity_ns, path=version('/merchant/quantity'))
api.add_namespace(merchant_menu_category_ns, path=version('/merchant/menucategory'))
api.add_namespace(mechant_store_item_ns, path=version('/merchant/store_item'))
api.add_namespace(merchant_coupon_ns, path=version('/merchant/coupon'))
api.add_namespace(merchant_store_bankdetails_ns, path=version('/merchant/store_bankdetails'))
api.add_namespace(merchant_order_ns, path=version('/merchant/order'))
api.add_namespace(merchant_dashboard_ns, path=version('/merchant/dashboard'))
api.add_namespace(merchant_cart_ns, path=version('/merchant/cart'))
api.add_namespace(merchant_da_ns, path=version('/merchant/delivery_agent'))
api.add_namespace(merchant_hub_order_ns, path=version('/merchant/hub_order'))
api.add_namespace(merchant_hub_cart_ns, path=version('/merchant/hub_cart'))
api.add_namespace(merchant_store_payment_ns, path = version('/merchant/storepayments'))
# Admin related APIS
# api.add_namespace(admin_city_ns, path=version('/admin/city')
# api.add_namespace(admin_locality_ns, path=version('/admin/locality')

# Superadmin related APIS
api.add_namespace(superadmin_city_ns, path=version('/superadmin/city'))
api.add_namespace(superadmin_locality_ns, path=version('/superadmin/locality'))
api.add_namespace(superadmin_store_ns, path=version('/superadmin/store'))
api.add_namespace(superadmin_quantity_ns, path=version('/superadmin/quantity'))
api.add_namespace(superadmin_category_ns, path=version('/superadmin/category'))
api.add_namespace(superadmin_menu_category_ns, path=version('/menucategory'))
api.add_namespace(superadmin_coupon_ns, path=version('/superadmin/coupon'))
api.add_namespace(superadmin_store_item_ns, path=version('/superadmin/store_item'))
api.add_namespace(superadmin_store_user_ns, path=version('/superadmin/store_user'))
api.add_namespace(superadmin_order_ns, path=version('/superadmin/order' ))
api.add_namespace(superadmin_dashboard_ns, path=version('/superadmin/dashboard' ))
api.add_namespace(superadmin_delivery_agent_ns, path=version('/superadmin/delivery_agent' ))
api.add_namespace(superadmin_store_bankdetails_ns, path = version('/superadmin/store_bankdetails'))
api.add_namespace(superadmin_hub_ns, path = version('/superadmin/hub'))
api.add_namespace(superadmin_hub_bank_details_ns, path = version('/superadmin/hub_bank_details'))
api.add_namespace(superadmin_hub_order_ns, path = version('/superadmin/hub_order'))
api.add_namespace(super_admin_controller_ns, path = version('/superadmin/profile'))
api.add_namespace(super_admin_store_payment_ns, path = version('/superadmin/storepayments'))
#super_admin_controller_ns

#Common Operation
api.add_namespace(common_ns, path=version('/public' ))

#download related apis
api.add_namespace(download_ns, path = version('/download'))


#System Reserved Namespaces
api.add_namespace(cron_ns, path=version('/system'))

#Supervisor Related APIs
api.add_namespace(supervisor_order_ns, path=version('/supervisor/order'))
api.add_namespace(supervisor_location_ns, path=version('/supervisor/location'))
api.add_namespace(supervisor_store_ns, path = version('/supervisor/store'))

# api.add_namespace(supervisor_item_ns, path=version('/supervisor/store_items')
api.add_namespace(supervisor_dashboard_ns, path = version('/supervisor/dashboard'))
api.add_namespace(supervisor_menu_category_ns, path = version('/supervisor/menu_category'))
api.add_namespace(supervisor_quantity_ns, path = version('/supervisor/quantity'))
api.add_namespace(supervisor_store_bankdetails_ns, path = version('/supervisor/store_bankdetails'))
api.add_namespace(supervisor_ns, path =version('/supervisor/profile'))
api.add_namespace(supervisor_coupon_ns, path=version('/supervisor/coupon'))
api.add_namespace(supervisor_category_ns, path=version('/supervisor/category'))
api.add_namespace(supervisor_hub_order_ns, path=version('/supervisor/hub_order'))
api.add_namespace(supervisor_hub_ns, path=version('/supervisor/hub'))
api.add_namespace(supervisor_hub_bank_details_ns, path=version('/supervisor/hub_bank_details'))
api.add_namespace(supervisor_store_payment_ns, path = version('/supervisor/storepayments'))


#Distributor
api.add_namespace(distributor_ns, path=version('/distributor/profile'))
api.add_namespace(distributor_hub_ns, path=version('/distributor/hub'))
api.add_namespace(distributor_hub_bank_details_ns, path=version('/distributor/hub_bank_details'))
api.add_namespace(distributor_quantity_ns, path=version('/distributor/quantity'))
api.add_namespace(distributor_order_ns, path=version('/distributor/order'))
api.add_namespace(distributor_dashboard_ns, path=version('/distributor/dashboard'))

#DeliveryAssociate
api.add_namespace(da_ns, path=version('/delivery_associate/profile'))
api.add_namespace(da_hub_ns, path=version('/delivery_associate/hub'))
api.add_namespace(da_quantity_ns, path=version('/delivery_associate/quantity'))
api.add_namespace(da_hub_order_ns, path=version('/delivery_associate/order'))
api.add_namespace(da_dashboard_ns, path=version('/delivery_associate/dashboard'))