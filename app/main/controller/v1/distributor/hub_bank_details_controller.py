from flask_restx import Resource
from app.main.service.v1.hub_bank_details_service import confirm_hub_bank_details, create_hub_bank_details, delete_hub_bank_details, show_hub_bank_details, update_hub_bank_details
from app.main.util.v1.decorator import distributor_token_required
from app.main.util.v1.distributor_dto import HubBankDetailsDto
from flask import request

api = HubBankDetailsDto.api
_add_hub_bank_details = HubBankDetailsDto.add_hub_bank_details
_update_hub_bank_details=HubBankDetailsDto.update_hub_bank_details
#_delete_hub_bank_details=HubBankDetailsDto.delete_hub_bank_details
_get_bank_details = HubBankDetailsDto.get_bank_details
_confirm_update = HubBankDetailsDto.confirm_update



@api.route('/create')
class BankDetailsCreate(Resource):
    @api.response(200, 'Bank Details successfully created.')
    @api.doc('create a new Bank Details')
    @api.doc(security='api_key')
    @api.expect(_add_hub_bank_details, validate=True)
    @distributor_token_required
    def post(self):
        """Creates a new Bank Details """
        data = request.json
        return create_hub_bank_details(data=data)

@api.route('/')
class BankDeatils(Resource):
    @api.response(200, 'Bank Details successfully get.')
    @api.doc('Get a StorePaymens')
    @api.doc(security='api_key')
    @api.expect(_get_bank_details, validate=True)
    @distributor_token_required
    def post(self):
        """Get a Bank Details """
        data = request.json
        return show_hub_bank_details(data)


@api.route('/update')
class BankDetailsUpdate(Resource):
    @api.response(200, 'Bank Details successfully Updated.')
    @api.doc('update a Bank Details')
    @api.doc(security='api_key')
    @api.expect(_update_hub_bank_details, validate=True)
    @distributor_token_required
    def post(self):
        """updates a Bank Details """
        data = request.json
        return update_hub_bank_details(data=data)


# @api.route('/delete')
# class BankDetailsUpdate(Resource):
#     @api.response(200, 'Bank Details successfully deleted.')
#     @api.doc('delete a Bank Details')
#     @api.doc(security='api_key')
#     @api.expect(_delete_hub_bank_details, validate=True)
#     @distributor_token_required
#     def post(self):
#         """delete a Bank Details """
#         data = request.json
#         return delete_hub_bank_details(data=data)

@api.route('/confirm')
class BankDetailsConfirm(Resource):
    @api.doc('Accept or Reject a Store Payment Details')
    @api.doc(security='api_key')
    @api.expect(_confirm_update, validate=True)
    @distributor_token_required
    def post(self):
        """Accept or Reject a Store Payment Details"""
        data = request.json
        return confirm_hub_bank_details(data=data)