from flask.globals import request
from flask_restx.resource import Resource
from app.main.service.v1.hub_service import get_hub_delivery_associates, show_all_hub, show_hub_by_slug


from app.main.util.v1.decorator import delivery_associate_token_required
from app.main.util.v1.delivery_associate_dto import HubDto


api = HubDto.api


@api.route('/')
class ShowHub(Resource):
    """
    Get list of hubs associated with the delivery associate
    """
    @api.doc("Get List of Hubs")
    @api.doc(security='api_key')
    @api.param(name='page', description='Page No')
    @api.param(name='item_per_page', description='Item Per Page')
    @api.param(name='query', description='Search Query')
    @delivery_associate_token_required
    def get(self):
        """Get List of Hubs"""
        return show_all_hub()


@api.route('/hub_details')
class GetHubBySlug(Resource):
    """
    Get details of a specific hub associated with the delivery associate
    """
    @api.doc("Get Hub Details")
    @api.doc(security='api_key')
    @api.expect(HubDto._get_hub, validate=True)
    @delivery_associate_token_required
    def post(self):
        """Get Hub Details"""
        data = request.json
        return show_hub_by_slug(data=data)


