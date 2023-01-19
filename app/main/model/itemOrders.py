from .. import db
import datetime
import uuid

def generate_uuid():
    return str(uuid.uuid4())

class ItemOrder(db.Model):
    """ Item Order Model for storing Item Order related details """
    __tablename__ = "item_orders"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    slug = db.Column(db.String, default = generate_uuid(), nullable=True)
    walk_in_order = db.Column(db.Integer, default=0,nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'),nullable=False)
    store_id = db.Column(db.Integer,db.ForeignKey('store.id'), nullable=False)
    order_total = db.Column(db.Float,default=0, nullable=True)
    total_tax = db.Column(db.Float, default=0, nullable=True)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupons.id'), nullable=True)
    order_total_discount = db.Column(db.Float, nullable=True)
    final_order_total = db.Column(db.Float, nullable=True)
    delivery_fee = db.Column(db.Float, nullable=True)
    grand_order_total = db.Column(db.Float, nullable=True)
    # initial_paid = db.Column(db.Float, nullable=True)
    order_created=db.Column(db.DateTime, nullable=True)
    order_confirmed=db.Column(db.DateTime, nullable=True)
    ready_to_pack=db.Column(db.DateTime, nullable=True)
    order_paid=db.Column(db.DateTime, nullable=True)
    order_pickedup=db.Column(db.DateTime, nullable=True)
    order_delivered=db.Column(db.DateTime, nullable=True)
    delivery_date=db.Column(db.DateTime, nullable=True)
    user_address_id = db.Column(db.Integer, nullable=True)
    delivery_slot_id = db.Column(db.Integer,nullable=True)
    da_id = db.Column(db.Integer, nullable=True)
    status=db.Column(db.Integer,default="1", nullable=True)
    store_payment_id = db.Column(db.Integer, db.ForeignKey('storepayments.id'), nullable = True)
    merchant_transfer_at = db.Column(db.String(255), nullable=True)
    merchant_txnid = db.Column(db.String, nullable = True)
    transaction_id = db.Column(db.Integer, db.ForeignKey('transactions.id'),nullable = True)
    txnid = db.Column(db.String, nullable=True)
    gateway = db.Column(db.String(255), nullable=True)
    transaction_status = db.Column(db.String(255), nullable=True)
    cancelled_by_id = db.Column(db.Integer, nullable=True)
    cancelled_by_role = db.Column(db.String, nullable = True)
    commission = db.Column(db.Float, nullable=True)
    # commission_perc = db.Column(db.Float, nullable = True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    remove_by_role = db.Column(db.String(255),nullable=True)
    remove_by_id = db.Column(db.Integer, nullable=True)
    #Relationships
    itemOrderlist = db.relationship('ItemOrderLists', backref='itemorder', lazy=True)
    item_order_tax = db.relationship('ItemOrderTax', backref='itemorder', lazy =True)
    


