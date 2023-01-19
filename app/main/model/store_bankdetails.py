from .. import db
import datetime
from slugify import slugify

class StoreBankDetails(db.Model):
    """ Store Model for storing Store related details """
    __tablename__ = "store_bankdetails"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id=db.Column(db.Integer, db.ForeignKey('store.id', ondelete='CASCADE'), nullable=False)
    beneficiary_name = db.Column(db.String(255), nullable=True)
    name_of_bank =  db.Column(db.String(100), nullable=True)
    ifsc_code=db.Column(db.String(55), nullable=True)
    vpa=db.Column(db.String(255), nullable=True)
    account_number=db.Column(db.String(100), nullable=True)
    status=db.Column(db.Integer, default="1")
    confirmed=db.Column(db.Integer, default=0)
    added_by_id = db.Column(db.Integer, nullable=True)
    added_by_role = db.Column(db.String, nullable=True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

    #relation
    #store = db.relationship("Store", backref = 'store_bankdetails', lazy = True)
    store_payments = db.relationship("StorePayment", backref = 'store_bankdetails', lazy = True)

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()

