from flask import request
from flask_restx import Resource
from ....util.v1.user_dto import CategoryDto
from ....service.v1.category_service import GetAllCategoryByCityName, GetCategoryByCityName
from flask import Blueprint
from app.main import db

main = Blueprint('main', __name__, template_folder='templates')
api = CategoryDto.api
_city_name=CategoryDto.city_name
_city_name_all=CategoryDto.city_name_all


@api.route('/get_category')
class GetCategory(Resource):

    @api.response(201, 'Get Category By City.')
    @api.doc('Get Category By City ')
    @api.expect(_city_name,validate=True)
    def post(self):
        """ Get Category By City Name"""
        data=request.json
        return GetCategoryByCityName(data)

@api.route('/get_category/all')
class GetCategoryAll(Resource):

    @api.response(201, 'Get All Category By City.')
    @api.doc('Get All Category By City ')
    @api.expect(_city_name_all,validate=True)
    def post(self):
        """ Get All Category By City Name"""
        data=request.json
        return GetAllCategoryByCityName(data)
