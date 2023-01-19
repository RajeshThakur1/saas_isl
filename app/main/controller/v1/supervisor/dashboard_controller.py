from app.main.service.v1.dashboard_service import get_latest_orders_supervisor, get_supervisor_stats
from flask_restx import Resource
from app.main.util.v1.supervisor_dto import DashboardDto
from app.main.util.v1.decorator import supervisor_token_required

api = DashboardDto.api


@api.route('/stats')
class MerchantStats(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Stats')
    @api.doc(security='api_key')
    @supervisor_token_required
    def get(self):
        return get_supervisor_stats()


@api.route('/latestOrders')
class MerchantOrders(Resource):
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Service')
    @api.doc(security='api_key')
    @supervisor_token_required
    def get(self):
        return get_latest_orders_supervisor()