from .. import db
import datetime

class StoreItemVariable(db.Model):
    """ Store Item Model for storing Store related details """
    __tablename__ = "store_item_variable"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_item_id = db.Column(db.Integer, db.ForeignKey('store_item.id', ondelete='CASCADE'))
    quantity = db.Column(db.Integer, nullable=True)
    quantity_unit = db.Column(db.Integer, db.ForeignKey('quantity_unit.id', ondelete='CASCADE'))
    mrp = db.Column(db.Integer, nullable=True)
    selling_price = db.Column(db.Integer, nullable=True)
    stock = db.Column(db.Integer, nullable=True)
    status=db.Column(db.Integer,default="1", nullable=False)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

    hub_order_list = db.relationship('HubOrderLists', backref='store_item_variable', lazy=True)
