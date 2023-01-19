from app.main.model.apiResponse import ApiResponse
from app.main.util.v1.downloads_dto import DownloadDto
from flask import request
from flask_restx import Resource
from app.main.util.v1.decorator import super_admin_token_required
from app.main.config import download_dir
from flask.helpers import send_from_directory

api = DownloadDto.api

@api.route('/<path:filename>')
class DownloadFile(Resource):
    @api.doc('Downloads the givenfile')
    def get(self,filename):
        """Downloads the givenfile"""
        try:
            return send_from_directory(directory=download_dir, filename=filename)
            
        except Exception as e:
            apiResponce = ApiResponse(False,'File Not Found ',None,str(e))
            return (apiResponce.__dict__), 404
        
@api.route('/order/<path:filename>')
class DownloadOrderPDF(Resource):
    @api.doc('Download the order pdf by slug')
    def get(self,filename):
        """Order PDF Download"""
        try:
            
            return send_from_directory(directory=download_dir, filename=filename)
            
        except Exception as e:
            apiResponce = ApiResponse(False,'File Not Found ',None,str(e))
            return (apiResponce.__dict__), 404