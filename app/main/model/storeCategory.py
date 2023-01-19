from .. import db
import datetime


class StoreCategory (db.Model):
    """
    MenuCategories table
    """
    __tablename__ = 'store_categories'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id', ondelete='CASCADE'), nullable=False)
    category_id = db.Column(db.Integer(), db.ForeignKey('categories.id', ondelete='CASCADE'),nullable=False)
    status = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)