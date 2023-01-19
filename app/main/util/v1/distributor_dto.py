from flask_restx import Namespace, fields
from werkzeug.datastructures import FileStorage

from app.main.service.v1.hub_service import update_hub_details, update_hub_status

class DistributorDto:

    api = Namespace('Distributor Profile',
                    description='Distributor related operations')

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
    api = Namespace('Distributor Manage Hub',description = 'Hub related operations')

    create_hub = api.model('create_hub',{
        'name':
        fields.String(required=True, description='Name'),
        'image':
        fields.String(required=True, description='Image URL'),
        'address_line_1':
        fields.String(required=True, description='Address 1'),
        'address_line_2':
        fields.String(description='Address 2'),
        'hub_latitude':
        fields.Float(required=True, description='Latitude'),
        'hub_longitude':
        fields.Float(required=True, description='Longitude'),
        'radius':
        fields.Integer(required=True, description='Radius'),
        'city_name':
        fields.String(required=True,
                        description='City name'),
        'delivery_associate_name': 
        fields.String(required=True,
                        description='Delivery Associate name'),
        'delivery_associate_email': 
        fields.String(required=True,
                        description='Delivery Associate email'),
        'delivery_associate_phone': 
        fields.String(required=True,
                        description='Delivery Associate phone')
    })

    get_hub = api.model("get_hub",{
        'slug':fields.String(required=True, description='slug')
    })

    delete_hub = api.model("delete_hub",{
        'slug':fields.String(required=True, description='slug')
    })

    update_hub_details = api.model("update_hub_details",{
        'slug':fields.String(required=True, description='slug'),
        'name':
        fields.String(required=True, description='Name'),
        'address_line_1':
        fields.String(required=True, description='Address 1'),
        'address_line_2':
        fields.String(description='Address 2'),
        'hub_latitude':
        fields.Float(required=True, description='Latitude'),
        'hub_longitude':
        fields.Float(required=True, description='Longitude'),
        'radius':
        fields.Integer(required=True, description='Radius'),
        'city_name':
        fields.String(required=True,
                        description='City name'), 
    })
    
    update_hub_image = api.parser()
    update_hub_image.add_argument('image', type=FileStorage, location='files', required=True)
    update_hub_image.add_argument('slug', type=str, required=True)

    update_hub_status = api.model("update_hub_status",{
        'slug':fields.String(required=True, description='slug'),
        'status':fields.Integer(required=True, description='status code')
    })

    image_upload = api.parser()
    image_upload.add_argument('image', type=FileStorage, location='files')

    add_hub_tax = api.model(
        'add_hub_tax', {
            'hub_slug': fields.String(required=True, description='hub Id'),
            'name': fields.String(required=True, description="Tax Name"),
            'description': fields.String(required=False, description="Tax Description"),
            'tax_type': fields.Integer(required=True, description="Tax type Percentage or Flat"),
            'amount': fields.Float(required=True, description="Tax Ammount")
        }
    )

    update_hub_tax = api.model(
        'update_hub_tax', {
            'id': fields.Integer(required=True, description='hub Id'),
            'name': fields.String(required=True, description="Tax Name"),
            'description': fields.String(required=False, description="Tax Description"),
            'tax_type': fields.Integer(required=True, description="Tax type Percentage or Flat"),
            'amount': fields.Float(required=True, description="Tax Ammount")
        }
    )

    delete_hub_tax = api.model(
        'delete_hub_tax', {
            'id': fields.Integer(required=True, description='hub Id'),
        }
    )

    show_hub_tax = api.model(
        'show_hub_tax', {
            'slug': fields.String(required=True, description='hub Id'),
        }
    )

    add_da = api.model('add_da',{
        'slug':
        fields.String(required=True, description='slug'),
        'delivery_associate_name': 
        fields.String(required=True,
                        description='Delivery Associate name'),
        'delivery_associate_email': 
        fields.String(required=True,
                        description='Delivery Associate email'),
        'delivery_associate_password': 
        fields.String(required=True,
                        description='Delivery Associate password'),
        'delivery_associate_phone': 
        fields.String(required=True,
                        description='Delivery Associate phone')
    })

    get_da = api.model('get_da',{
        'slug':
        fields.String(required=True, description='slug'),
    })

    get_selected_da = api.model('get_selected_da',{
        'slug':
        fields.String(required=True, description='slug'),
    })

    select_da = api.model('select_da',{
        'slug':
        fields.String(required=True, description='slug'),
        'delivery_associate_id': 
        fields.Integer(required=True,
                        description='Delivery Associate ID')
    
    })

    delete_da = api.model('delete_da',{
        'slug':
        fields.String(required=True, description='slug'),
        'delivery_associate_id': 
        fields.Integer(required=True,
                        description='Delivery Associate ID')
    
    })

