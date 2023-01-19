from .. import db
import datetime
from slugify import slugify

class MerchantTransactions(db.Model):
    """ Transaction Model for storing Transaction related details """
    __tablename__ = "merchant_transactions"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id=db.Column(db.Integer, db.ForeignKey('store.id', ondelete='CASCADE'), nullable=False)
    benf_name=db.Column(db.String(255), nullable=True)
    user_email=db.Column(db.String(255), nullable=True)
    user_phone=db.Column(db.String(255), nullable=True)
    merchant_ref_id=db.Column(db.String(255), nullable=True)
    payable_amount=db.Column(db.Float, nullable=True)
    gst=db.Column(db.Float, nullable=True)
    tcs=db.Column(db.Float, nullable=True)
    commission = db.Column(db.Float, nullable=True)
    benf_name = db.Column(db.String(255), nullable=True)
    bank_name =  db.Column(db.String(100), nullable=True)
    ifsc=db.Column(db.String(55), nullable=True)
    vpa=db.Column(db.String(255), nullable=True)
    total_order_amount=db.Column(db.String(255), nullable=True)
    account_number=db.Column(db.String(100), nullable=True)
    status= db.Column(db.String(255), nullable=True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)


    # def update_to_db(self, data):
    #     for key, value in data.items():
    #         setattr(self, key, value)
    #     db.session.commit()
