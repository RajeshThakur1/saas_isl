from sqlalchemy.orm import backref
from .. import db
import datetime


class Coupon(db.Model):
    """ Coupon Model for storing Coupon related details """
    __tablename__ = "coupons"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String(255), nullable=False, unique=True, index=True)
    title = db.Column(db.String(255), nullable=True)
    description = db.Column(db.Text, nullable=False)
    banner_1 = db.Column(db.String(255), nullable=True)
    banner_2 = db.Column(db.String(255), nullable=True)
    level = db.Column(db.SmallInteger, nullable=False, default=1)
    target = db.Column(db.SmallInteger, nullable=False, index=True)
    deduction_type = db.Column(db.String(255), nullable=False)
    deduction_amount = db.Column(db.Float, nullable=False)
    min_order_value = db.Column(db.Float, nullable=False, default=0)
    max_deduction = db.Column(db.Float, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    previous_order_track = db.Column(db.Integer, nullable=False)
    max_user_usage_limit = db.Column(db.Integer,
                                     nullable=False,
                                     default=1)
    expired_at = db.Column(db.DateTime, nullable=True, default=None, index=True)
    status = db.Column(db.SmallInteger, nullable=False, index=True)
    order_id = db.Column(db.Integer, nullable=True)
    is_display = db.Column(db.SmallInteger, nullable=True, default=1)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    
    item_order = db.relationship('ItemOrder', backref='coupon', lazy = True)
