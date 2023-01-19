from app.main.service.v1.delivery_service import fetch_delivery_agents, set_delivery_agent
from app.main.util.v1.decorator import merchant_token_required
from app.main.util.v1.merchant_dto import DeliveryDto
from flask import request
from flask_restx import Resource


api = DeliveryDto.api
_set_agent = DeliveryDto.set_agent

@api.route('/')
class FetchAgents(Resource):
    """Fetch all active delivery agents"""
    @api.response(200, 'Success')
    @api.response(401, 'Unauthorized request')
    @api.response(500, 'Internal Server Error')
    @api.doc(security='api_key')
    @merchant_token_required
    def get(self, **kwargs):
        """Fetch all active delivery agents"""
        return fetch_delivery_agents()

# @api.route('/set_delivery_agent')
# class SetDeliveryAgent(Resource):
#     @api.doc("""Set delivery agent for an order""")
#     @api.response(200, 'Success')
#     @api.response(401, 'Unauthorized Request')
#     @api.response(500, 'Internal Server Error')
#     @api.doc(secuurity='api_key')
#     @api.expect(_set_agent, validate=True)
#     @merchant_token_required
#     def post(self):
#         """Set delivery agent for an order"""
#         data = request.json
#         return set_delivery_agent(data)