from app.main.service.v1.otp_service import add_otp_route, add_otp_type, get_otp_routes, remove_otp_route, remove_otp_type, show_all_otp_types
from app.main.util.v1.decorator import  super_admin_token_required
from flask import request
from flask_restx import Resource
from ....util.v1.superadmin_dto import OTPDto
from app.main import db

api=OTPDto.api



@api.route('/types')
class ShowTypes(Resource):
    @api.doc(" Get all orders ")
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self):
        return show_all_otp_types()


@api.route('/type/add_type')
class AddType(Resource):
    @api.doc(security='api_key')
    @api.expect(OTPDto.add_type, validate = True)
    @super_admin_token_required
    def post(self): 
        """Add an otp type"""
        data = request.json
        return add_otp_type(data)


@api.route('/type/remove_type')
class RemoveType(Resource):
    @api.doc(security='api_key')
    @api.expect(OTPDto.remove_type, validate = True)
    @super_admin_token_required
    def post(self): 
        """Remove an otp type"""
        data = request.json
        return remove_otp_type(data)

@api.route('/routes')
class ShowRoutes(Resource):
    @api.doc(security='api_key')
    @super_admin_token_required
    def get(self): 
        """Show OTP Routes"""
        return get_otp_routes()


@api.route('/routes/add')
class AddRoute(Resource):
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self): 
        """Add OTP Route"""
        data = request.json
        return add_otp_route(data)



@api.route('/routes/remove')
class RemoveRoute(Resource):
    @api.doc(security='api_key')
    @super_admin_token_required
    def post(self): 
        """Remove OTP Route"""
        data = request.json
        return remove_otp_route(data)