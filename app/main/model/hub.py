from sqlalchemy.orm import backref
from app.main import db  


class Hub(db.Model):
    __tablename__ = 'hub'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    distributor_id = db.Column(db.Integer, db.ForeignKey('distributor.id'))
    name = db.Column(db.String, nullable=False)
    slug = db.Column(db.String, nullable=False)
    image = db.Column(db.String(255), default="")
    address_line_1 = db.Column(db.String(255), nullable=True)
    address_line_2 = db.Column(db.String(255), nullable=True)
    hub_latitude = db.Column(db.Float, nullable=True)
    hub_longitude = db.Column(db.Float, nullable=True)
    # pay_later = db.Column(db.Integer, default="1",nullable=False)
    # delivery_mode=db.Column(db.Integer, default="0",nullable=False)
    # delivery_start_time=db.Column(db.String(255), nullable=True)
    # delivery_end_time=db.Column(db.String(255), nullable=True)
    #da_id = db.Column(db.Integer, db.ForeignKey('delivery_associate.id'))
    radius=db.Column(db.Integer, default="10")
    status=db.Column(db.Integer, default="1")
    city_id = db.Column(db.Integer, db.ForeignKey('cities.id'))
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

    #Relationship
    hub_order = db.relationship('HubOrders', backref= 'hub', lazy=True)
    bankdetails = db.relationship("HubBankDetails", backref='hub',lazy=True)
    hub_da = db.relationship('HubDA', backref='hub', lazy=True)