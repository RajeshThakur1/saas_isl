from .. import db
import datetime

class QuantityUnit(db.Model):
    """ Quantity Unit Model for storing Store related details """
    __tablename__ = "quantity_unit"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=True)
    short_name = db.Column(db.String(255), nullable=True)
    conversion = db.Column(db.String(255),nullable=False)
    type_details = db.Column(db.String(255), nullable=False)
    status=db.Column(db.Integer, nullable=False)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

    store_item_varible = db.relationship('StoreItemVariable', backref='quantity_unit_', lazy=True)
    hub_order_list = db.relationship('HubOrderLists', backref='quantity_unit_', lazy=True)
