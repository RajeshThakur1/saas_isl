from flask_restx import Resource
from flask import request
from app.main.util.v1.superadmin_dto import DeliveryAgentDto
from app.main.service.v1.delivery_service import delete_delivery_agent, delivery_agent_status_change, get_delivery_agents,add_delivery_agent, update_delivery_agent
from app.main.util.v1.decorator import super_admin_token_required

api = DeliveryAgentDto.api
_add_agent = DeliveryAgentDto.add_agent
_update_agent = DeliveryAgentDto.update_agent
_delete_agent = DeliveryAgentDto.delete_agent
_change_status = DeliveryAgentDto.status_change

@api.route('/')
class GetDeliveryAgent(Resource):
    @api.doc('Show Delivery Agents')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Show Delivery Agents"""
        return get_delivery_agents()

@api.route('/add')
class AddDeliveryAgent(Resource):
    @api.doc('Add Delivery Agents')
    @api.expect(_add_agent, validate = True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Add Delivery Agents"""
        data = request.json
        return add_delivery_agent(data)

@api.route('/update')
class UpdateDeliveryAgent(Resource):
    @api.doc('Update Delivery Agents')
    @api.expect(_update_agent, validate = True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Update Delivery Agents"""
        data = request.json
        return update_delivery_agent(data)

@api.route('/delete')
class DeleteDeliveryAgent(Resource):
    @api.doc('Delete Delivery Agents')
    @api.expect(_delete_agent, validate = True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Delete Delivery Agents"""
        data = request.json
        return delete_delivery_agent(data)

@api.route('/status')
class ChangeStatusDeliveryAgent(Resource):
    @api.doc('Change Status Delivery Agents')
    @api.expect(_change_status, validate = True)
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self):
        """Change Status Delivery Agents"""
        data = request.json
        return delivery_agent_status_change(data)