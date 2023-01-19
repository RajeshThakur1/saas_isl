from distutils.command import check
from flask import request
from flask_restx import Resource
from app.main.util.v1.merchant_dto import StoreBankDetailDto
from app.main.util.v1.PaymentgatewayHelper import *
from app.main.service.v1.store_bankdetails_service import *
from app.main.service.v1.hub_order_payment_service import *
from app.main.service.v1.auth_helper import Auth
from flask import render_template, url_for, Blueprint, redirect
from app.main import db

main = Blueprint('main', __name__, template_folder='templates')
api = StoreBankDetailDto.api
_add_store_bankdetails = StoreBankDetailDto.add_store_bankdetails
_update_store_bankdetails=StoreBankDetailDto.update_store_bankdetails
_delete_store_bankdetails=StoreBankDetailDto.delete_store_bankdetails
_get_payment = StoreBankDetailDto.get_payment
_change_update = StoreBankDetailDto.change_update

@api.route('/create')
class StoreBankDetailCreate(Resource):
    @api.response(200, 'StoreBankDetail successfully created.')
    @api.doc('create a new StoreBankDetail')
    @api.doc(security='api_key')
    @api.expect(_add_store_bankdetails, validate=True)
    @merchant_token_required
    @check_merchant_access
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
    @merchant_token_required
    @check_merchant_access
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
    @merchant_token_required
    @check_merchant_access
    def post(self):
        """updates a Bank Details """
        data = request.json
        return update_store_bankdetail(data=data)


# @api.route('/delete')
# class StoreBankDetailUpdate(Resource):
#     @api.response(200, 'StoreBankDetails successfully deleted.')
#     @api.doc('delete a StoreBankDetail')
#     @api.doc(security='api_key')
#     @api.expect(_delete_store_bankdetails, validate=True)
#     @merchant_token_required
#     def post(self):
#         """delete a Bank Details """
#         data = request.json
#         return delete_StoreBankDetails(data=data)

@api.route('/confirm')
class StoreBankDetailConfirm(Resource):
    @api.doc('Accept or Reject a Store Payment Details')
    @api.doc(security='api_key')
    @api.expect(_change_update, validate=True)
    @merchant_token_required
    def post(self):
        """Accept or Reject a Store Payment Details"""
        data = request.json
        return confirmation_change(data=data)

# @api.route('/getalltransactions')
# class getalltransactions(Resource):
#     @api.response(200, 'StoreBankDetail successfully created.')
#     @api.doc('Get all Payment wrt Merchent')
#     @api.doc(security='api_key')
#     @api.expect(_add_store_bankdetails, validate=True)
#     def post(self):
#         """Get all transaction for """
#         data = request.json
#         # return StoreBankDetail_opration(data=data)
#         return fun()


# @api.route('/createtransactions')
# class getalltransactions(Resource):
#     @api.response(200, 'StoreBankDetail successfully created.')
#     @api.doc('create a new Payment')
#     @api.doc(security='api_key')
#     @api.expect(_add_store_bankdetails, validate=True)
#     def post(self):
#         """Creates a  new transaction  """
#         data = request.json
#         return StoreBankDetail_opration(data=data)


# @api.route('/pushbyid')
# class getalltransactions(Resource):
#     @api.response(200, 'push order by id.')
#     @api.doc('create a new Payment')
#     @api.doc(security='api_key')
#     @api.expect(_add_store_bankdetails, validate=True)
#     def post(self):
#         """push order by cart ID """
#         data = request.json
#         return StoreBankDetail_opration(data=data)
























