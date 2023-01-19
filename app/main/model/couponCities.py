from .. import db
import datetime


class CouponCities(db.Model):
    """ CouponCities Model for storing Coupon City Map related details """
    __tablename__ = "coupon_cities"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    city_id = db.Column(db.Integer, db.ForeignKey('cities.id'), nullable=True)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupons.id'), nullable=False)
    status = db.Column(db.SmallInteger, nullable=False,default=1)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)