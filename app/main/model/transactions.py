from datetime import datetime
from app.main import db

class Transactions(db.Model):

    __tablename__ = 'transactions'

    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    txnid= db.Column(db.String, nullable=False)
    amount = db.Column(db.String(255), nullable=True)
    productinfo= db.Column(db.String(255), nullable=True)
    firstname = db.Column(db.String(255), nullable=True)
    email = db.Column(db.String(255), nullable=True)
    phone = db.Column(db.String(255), nullable=True)
    url = db.Column(db.String(255), nullable=True)
    hash_ = db.Column(db.String(255), nullable=True)
    key = db.Column(db.String(255), nullable=True)
    salt = db.Column(db.String(255), nullable=True)
    open_payment_token = db.Column(db.Text, nullable=True)
    open_payment_data = db.Column(db.Text, nullable=True)
    payu_gateway_response = db.Column(db.Text, nullable=True)
    payment_gateway_type = db.Column(db.String(255), nullable=True)
    transaction_date_time = db.Column(db.DateTime, nullable=True)
    mode = db.Column(db.String(255), nullable=True)
    mihpayid = db.Column(db.String(255), nullable=True)
    bankcode = db.Column(db.String(255), nullable=True)
    bank_ref_num = db.Column(db.String(255), nullable=True)
    discount = db.Column(db.String(255), nullable=True)
    additional_charges = db.Column(db.String(255), nullable=True)
    txn_status_on_payu = db.Column(db.String(255), nullable=True)
    hash_status = db.Column(db.String(255), nullable=True)
    status = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, default = datetime.utcnow(),nullable=False)
    updated_at = db.Column(db.DateTime, onupdate = datetime.utcnow(),nullable=True)
    deleted_at = db.Column(db.DateTime, nullable = True)
    
    itemOrder = db.relationship('ItemOrder', backref='transaction', lazy=True)


    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()



