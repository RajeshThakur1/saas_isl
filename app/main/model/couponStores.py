from .. import db
import datetime


class CouponStores(db.Model):
    """ CouponStores Model for storing Coupon Store-specific Map related details """
    __tablename__ = "coupon_stores"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'), nullable=False)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupons.id'), nullable=False)
    status = db.Column(db.SmallInteger, nullable=False,default=1)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)