from app.main import db

class MisDetails(db.Model):

    __tablename__ = 'misdetail'

    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    date = db.Column(db.DateTime, nullable=False)
    daily_new_user = db.Column(db.Integer, nullable=False)
    order_delivered = db.Column(db.Integer, nullable=False)
    order_canceled = db.Column(db.Integer, nullable=False)
    new_items_added = db.Column(db.Integer, nullable=False)
    new_stores_created = db.Column(db.Integer, nullable=False)
    average_order_value = db.Column(db.Float, nullable=False)
    total_order_value = db.Column(db.Float, nullable=False)
    total_discount_value = db.Column(db.Float, nullable=False)
    delivery_fees = db.Column(db.Float, nullable=False)
    commission = db.Column(db.Float, nullable=True)
    turnover = db.Column(db.Float, nullable=False)
    total_tax = db.Column(db.Float, nullable=False)
    city_mis_deatil = db.relationship('CityMisDetails', backref='mis', lazy=True)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)

