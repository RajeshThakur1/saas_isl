from .. import db
import datetime

class StoreItem(db.Model):
    """ Store Item Model for storing Store Item related details """
    __tablename__ = "store_item"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id', ondelete='CASCADE'), nullable=False)
    menu_category_id = db.Column(db.Integer, db.ForeignKey('menu_categories.id', ondelete='CASCADE'), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    brand_name = db.Column(db.String(255), nullable=False)
    image = db.Column(db.String(255), default=None)
    packaged = db.Column(db.Integer, nullable=True)
    status=db.Column(db.Integer,default="1", nullable=False)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

    store_item_variable = db.relationship('StoreItemVariable', backref='store_item', lazy=True)
    hub_order_list = db.relationship('HubOrderLists', backref='store_item', lazy=True)

