from app.main.model.user import User
from app.main.model.superAdmin import SuperAdmin
from app.main.model.admin import Admin
from app.main.model.merchant import Merchant
from app.main.model.supervisor import Supervisor
from app.main.service.v1.blacklist_service import save_token
from typing import Dict, Tuple
from app.main.service.v1.auth_helper import Auth
import requests
from flask import request
# user.active==True and
from app.main.model.apiResponse import ApiResponse
class LastMileHelper:
    @staticmethod
    def Auth():
        data ={
         "db":"last_mile_prod",
         "login":"24x7",
         "password":"1234"}
        url= 'https://gowithdot.net/web/session/authenticate'
        response=requests.post(url, data).text
        return response



    @staticmethod
    def pushorder(data):
        merchant = Auth.get_logged_in_merchant(request)
        get_merchant = Merchant.query.filter_by(email=merchant.email).first()
        headers = {'Content-type': 'text/html; charset=UTF-8'}
        url='https://gowithdot.net/dot_order/create'
        data = {
        '24x7_merch_id':data[''],
        'customer_address':data['address_id'],
        'customer_order_amount':data['grand_order_total'],
        'invoice_num':'OMRT'+str(data['id']),
        'customer_contact':data['phone'],
        'order_payment_type_id':data['paid']

        }
        response=requests.post(url, data).text
        print(response,"=<<<===")
        return response






