from flask_restx import Namespace, fields
from werkzeug.datastructures import FileStorage

from app.main.service.v1.hub_service import update_hub_details, update_hub_status

class DeliveryAssociateDto:

    api = Namespace('Delivery Associate Profile',
                    description='Delivery Associate related operations')

    change_password = api.model("change_password", {
        'old_password': fields.String(required=True, description="Old password"),
        'new_password': fields.String(required=True, description="New password")

    })

    update_name = api.model("update_name", {
        'name': fields.String(required=True, description="Name"),
        'password': fields.String(required=True, description="Password")
    })


    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

class HubDto:
    api = Namespace('Delivery Associate Manage Hub',description = 'Hub related operations')

    
    _get_hub = api.model("get_hub",{
        'slug':fields.String(required=True, description='slug')
    })

    
    get_selected_da = api.model('get_selected_da',{
        'slug':
        fields.String(required=True, description='slug'),
    })

    

class QuantityUnitDto:
    api = Namespace('Delivery Associate Quantity Unit',
                    description='Quantity related operations')

class HubOrderDto:
    api = Namespace('Delivery Associate Orders', description='Order Related Operation')

   
    _order_details = api.model("order_details_deliver_associate", {
        'hub_order_id': fields.Integer(required=True, description='order id')
    })

    

    _picked_up_order = api.model("picked_up_order_deliver_associate", {
        "hub_order_id": fields.Integer(required=True, description='order id')
    })

    _deliver_order = api.model("deliver_order_deliver_associate", {
        "hub_order_id": fields.Integer(required=True, description='order id')
    })

    add_payment = api.model("add_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
        "amount": fields.Float(required=True, description='Payment Amount'),
        "payment_date": fields.Date(required=True, description="Payment Date")
    })
    
    get_payment = api.model("get_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
    })

    update_payment = api.model("update_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
        'payment_id' : fields.Integer(required=True, description="payment_id"),
        "amount": fields.Float(required=True, description='Payment Amount'),
        "payment_date": fields.Date(required=True, description="Payment Date")
    })

    delete_payment = api.model("delete_payment", {
        "hub_order_id": fields.Integer(required=True, description='order id'),
        'payment_id' : fields.Integer(required=True, description="payment_id"),
    })
    

class DashboardDto:
    api = Namespace('Delivery Associate Dashboard',
                    description='Dashboard Related Operations')

