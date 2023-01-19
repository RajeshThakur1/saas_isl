from app.main.service.v1.store_payments_service import create_store_payments
from app.main.util.v1.system_dto import CronDto
from app.main.service.v1.mis_service import city_mis_details, mis_details
from flask_restx import Resource
from flask import request
from app.main.util.v1.decorator import super_admin_token_required

api = CronDto.api
_create_mis = CronDto.create_mis_report

@api.route('/createmis')
class CreateMIS(Resource):
    @api.doc(security='api_key')
    @api.expect(_create_mis, validate=True)
    @super_admin_token_required
    def post(self):
        return mis_details(request.json)

@api.route('/create_store_payment')
class CreateStorePayment(Resource):
    @api.doc(security = 'api_key')
    @super_admin_token_required
    def get():
        """Create Store Payments"""
        return create_store_payments()
    
    
# @api.route('/createCityWiseEntry')
# class CreateCityMIS(Resource):
#     @api.doc(security='api_key')
#     @api.expect(_create_mis, validate=True)
#     @super_admin_token_required
#     def post(self):
#         return city_mis_details(request.json)
