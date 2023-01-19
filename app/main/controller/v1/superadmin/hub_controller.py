from flask.globals import request
from flask_restx.resource import Resource
from app.main.service.v1.hub_service import create_hub, delete_hub, get_hub_delivery_associates, distributor_dropdown, show_all_hub, show_hub_by_slug, show_hub_tax, update_hub_details, update_hub_image, update_hub_status
from app.main.service.v1.image_service import image_save
from app.main.util.v1.decorator import distributor_token_required, super_admin_token_required
from app.main.util.v1.superadmin_dto import HubDto
from app.main.config import hub_dir

api = HubDto.api
_create_hub = HubDto.create_hub_superadmin
_get_hub = HubDto.get_hub
_delete_hub = HubDto.delete_hub
_update_hub_details = HubDto.update_hub_details
_update_hub_image = HubDto.update_hub_image
_image_upload = HubDto.image_upload
_update_hub_status = HubDto.update_hub_status
_show_hub_tax = HubDto.show_hub_tax
_get_all_da = HubDto.get_all_da

@api.route('/create')
class HubCreate(Resource):
    @api.doc("Creates a new Hub By Super Admin")
    @api.doc(security='api_key')
    @api.expect(_create_hub, validate=True)
    @super_admin_token_required
    def post(self):
        """Creates a new Hub By Super Admin"""
        data = request.json
        return create_hub(data=data)

@api.route('/')
class ShowHub(Resource):
    @api.doc("Get List of Hubs")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page No')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='query', description='Search Query')
    @super_admin_token_required
    def get(self):
        """Get List of Hubs"""
        return show_all_hub()

@api.route('/hub_details')
class GetHubBySlug(Resource):
    @api.doc("Get Hub Details")
    @api.doc(security='api_key')
    @api.expect(_get_hub, validate=True)
    @super_admin_token_required
    def post(self):
        """Get Hub Details"""
        data = request.json
        return show_hub_by_slug(data=data)

@api.route('/delete_hub')
class DeleteHub(Resource):
    @api.doc("Delete Hub")
    @api.doc(security='api_key')
    @api.expect(_delete_hub, validate=True)
    @super_admin_token_required
    def post(self):
        """Delete Hub"""
        data = request.json
        return delete_hub(data=data)

@api.route('/update')
class UpdateHub(Resource):
    @api.doc("Update Hub Details")
    @api.doc(security='api_key')
    @api.expect(_update_hub_details, validate=True)
    @super_admin_token_required
    def post(self):
        """Update Hub Details"""
        data = request.json
        return update_hub_details(data=data)
@api.route('/status_change')
class StatusChange(Resource):
    @api.doc("Update Hub Status")
    @api.doc(security='api_key')
    @api.expect(_update_hub_status, validate=True)
    @super_admin_token_required
    def post(self):
        """Update Hub Status"""
        data = request.json
        return update_hub_status(data=data) 

@api.route('/distributor_list')
class DistributorList(Resource):
    @api.doc("Get Distributor List")
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Get Distributor List"""
        return distributor_dropdown()

@api.route('/hub_taxes/')
class HubTaxesShow(Resource):
    @api.response(201, 'Tax Details Fetched')
    @api.doc(security='api_key')
    @api.doc('Fetch hub tax')
    @api.expect(_show_hub_tax, validate=True)
    @super_admin_token_required
    def post(self):
        """Fetch hub tax"""
        data = request.json
        return show_hub_tax(data=data)


@api.route('/deliver_associate/')
class GetSelectedDeliveryAssociate(Resource):
    @api.doc(security='api_key')
    @api.doc('Get Selected DeliveryAssociate')
    @api.expect(_get_all_da, validate=True)
    @super_admin_token_required
    def post(self):
        """'Get Selected DeliveryAssociate"""
        data = request.json
        return get_hub_delivery_associates(data=data)
    
@api.route('/update_hub_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Hub Image Upload')
    @api.doc(security='api_key')
    @api.expect(_update_hub_image)
    @super_admin_token_required
    def post(self):
        """Hub Pic Upload"""
        data = _update_hub_image.parse_args()
        return update_hub_image(data)
    

@api.route('/image_upload')
class HubImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Hub item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @super_admin_token_required
    def post(self):
        """Hub item Image Upload"""
        return image_save(request, hub_dir)