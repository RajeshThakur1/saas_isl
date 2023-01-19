from flask_restx import Resource
from app.main.service.v1.store_payments_service import get_orders_by_store_payment_id, get_store_payments
from app.main.util.v1.decorator import merchant_token_required 
from app.main.util.v1.merchant_dto import StorePaymentDto

api = StorePaymentDto.api 
_get_store_payments = StorePaymentDto.get_store_payment
_get_orders = StorePaymentDto.get_orders


@api.route('/')
class GetStorePayments(Resource):
    @api.doc("Get Store Payments")
    @api.doc(security="api_key")
    @api.expect(_get_store_payments, validate = True)
    @merchant_token_required
    def get(self):
        "Get Store Payments"
        data = _get_store_payments.parse_args()
        return get_store_payments(data)
    
@api.route('/orders')
class GetStorePaymentOrders(Resource):
    @api.doc("Get Store Payment Orders")
    @api.doc(security="api_key")
    @api.expect(_get_orders, validate = True)
    @merchant_token_required
    def get(self):
        "Get Store Payments"
        data = _get_orders.parse_args()
        return get_orders_by_store_payment_id(data)