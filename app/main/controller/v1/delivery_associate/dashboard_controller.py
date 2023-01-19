from app.main.util.v1.delivery_associate_dto import DashboardDto
from app.main.util.v1.decorator import  delivery_associate_token_required
from app.main.service.v1.dashboard_service import get_da_status, get_latest_orders_da
from flask import request
from flask_restx import Resource


api = DashboardDto.api


@api.route('/stats')
class DistributorStats(Resource):
    """
    Show Dashboard statistics for Delivery Associate
    """
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Stats')
    @api.doc(security='api_key')
    @delivery_associate_token_required
    def get(self):
        return get_da_status()


@api.route('/latestOrders')
class DeliveryAssociateOrders(Resource):
    """
    Show the latest orders for Delivery Associate
    """
    @api.response(200, "Data Fetched Successfully")
    @api.doc('Show Dashboard Service')
    @api.doc(security='api_key')
    @delivery_associate_token_required
    def get(self):
        return get_latest_orders_da()
