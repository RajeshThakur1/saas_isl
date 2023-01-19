from app.main import db

class StoreTaxes(db.Model):

    __tablename__ = 'storetaxes'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'), nullable=False)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=True)
    tax_type = db.Column(db.Integer, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    item_order_tax = db.relationship('ItemOrderTax', backref='storetax', lazy=True)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)