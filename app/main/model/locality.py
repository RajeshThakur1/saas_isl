from .. import db
import datetime


class Locality(db.Model):
    """
    localities table
    """
    __tablename__ = 'localities'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    city_id = db.Column(db.Integer, db.ForeignKey('cities.id'))
    name = db.Column(db.String(255), nullable=False)
    code = db.Column(db.String(255), nullable=False)
    pin = db.Column(db.String(255), nullable=False)
    delivery_fee = db.Column(db.String(255), nullable=True)
    start_time = db.Column(db.String(255), nullable=True)
    end_time = db.Column(db.String(255), nullable=True)
    status = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)


def __init__(self, name, code, pin):
    self.name = name
    self.code = code
    self.pin = pin
    self.status = 1
