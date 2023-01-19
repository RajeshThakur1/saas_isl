from .. import db
import datetime
from slugify import slugify

class Store(db.Model):
    """ Store Model for storing Store related details """
    __tablename__ = "store"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    slug = db.Column(db.String(255), nullable=False)
    owner_name = db.Column(db.String(255), nullable=True)
    merchant_id = db.Column(db.Integer, db.ForeignKey('merchant.id'), nullable=True)
    shopkeeper_name = db.Column(db.String(255), nullable=True)
    image = db.Column(db.String(255), default="")
    address_line_1 = db.Column(db.String(255), nullable=True)
    address_line_2 = db.Column(db.String(255), nullable=True)
    store_latitude = db.Column(db.Float, nullable=True)
    store_longitude = db.Column(db.Float, nullable=True)
    pay_later = db.Column(db.Integer, default="1",nullable=False)
    delivery_mode=db.Column(db.Integer, default="0",nullable=False)
    delivery_start_time=db.Column(db.Time, nullable=True)
    delivery_end_time=db.Column(db.Time, nullable=True)
    radius=db.Column(db.Integer, default="10")
    status=db.Column(db.Integer, default="1")
    city_id = db.Column(db.Integer, db.ForeignKey('cities.id'))
    commission = db.Column(db.Float, nullable=True)
    bank_details_id = db.Column(db.Integer, nullable = True)
    walkin_order_tax = db.Column(db.Integer, default = 0, nullable=True)
    walkin_order_commission = db.Column(db.Integer, default = 0, nullable = True)
    da_id = db.Column(db.Integer, db.ForeignKey('delivery_agent.id'))
    self_delivery_price = db.Column(db.Float, default = 0.0 ,nullable=True) 
    store_tax = db.relationship('StoreTaxes', backref='store', lazy =True)
    store_mis = db.relationship('StoreMis', backref='store', lazy= True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    approved_by_id = db.Column(db.Integer, nullable=True)
    approved_by_role = db.Column(db.String, nullable=True)
    approved_at = db.Column(db.DateTime, nullable=True)
    #Relationships
    # category = db.relationship('Category', secondary='store_categories')
    category = db.relationship('Category', secondary='store_categories')
    itemOrder = db.relationship('ItemOrder', backref='store', lazy=True)
    storebankdetails = db.relationship("StoreBankDetails", backref="store")
    hubOrder = db.relationship('HubOrders', backref='store', lazy=True)
    storepayments = db.relationship('StorePayment', backref = 'store', lazy=True)

    # def __init__(self, *args, **kwargs):
    #     if not 'slug' in kwargs:
    #         kwargs['slug'] = slugify(kwargs.get('name', ''))
    #         print("===>>>",kwargs['slug'])
    #     super().__init__(*args, **kwargs)
