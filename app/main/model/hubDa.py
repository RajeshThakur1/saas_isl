from .. import db
import datetime


class HubDA (db.Model):
    """
    HubDA table
    """
    __tablename__ = 'hub_da'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_id = db.Column(db.Integer, db.ForeignKey('hub.id', ondelete='CASCADE'), nullable=False)
    delivery_associate_id = db.Column(db.Integer, db.ForeignKey('delivery_associate.id', ondelete='CASCADE'), nullable=False)
    status = db.Column(db.Integer,default="1", nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)