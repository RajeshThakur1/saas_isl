from app.main.service.v1.category_service import show_category, show_category_without_pagination
from app.main.util.v1.decorator import supervisor_token_required
from flask import request
from flask_restx import Resource
from app.main.util.v1.supervisor_dto import CategoryDto

api = CategoryDto.api 

@api.route('/')
class ShowCategories(Resource):
    @api.response(201, 'All Categories Fetched successfully.')
    @api.doc(security='api_key')
    # @api.param(name='page', description='Page no.')
    # @api.param(name='items', description='Items per page')
    @api.doc('Show all Categories')
    @supervisor_token_required
    def get(self):
        """Show all Categories """
        #data = request.args
        return show_category_without_pagination()
