from .. import db
import datetime


class City(db.Model):
    """
    cities table
    """
    __tablename__ = 'cities'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    code = db.Column(db.String(255), nullable=False)
    status = db.Column(db.Integer, nullable=False)
    help_number = db.Column(db.String(255), nullable=False)
    whats_app_number = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    category = db.relationship('Category', secondary='city_categories')
    localities = db.relationship('Locality', backref='city', lazy='dynamic')
    city_mis_deatil = db.relationship('CityMisDetails', backref='city', lazy=True)
    store = db.relationship('Store', backref='city', lazy=True)
    user_address = db.relationship('UserAddress', backref='city', lazy=True)
    hub = db.relationship('Hub', backref='city', lazy=True)

def __init__(self, name, code, help_number=None, whats_app_number=None):
    self.name = name
    self.code = code
    self.status = 1
    self.help_number = help_number
    self.code = whats_app_number
