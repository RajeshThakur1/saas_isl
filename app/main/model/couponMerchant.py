from .. import db
import datetime


class CouponMerchant (db.Model):
    """
    CouponMerchants table
    """
    __tablename__ = 'coupon_merchants'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupons.id', ondelete='CASCADE'), nullable=False)
    merchant_id = db.Column(db.Integer, db.ForeignKey('merchant.id', ondelete='CASCADE'), nullable=False)
    status = db.Column(db.Integer,default="1", nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)