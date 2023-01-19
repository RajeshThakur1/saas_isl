from app.main import db  

class HubOrderPayments(db.Model):
    ___tablename__ = 'hub_order_payments'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_order_id = db.Column(db.Integer, db.ForeignKey('hub_orders.id'))
    amount = db.Column(db.Float, nullable=False)
    payment_date = db.Column(db.DateTime, nullable=False)
    confirmed = db.Column(db.Integer, nullable=False)
    added_by_id = db.Column(db.Integer, nullable=False)
    added_by_role = db.Column(db.String, nullable=False)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)