class HubBankDetailsDto:
    api = Namespace('Distributor Hub Bank Details',
                    description='Hub Bank Details related operations')
    get_bank_details = api.model('get_bank_details', {
        'hub_slug':
            fields.String(required=True, description='Hub slug')
    })
    add_hub_bank_details = api.model(
        'add_hub_bank_details', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'hub_slug':
            fields.String(required=True, description='Hub slug'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number')

        })
    update_hub_bank_details = api.model(
        'update_hub_bank_details', {
            'beneficiary_name':
            fields.String(required=True, description='beneficiary_name'),
            'name_of_bank':
            fields.String(required=True, description='name_of_bank'),
            'ifsc_code':
            fields.String(required=True, description='ifsc_code'),
            'hub_slug':
            fields.String(required=True, description='Hub slug'),
            'vpa':
            fields.String(required=True, description='vpa'),
            'account_number':
            fields.String(required=True, description='Account Number'),
            'id':
            fields.Integer(required=True, description='Bank details ID')

        })
    delete_hub_bank_details = api.model(
        'delete_hub_bank_details',
        {'id': fields.Integer(required=True, description='id'),
         'hub_slug':
            fields.String(required=True, description='Hub slug')})

    confirm_update = api.model(
        'confirm_update', {
            'hub_slug':
            fields.String(required=True, description='Hub slug'),
            'status': fields.Integer(required=True, description="Accept = 1, Reject = 0"),
            'id': fields.Integer(required=True, description="id")
        }
    )

class QuantityUnitDto:
    api = Namespace('Distributor Quantity Unit',
                    description='Quantity related operations')

class HubOrderDto:
    api = Namespace('Distributor Orders', description='Order Related Operation')

    update_order_quantity = api.model(
        'update_order_quantity_delivery_associate',
        {
            "hub_order_list_id": fields.Integer(required=True, description='hub Order List ID'),
            "hub_order_id": fields.Integer(required=True, description='hub Order ID'),
            "quantity": fields.Integer(required=True, description='If Action == 1: Quantity to remove.')
        }
    )

    update_order_price = api.model(
        'update_order_price_delivery_associate',
        {
            "hub_order_list_id": fields.Integer(required=True, description='hub Order List ID'),
            "hub_order_id": fields.Integer(required=True, description='hub Order ID'),
            "selling_price": fields.Float(required=True, description='Selling Price'),
            "mrp" : fields.Float(required=True, description='MRP')
        }
    )


    accept_order = api.model(
        'accept_order_delivery_associate', {
            "hub_order_id": fields.Integer(required=True, description='hub Order ID')
        }
    )
    order_details = api.model("order_details_delivery_associate", {
        'hub_order_id': fields.Integer(required=True, description='order id')
    })

    reject_order = api.model("reject_order_delivery_associate", {
        'hub_order_id': fields.Integer(required=True, description='order id')
    })

    assign_to_da = api.model("assign_to_da_delivery_associate", {
        'da_id': fields.Integer(required = True, description = "da id"),
        'hub_order_id': fields.Integer(required=True, description="order id")
    })

    cancel_order = api.model("cancel_order_delivery_associate", {
        "hub_order_id": fields.Integer(required=True, description='order id')
    })

    picked_up_order = api.model("picked_up_order_delivery_associate", {
        "hub_order_id": fields.Integer(required=True, description='order id')
    })

    deliver_order = api.model("deliver_order_delivery_associate", {
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
    api = Namespace('Distributor Dashboard',
                    description='Dashboard Related Operations')

