from app.main.util.v1.distributor_dto import DashboardDto
from app.main.util.v1.decorator import distributor_token_required 
from app.main.service.v1.dashboard_service import get_latest_orders_distributor, get_distributor_status
from flask import request
from flask_restx import Resource


api = DashboardDto.api


@api.route('/stats')
class DistributorStats(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Stats')
    @api.doc(security='api_key')
    @distributor_token_required
    def get(self):
        return get_distributor_status()


@api.route('/latestOrders')
class DistributorOrders(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Service')
    @api.doc(security='api_key')
    @distributor_token_required
    def get(self):
        return get_latest_orders_distributor()