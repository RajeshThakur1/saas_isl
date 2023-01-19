from flask.globals import request
from flask_restx.resource import Resource
from app.main.service.v1.hub_service import add_delivery_associate, add_hub_tax, create_hub, delete_hub, delete_hub_delivery_associate, delete_hub_tax, get_hub_delivery_associates, show_all_hub, show_hub_by_slug, show_hub_tax, update_hub_details, update_hub_image, update_hub_status, update_hub_tax
from app.main.util.v1.decorator import distributor_token_required
from app.main.util.v1.distributor_dto import HubDto
from app.main.service.v1.image_service import image_save, profle_pic_image_save
from app.main.config import hub_dir 

api = HubDto.api
_create_hub = HubDto.create_hub
_get_hub = HubDto.get_hub
_delete_hub = HubDto.delete_hub
_update_hub_details = HubDto.update_hub_details
_update_hub_image = HubDto.update_hub_image
_update_hub_status = HubDto.update_hub_status
_image_upload = HubDto.image_upload
_add_hub_tax = HubDto.add_hub_tax
_update_hub_tax = HubDto.update_hub_tax
_delete_hub_tax = HubDto.delete_hub_tax
_show_hub_tax = HubDto.show_hub_tax
_add_da = HubDto.add_da
_delete_da = HubDto.delete_da
_get_da = HubDto.get_da

@api.route('/create')
class HubCreate(Resource):
    @api.doc("Creates a new Hub By Distributor")
    @api.doc(security='api_key')
    @api.expect(_create_hub, validate=True)
    @distributor_token_required
    def post(self):
        """Creates a new Hub By Distributor"""
        data = request.json
        return create_hub(data=data)

@api.route('/')
class ShowHub(Resource):
    @api.doc("Get List of Hubs")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page No')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='query', description='Search Query')
    @distributor_token_required
    def get(self):
        """Get List of Hubs"""
        return show_all_hub()

@api.route('/hub_details')
class GetHubBySlug(Resource):
    @api.doc("Get Hub Details")
    @api.doc(security='api_key')
    @api.expect(_get_hub, validate=True)
    @distributor_token_required
    def post(self):
        """Get Hub Details"""
        data = request.json
        return show_hub_by_slug(data=data)

@api.route('/delete_hub')
class DeleteHub(Resource):
    @api.doc("Delete Hub")
    @api.doc(security='api_key')
    @api.expect(_delete_hub, validate=True)
    @distributor_token_required
    def post(self):
        """Delete Hub"""
        data = request.json
        return delete_hub(data=data)

@api.route('/update')
class UpdateHub(Resource):
    @api.doc("Update Hub Details")
    @api.doc(security='api_key')
    @api.expect(_update_hub_details, validate=True)
    @distributor_token_required
    def post(self):
        """Update Hub Details"""
        data = request.json
        return update_hub_details(data=data)

@api.route('/update_hub_image')
class HubPic(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Hub Image Upload')
    @api.doc(security='api_key')
    @api.expect(_update_hub_image)
    @distributor_token_required
    def post(self):
        """Hub Pic Upload"""
        data = _update_hub_image.parse_args()
        return update_hub_image(data)
    
@api.route('/status_change')
class HubStatusChange(Resource):
    @api.doc("Update Hub Status")
    @api.doc(security='api_key')
    @api.expect(_update_hub_status, validate=True)
    @distributor_token_required
    def post(self):
        """Update Hub Status"""
        data = request.json
        return update_hub_status(data=data)

@api.route('/image_upload')
class HubImageUpload(Resource):
    @api.response(201, 'Image Uploaded Successfully')
    @api.response(413, 'Image Size is Too Large')
    @api.doc('Hub item Image Upload')
    @api.doc(security='api_key')
    @api.expect(_image_upload)
    @distributor_token_required
    def post(self):
        """Hub item Image Upload"""
        return image_save(request, hub_dir)

@api.route('/hub_taxes/create')
class HubTaxesCreate(Resource):
    @api.response(201, 'New hub Tax Added Successfully')
    @api.doc(security='api_key')
    @api.doc('Create new hub tax')
    @api.expect(_add_hub_tax, validate=True)
    @distributor_token_required
    def post(self):
        """Create new hub tax"""
        data = request.json
        return add_hub_tax(data=data)


@api.route('/hub_taxes/update')
class HubTaxesUpdate(Resource):
    @api.response(201, 'hub Tax Updated Successfully')
    @api.doc(security='api_key')
    @api.doc('Update hub tax')
    @api.expect(_update_hub_tax, validate=True)
    @distributor_token_required
    def post(self):
        """Update hub tax"""
        data = request.json
        return update_hub_tax(data=data)


@api.route('/hub_taxes/delete')
class HubTaxesDelete(Resource):
    @api.response(201, 'hub Tax Deleted Successfully')
    @api.doc(security='api_key')
    @api.doc('Delete hub tax')
    @api.expect(_delete_hub_tax, validate=True)
    @distributor_token_required
    def post(self):
        """Delete hub tax"""
        data = request.json
        return delete_hub_tax(data=data)


@api.route('/hub_taxes/')
class HubTaxesShow(Resource):
    @api.response(201, 'Tax Details Fetched')
    @api.doc(security='api_key')
    @api.doc('Fetch hub tax')
    @api.expect(_show_hub_tax, validate=True)
    @distributor_token_required
    def post(self):
        """Fetch hub tax"""
        data = request.json
        return show_hub_tax(data=data)
        
@api.route('/deliver_associate/add')
class AddDeliveryAssociate(Resource):
    @api.doc(security='api_key')
    @api.doc('Add DeliveryAssociate')
    @api.expect(_add_da, validate=True)
    @distributor_token_required
    def post(self):
        """Add DeliveryAssociate"""
        data = request.json
        return add_delivery_associate(data=data)

@api.route('/deliver_associate/')
class GetAllDeliveryAssociates(Resource):
    @api.doc(security='api_key')
    @api.doc('Get All Delivery Associates')
    @api.expect(_get_da, validate=True)
    @distributor_token_required
    def post(self):
        """Get All Delivery Associates"""
        data = request.json
        return get_hub_delivery_associates(data)

# @api.route('/deliver_associate/select')
# class SelectDeliveryAssociate(Resource):
#     @api.doc(security='api_key')
#     @api.doc('Select Delivery Associate')
#     @api.expect(_select_da, validate=True)
#     @distributor_token_required
#     def post(self):
#         """Select Delivery Associate"""
#         data = request.json
#         return select_hub_delivery_associate(data=data)

@api.route('/deliver_associate/delete')
class DeleteDeliveryAssociates(Resource):
    @api.doc(security='api_key')
    @api.doc('Delete Delivery Associates')
    @api.expect(_delete_da, validate=True)
    @distributor_token_required
    def post(self):
        """Delete Delivery Associates"""
        data = request.json
        return delete_hub_delivery_associate(data=data)