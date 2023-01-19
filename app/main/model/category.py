from .. import db
import datetime

class Category (db.Model):
    """
    categories table
    """
    __tablename__ = 'categories'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name= db.Column(db.String(255), nullable=False)
    image = db.Column(db.String(255), nullable=False)
    status = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)


def __init__(self, name, image):
   self.name = name
   self.image = image
   self.status = 1