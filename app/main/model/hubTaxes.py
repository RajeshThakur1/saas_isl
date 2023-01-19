from app.main import db

class HubTaxes(db.Model):

    __tablename__ = 'hubtaxes'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_id = db.Column(db.Integer, db.ForeignKey('hub.id'), nullable=False)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=True)
    tax_type = db.Column(db.Integer, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    hub_order_tax = db.relationship('HubOrderTax', backref='hubtax', lazy=True)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)