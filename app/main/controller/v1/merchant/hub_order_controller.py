from app.main.service.v1 import order_service
from app.main.util.v1.decorator import merchant_token_required
from app.main.util.v1.merchant_dto import HubOrderDto
from flask_restx import Resource
from flask import request
from app.main.service.v1 import hub_order_payment_service

api = HubOrderDto.api



@api.route('/')
class GetHubOrders(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.param(name='page', description='Page no.')
    @api.param(name='item_per_page', description='Items per page')
    @api.param(name='id', description='Search ID')
    @api.doc(security='api_key')
    @merchant_token_required
    def get(self, **kwargs):
        return order_service.get_orders_distributor()



@api.route('/details')
class GetHubOrderDetails(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.fetch, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return order_service.get_order_details_distributor(data=request.json)


@api.route('/cancel_order')
class CancelHubOrder(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.cancel_order, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return order_service.distributor_cancel_order(data=request.json)



@api.route('/get_payments')
class GetHubOrderPayments(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.get_payments, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return hub_order_payment_service.get_hub_order_payment(data=request.json)



@api.route('/confirm_payment')
class ConfirmHubOrderPayment(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.confirm_payment, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return hub_order_payment_service.confirm_hub_order_payment(data=request.json)
    
@api.route('/remove_items')
class DeleteHubOrderItems(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.delete_items, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return order_service.merchant_hub_order_items_delete(data=request.json)

@api.route('/confirm_order')
class ConfirmHubOrder(Resource):
    @api.response(200, 'Success')
    @api.response(400, 'Bad Request')
    @api.response(500, 'Internal Server or Database Error')
    @api.expect(HubOrderDto.confirm_order, validate = True)
    @api.doc(security='api_key')
    @merchant_token_required
    def post(self):
        return order_service.merchant_hub_order_confirm(data=request.json)


