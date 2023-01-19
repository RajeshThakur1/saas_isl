from app.main import db

class ItemOrderTax(db.Model):
    __tablename__ = 'item_order_tax'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    item_order_id = db.Column(db.Integer, db.ForeignKey('item_orders.id'))
    tax_id = db.Column(db.Integer, db.ForeignKey('storetaxes.id'))
    tax_name = db.Column(db.String, nullable=False)
    tax_type = db.Column(db.Integer, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    calculated = db.Column(db.Float, nullable=False)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)