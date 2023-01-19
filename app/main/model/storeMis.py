from app.main import db

class StoreMis(db.Model):

    __tablename__ = 'store_mis'

    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    date = db.Column(db.DateTime, nullable=False)
    order_delivered = db.Column(db.Integer, nullable=True)
    order_canceled = db.Column(db.Integer, nullable=False)
    new_items_added = db.Column(db.Integer, nullable=False)
    average_order_value = db.Column(db.Float, nullable=False)
    total_order_value = db.Column(db.Float, nullable=False)
    total_discount_value = db.Column(db.Float, nullable=False)
    delivery_fees = db.Column(db.Float, nullable=False)
    commission = db.Column(db.Float, nullable=True)
    turnover = db.Column(db.Float, nullable=False)
    total_tax = db.Column(db.Float, nullable=True)
    store_id =db.Column(db.Integer, db.ForeignKey('store.id'))
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)
