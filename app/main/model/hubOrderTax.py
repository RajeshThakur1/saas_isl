from app.main import db

class HubOrderTax(db.Model):
    __tablename__ = 'hub_order_tax'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_order_id = db.Column(db.Integer, db.ForeignKey('hub_orders.id'))
    tax_id = db.Column(db.Integer, db.ForeignKey('hubtaxes.id'))
    tax_name = db.Column(db.String, nullable=False)
    tax_type = db.Column(db.Integer, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    calculated = db.Column(db.Float, nullable=False)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)