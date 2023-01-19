from .. import db
import datetime


class CouponCategories(db.Model):
    """ CouponCategories Model for storing Coupon Category Map related details """
    __tablename__ = "coupon_categories"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id'), nullable=False)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupons.id'), nullable=False)
    status = db.Column(db.SmallInteger, nullable=False,default=1)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
