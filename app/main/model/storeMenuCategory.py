from .. import db
import datetime


class StoreMenuCategory (db.Model):
    """
    StoreMenuCategories table
    """
    __tablename__ = 'store_menu_categories'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id', ondelete='CASCADE'), nullable=False)
    menu_category_id = db.Column(db.Integer, db.ForeignKey('menu_categories.id', ondelete='CASCADE'), nullable=False)
    status = db.Column(db.Integer,default="1", nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)