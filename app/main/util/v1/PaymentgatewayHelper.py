import hashlib,uuid,requests,datetime
from app.main import config
from app.main.model.transactions import Transactions
from app.main.model.refund import Refund
from hashlib import sha512
from app.main.config import Config, surl, furl, PAYU_MODE
from flask import render_template, url_for, flash,make_response, request
from app.main.util.v1.LastmileHelper import LastMileHelper
from app.main.util.v1.database import save_db
import json

from app.main.util.v1.dateutil import str_to_datetime

class Payment_Util:
    """
    Class for creating API view for Payment gateway homepage.
    """
    
    def payu(data):
    
        if PAYU_MODE == "TEST":
            url = "https://test.payu.in/_payment"
            
        else:    
            url = "https://secure.payu.in/_payment"
        
        headers = { "Accept": "application/json", "Content-Type": 'text/html; charset=UTF-8' }
        response=requests.post(url, data=data,headers=headers)
        result={
            'url':response.url,
            'status':response.status_code,
            }
        return result
    
        ####Fake Credit card Detail####
            # Card Type: Visa

            # Card Number: 4012-0010-3714-1112

            # Card Name: Test

            # CVV : 123

            # Expiry Date : 05/30

            # OTP: 123456

    @staticmethod
    def create_payment(data):
        """
        Function for creating a charge.
        """

        key = Config.PAYU_MERCHANT_KEY
        txnid = str(uuid.uuid4()) + str(data['cart_id'])
        productinfo = data['productinfo']
        firstname = data['firstname']
        email = data['email']
        phone= data['phone']
        amount= data['amount']
        # udf3='address'
        # udf1='diliverydate'
        # udf5='OMRT874578154'

        output_data = {
            'key': key,
            'txnid': txnid,
            'amount': amount,
            'productinfo': productinfo,
            'firstname': firstname,
            'email': email,
            'phone': phone,
            'surl': surl,
            'furl': furl
        }
        
        keys=('txnid','amount','productinfo','firstname','email','udf1', 'udf2', 'udf3', 'udf4', 'udf5',
            'udf6', 'udf7', 'udf8','udf9', 'udf10')
        
        def generate_hash(input_data, *args, **kwargs):
            hash_value = str(Config.PAYU_MERCHANT_KEY)

            for k in keys:
                if input_data.get(k) is None:
                    hash_value += '|' + str('')
                else:
                    hash_value += '|' + str(input_data.get(k))

            hash_value += '|'  + str(Config.PAYU_MERCHANT_SALT)
            hash_value = sha512(hash_value.encode()).hexdigest().lower()
            
            transaction = Transactions(
                txnid=input_data.get('txnid'), 
                amount=input_data.get('amount'), 
                productinfo = input_data['productinfo'], 
                email = input_data['email'],
                firstname = input_data['firstname'],
                phone = input_data['phone'],
                hash_ = hash_value,
                created_at=datetime.datetime.utcnow())
            
            save_db(transaction)
            return hash_value
        
        get_generated_hash = generate_hash(output_data)
        output_data['hash'] = get_generated_hash
        x=Payment_Util.payu(output_data)
        return x

    @staticmethod
    def get_succes(data):
        status = data["status"]
        firstname = data["firstname"]
        amount = data["amount"]
        txnid = data["txnid"]
        posted_hash = data["hash"]
        key = data["key"]
        productinfo = data["productinfo"]
        email = data["email"]
        salt = Config.PAYU_MERCHANT_SALT
        additional_charges = None
        try:
            additional_charges = data["additionalCharges"]
            ret_hash_seq = additional_charges + '|' + salt + '|' + status + '|||||||||||' + email + '|' + firstname +\
                           '|' + productinfo + '|' + amount + '|' + txnid + '|' + key
        except Exception:
            ret_hash_seq = salt + '|' + status + '|||||||||||' + email + '|' + firstname + '|' + productinfo + '|'\
                         + amount + '|' + txnid + '|' + key

        resonse_hash = hashlib.sha512(ret_hash_seq.encode()).hexdigest().lower()

        if resonse_hash == posted_hash:
            transaction = Transactions.query.filter_by(txnid=txnid).first()
            
            if transaction.transaction_date_time:
                return 1
            if transaction.amount != amount: 
                return 2
            
            if transaction.hash != posted_hash:
                return 3

            transaction.payment_gateway_type = data['PG_TYPE']
            transaction.transaction_date_time = str_to_datetime(data['addedon'])
            transaction.mode = data['mode']
            transaction.status = status
            #transaction.key = data["key"]
            transaction.mihpayid = data['mihpayid']
            transaction.bankcode = data['bankcode']
            transaction.bank_ref_num = data['bank_ref_num']
            transaction.discount = data['discount']
            transaction.additional_charges = additional_charges
            transaction.txn_status_on_payu = data['unmappedstatus']
            transaction.hash_status = "Success" if resonse_hash == data['hash'] else "Failed"
           
            save_db(transaction)
            
            with open (config.transaction_json, 'w+') as f:
                transaction_json = json.load(f) 

                transaction_json[data['addedon'].split(" ")[0]][transaction.txnid] = data
                
                json.dump(transaction_json, f)
                
            return 200, transaction.id        
            
            
        else:
            return 400
            


    
