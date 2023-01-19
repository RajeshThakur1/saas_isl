from flask import request
from flask_restx import Resource
from app.main.service.v1.store_bankdetails_service import *
from app.main.util.v1.superadmin_dto import StoreBankDetailDto
from app.main.util.v1.decorator import super_admin_token_required

api = StoreBankDetailDto.api
_add_store_bankdetails = StoreBankDetailDto.add_store_bankdetails
_update_store_bankdetails=StoreBankDetailDto.update_store_bankdetails
_delete_store_bankdetails=StoreBankDetailDto.delete_store_bankdetails
_get_payment = StoreBankDetailDto.get_payment

@api.route('/create')
class StoreBankDetailCreate(Resource):
    @api.response(200, 'StoreBankDetail successfully created.')
    @api.doc('create a new StoreBankDetail')
    @api.doc(security='api_key')
    @api.expect(_add_store_bankdetails, validate=True)
    @super_admin_token_required
    def post(self):
        """Creates a  new Bank details """
        data = request.json
        return create_store_bankdetails(data=data)

@api.route('/')
class StoreBankDetail(Resource):
    @api.response(200, 'StoreBankDetail successfully get.')
    @api.doc('Get a StorePaymens')
    @api.doc(security='api_key')
    @api.expect(_get_payment, validate=True)
    @super_admin_token_required
    def post(self):
        """Get a Bank Details """
        data = request.json
        return show_StoreBankDetail(data)


@api.route('/update')
class StoreBankDetailUpdate(Resource):
    @api.response(200, 'StoreBankDetails successfully Updated.')
    @api.doc('update a StoreBankDetails')
    @api.doc(security='api_key')
    @api.expect(_update_store_bankdetails, validate=True)
    @super_admin_token_required
    def post(self):
        """updates a Bank Details """
        data = request.json
        return update_store_bankdetail(data=data)


@api.route('/delete')
class StoreBankDetailUpdate(Resource):
    @api.response(200, 'StoreBankDetails successfully deleted.')
    @api.doc('delete a StoreBankDetail')
    @api.doc(security='api_key')
    @api.expect(_delete_store_bankdetails, validate=True)
    @super_admin_token_required
    def post(self):
        """delete a Bank Details """
        data = request.json
        return delete_StoreBankDetails(data=data)