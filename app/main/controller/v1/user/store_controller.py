from flask import request
from flask_restx import Resource

from ....util.v1.decorator import token_required
from ....util.v1.user_dto import StoreDto
from ....service.v1.store_service import *
from ....service.v1.store_item_service import *

from flask import Blueprint
from app.main import db

main = Blueprint('main', __name__, template_folder='templates')
api = StoreDto.api
_find_store = StoreDto.find_store
_store_id = StoreDto.store_id
_find_store_by_location_category=StoreDto.find_store_by_location_category
_fetch_store_item = StoreDto.fetch_store_item_by_menu_cat_and_storeSlug
_store_slug=StoreDto.fetch_store_by_slug
_fetch_store_by_slug_pagiantion = StoreDto.fetch_store_by_slug_pagiantion
_get_store_item_by_slug = StoreDto.get_store_item_by_slug
_get_store_by_slug = StoreDto.get_store_by_slug
_get_top_items_by_id = StoreDto.items_by_id
globelSearch=StoreDto.globelSearch


@api.route('/find')
class StoreFind(Resource):
    @api.response(201, 'Stores Find')
    @api.doc('find a Store')
    @api.expect(_find_store, validate=True)
    def post(self):
        """Find a Store by Lat Log And Max Dist """
        data = request.json
        return find_store(data=data)


# @api.route('/find')
# class StoreFind(Resource):
#     @api.response(201, 'Stores Find')
#     @api.doc('find a Store')
#     @api.marshal_list_with(_store, envelope='data')
#     @api.expect(find_store1, validate=True)
#     def post(self):
#         """Find a Store by Lat Log And Max Dist """
#         data = request.json
#         return find_store(data=data)


@api.route('/get_store_by_category_coordinate')
class GetStoreByCategoryAndCoordinate(Resource):
    @api.response(201, 'Stores Find')
    @api.doc('find a Store By Category and Location')
    @api.expect(_find_store_by_location_category, validate=True)
    def post(self):
        """Find a Store by Lat Log And Max Dist """
        data = request.json
        return find_store_by_category_coordinate(data=data)
   
# @api.route('/get_store_menu_category_by_store_slug')
# class GetStoreMenuCategoryByStoreId(Resource):
#     @api.response(201, 'Menu Category Find')
#     @api.doc('find a Menu Category by store ID')
#     @api.expect(_store_slug,validate=True)
#     def post(self):
#         """Customer--> Find Menu Categories by Store ID """
#         data = request.json
#         return front_menu_cat_find_by_store_slug(data=data)

@api.route('/get_store_menu_category_by_store_slug')
class GetStoreMenuCategoryByStoreId(Resource):
    @api.response(201, 'Menu Category Find')
    @api.doc('find a Menu Category by store ID')
    @api.expect(_fetch_store_by_slug_pagiantion,validate=True)
    def post(self):
        """Customer--> Find Menu Categories by Store ID """
        data = request.json
        return front_menu_cat_find_by_store_slug_pagination(data=data)

@api.route('/get_store_item_by_store_menu_category_pagination')
class ShowStoreItem(Resource):
    @api.response(200, 'Store Item successfully wrt Store Id.')
    @api.doc('Fetch Store Items wrt store id')
    @api.expect(_fetch_store_item, validate=True)
    def post(self):
        """Customer--> Fetch Store items wrt Store ID & MenuCat ID"""
        data = request.json
        return front_fetch_store_items_by_menu_cat_pagination(data=data)

@api.route('/get_store_by_slug')
class getStorebySlug(Resource):
    @api.expect(_get_store_by_slug,validate=True)
    def post(self):
        """Get Store Details by slug"""
        data = request.json
        return show_store_by_slug(data=data)



@api.route('/get_store_item_by_slug')
class getStorebySlug(Resource):
    @api.expect(_get_store_item_by_slug,validate=True)
    def post(self):
        """Get Store Details by slug"""
        data = request.json
        return fetch_store_items(data=data)


@api.route('/golbelSrearch')
class globelSearch(Resource):
    @api.expect(globelSearch,validate=True)
    def post(self):
        """Get Store Search by string anf city id"""
        data = request.json
        print("kjbfiuhfu")
        return  globelSearch_func(data=data)


@api.route('/get_top_items_by_slug')
class getTopItemsbyID(Resource):
    @api.expect(_get_store_item_by_slug,validate=True)
    def post(self):
        """Get Top Details by slug"""
        data = request.json
        return fetch_top_items(data=data)