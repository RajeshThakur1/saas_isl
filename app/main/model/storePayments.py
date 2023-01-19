from sqlalchemy.orm import backref
from app.main import db
from datetime import datetime
class StorePayment(db.Model):
    __tablename__ = 'storepayments'
    
    id =  db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey("store.id"), nullable = False)
    grand_total_amount = db.Column(db.Float , nullable = False)
    total_amount = db.Column(db.Float , nullable = False)
    gst = db.Column(db.Float, nullable = False)
    tcs = db.Column(db.Float, nullable = False)
    commission = db.Column(db.Float, nullable = False)
    commission_perc = db.Column(db.Float, nullable = False)
    merchant_amount = db.Column(db.Integer, nullable = False)
    beneficiary_name = db.Column(db.String(255), nullable=True)
    name_of_bank =  db.Column(db.String(100), nullable=True)
    ifsc_code=db.Column(db.String(55), nullable=True)
    vpa=db.Column(db.String(255), nullable=True)
    account_number=db.Column(db.String(100), nullable=True)
    transaction_id = db.Column(db.String, nullable = False)
    transferd_at = db.Column(db.String, nullable = True)
    approved_at = db.Column(db.DateTime)
    approved_by_id = db.Column(db.Integer)
    approved_by_role = db.Column(db.String)
    store_bankdetails_id = db.Column(db.ForeignKey('store_bankdetails.id'), nullable = False)
    created_at = db.Column(db.DateTime, default = datetime.utcnow(), nullable = False)
    updated_at = db.Column(db.DateTime, default = datetime.utcnow(),onupdate = datetime.utcnow(), nullable = False)
    deleted_at = db.Column(db.DateTime, nullable = True)
    
    item_order = db.relationship("ItemOrder", backref = 'store_payment', lazy = True)
    