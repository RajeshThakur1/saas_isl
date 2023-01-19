from .. import db
import datetime
import uuid
def generate_uuid():
    return str(uuid.uuid4())

class HubOrders(db.Model):
    """ Hub Order Model for storing Hub Order related details """
    __tablename__ = "hub_orders"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    slug = db.Column(db.String, default = generate_uuid(), nullable=True)
    merchant_id = db.Column(db.Integer, db.ForeignKey('merchant.id'),nullable=False)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'), nullable=False)
    hub_id = db.Column(db.Integer,db.ForeignKey('hub.id'), nullable=False)
    order_total = db.Column(db.Float, nullable=True)
    total_tax = db.Column(db.Float, nullable=True)
    # coupon_id = db.Column(db.Integer, nullable=True)
    # order_total_discount = db.Column(db.Float, nullable=True)
    # final_order_total = db.Column(db.Float, nullable=True)
    delivery_fee = db.Column(db.Float, nullable=True)
    grand_order_total = db.Column(db.Float, nullable=True)
    initial_paid = db.Column(db.Float, nullable=True)
    order_created=db.Column(db.DateTime, nullable=True)
    order_confirmed=db.Column(db.DateTime, nullable=True)
    merchant_confirmed = db.Column(db.DateTime, nullable=True)
    assigned_to_da=db.Column(db.DateTime, nullable=True)
    # order_paid=db.Column(db.DateTime, nullable=True)
    order_pickedup=db.Column(db.DateTime, nullable=True)
    order_delivered=db.Column(db.DateTime, nullable=True)
    delivery_date=db.Column(db.DateTime, nullable=True)
    delivery_slot_id = db.Column(db.Integer,nullable=True)
    da_id = db.Column(db.Integer, db.ForeignKey('delivery_associate.id'), nullable=True)
    status=db.Column(db.Integer,default=1, nullable=False)
    payment_status = db.Column(db.Integer, nullable=True)
    total_paid = db.Column(db.Float,  nullable=True)
    due_payment = db.Column(db.Float, nullable=True)
    cancelled_by_id = db.Column(db.Integer, nullable=True)
    cancelled_by_role = db.Column(db.String, nullable = True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    remove_by_role = db.Column(db.String(255),nullable=True)
    remove_by_id = db.Column(db.Integer, nullable=True)
    #Relationships
    hubOrderlist = db.relationship('HubOrderLists', backref='huborder', lazy=True)
    hub_order_tax = db.relationship('HubOrderTax', backref='huborder', lazy =True)
    hub_order_payment = db.relationship('HubOrderPayments', backref='huborder', lazy =True)
    