from app.main import db

class CityMisDetails(db.Model):

    __tablename__ = 'citymisdetail'

    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    mis_id = db.Column(db.Integer, db.ForeignKey('misdetail.id'))
    city_id = db.Column(db.Integer, db.ForeignKey('cities.id'))
    date = db.Column(db.DateTime, nullable=False)
    order_delivered = db.Column(db.Integer, nullable=False)
    order_canceled = db.Column(db.Integer, nullable=False)
    new_locality = db.Column(db.Integer, nullable=False)
    new_stores_created = db.Column(db.Integer, nullable=False)
    average_order_value = db.Column(db.Float, nullable=False)
    total_order_value = db.Column(db.Float, nullable=False)
    total_discount_value = db.Column(db.Float, nullable=False)
    delivery_fees = db.Column(db.Float, nullable=False)
    total_tax = db.Column(db.Float, nullable=False)
    commission = db.Column(db.Float, nullable=True)
    turnover = db.Column(db.Float, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)


