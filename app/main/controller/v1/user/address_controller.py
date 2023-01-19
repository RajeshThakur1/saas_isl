from flask import request
from flask_restx import Resource
from ....util.v1.user_dto import AddressDto
from ....service.v1.address_service import *
from app.main.service.v1.auth_helper import Auth
from flask import render_template, url_for, Blueprint, redirect
from app.main.util.v1.logs import log
from app.main import db
import logging

main = Blueprint('main', __name__, template_folder='templates')
api = AddressDto.api
_address = AddressDto.address
address_create=AddressDto.add_address
_delete_address=AddressDto.delete_address
_update_address = AddressDto.update_address
_get_by_city = AddressDto.get_address_by_city

@api.route('/create')
class AddressCreate(Resource):
    @api.response(200, 'Address successfully created.')
    @api.doc('create a new Address')
    @api.doc(security='api_key')
    @api.expect(address_create, validate=True)
    @token_required
    def post(self):
        """Creates a  new Address """
        data = request.json
        
        response, status = Address_opration(data=data)
        # log_msg = log(response['message'])
        
        # if response['success'] == True:
        #     api.logger.info(log_msg)
        # elif response['success'] == False:
        #     api.logger.error(log_msg)
        
        return response, status


@api.route('/')
class AddressGet(Resource):
    @api.response(200, 'Address successfully fetched.')
    @api.doc('Get all Address')
    @api.doc(security='api_key')
    @token_required
    def get(self):
        """Get All Address """
        return show_address()

@api.route('/get_by_cart_id')
class GetAddressByCity(Resource):
    @api.response(200, 'Address successfully Fetched.')
    @api.doc('Fetches User Addresses by Cart ID')
    @api.doc(security='api_key')
    @api.expect(_get_by_city, validate=True)
    @token_required
    def post(self):
        """Fetches User Addresses by Cart ID"""
        data = request.json
        return address_by_cart_id(data=data)

@api.route('/update')
class AddressUpdate(Resource):
    @api.response(200, 'Address successfully Updated.')
    @api.doc('update a Address')
    @api.doc(security='api_key')
    @api.expect(_update_address, validate=True)
    @token_required
    def post(self):
        """updates a Address """
        data = request.json
        return update_address(data=data)


@api.route('/delete')
class AddressUpdate(Resource):
    @api.response(200, 'Address successfully Updated.')
    @api.doc('delete a Address')
    @api.doc(security='api_key')
    @api.expect(_delete_address, validate=True)
    @token_required
    def post(self):
        """delete a Address """
        data = request.json
        return delete_address(data=data)