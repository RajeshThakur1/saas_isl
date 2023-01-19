from app.main.util.v1.merchant_dto import DashboardDto
from app.main.util.v1.decorator import merchant_token_required, check_merchant_access
from app.main.service.v1.dashboard_service import get_latest_orders_merchant, get_merchant_stats
from flask import request
from flask_restx import Resource


api = DashboardDto.api


@api.route('/stats')
class MerchantStats(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Stats')
    @api.doc(security='api_key')
    @merchant_token_required
    # @check_merchant_access
    def get(self):
        return get_merchant_stats()


@api.route('/latestOrders')
class MerchantOrders(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Service')
    @api.doc(security='api_key')
    @merchant_token_required
    # @check_merchant_access
    def get(self):
        return get_latest_orders_merchant()