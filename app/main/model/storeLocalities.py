from .. import db
import datetime

class StoreLocalities(db.Model):
    """ Store Localities Model for storing Store Localities related details """
    __tablename__ = "store_localities"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, nullable=False)
    locality_id = db.Column(db.Integer, nullable=False)
    status=db.Column(db.Integer, default="1")
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
