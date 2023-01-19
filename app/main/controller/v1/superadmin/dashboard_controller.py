from app.main.service.v1.dashboard_service import detailed_mis_report_super_admin, get_latest_orders_super_admin, get_latest_users_super_admin, get_open_orders_super_admin, get_stats_super_admin, mis_graph_super_admin, mis_report_super_admin
from app.main.util.v1.decorator import super_admin_token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.superadmin_dto import DashboardDto


api = DashboardDto.api 
_order_mis_report = DashboardDto.order_mis_report
_mis_report = DashboardDto.mis_report


@api.route('/stats')
class Stats(Resource):
    @api.response(200, 'Data Fetched successfully')
    @api.doc('Show Dashboard Stats')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Show Dashboard Stats"""
        return get_stats_super_admin()


@api.route('/latest_orders')
class LatestOrders(Resource):
    @api.response(200, '')
    @api.doc('Shows Latest 100 Orders')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Shows Latest 100 Orders"""
        return get_latest_orders_super_admin()

@api.route('/latest_users')
class LatestUsers(Resource):
    @api.response(200, '')
    @api.doc('Shows Latest 100 Users')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Shows Latest 100 Users"""
        return get_latest_users_super_admin()

@api.route('/open_orders')
class OpenOrders(Resource):
    @api.response(200, '')
    @api.doc('Shows Latest 100 Open Orders')
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        """Shows Latest 100 Open Orders"""
        return get_open_orders_super_admin()

@api.route('/mis_report')
class DetailedMisReport(Resource):
    @api.response(200, "Order Report From start_date to end_date' Fetched Successfully")
    @api.doc('Shows MIS Order Report in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_mis_report,validate=True)
    @super_admin_token_required
    def post(self):
        """Shows MIS Order Report in Given Timeframe"""
        data = request.json
        return mis_report_super_admin(data)


@api.route('/detailed_mis_report')
class DetailedMisReport(Resource):
    @api.response(200, "Order Report From start_date to end_date' Fetched Successfully")
    @api.doc('Shows Delivered Order Report in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_order_mis_report,validate=True)
    @super_admin_token_required
    def post(self):
        """Shows Delivered Order Report in Given Timeframe"""
        data = request.json
        return detailed_mis_report_super_admin(data)

@api.route('/mis_graph')
class GraphData(Resource):
    @api.response(200, "Mis Graph From start_date to end_date Fetched Successfully")
    @api.doc('Shows MIS Graph in Given Timeframe')
    @api.doc(security='api_key')
    @api.expect(_mis_report,validate=True)
    @super_admin_token_required
    def post(self):
        """Shows MIS Graph in Given Timeframe"""
        data = request.json
        return mis_graph_super_admin(data)
        