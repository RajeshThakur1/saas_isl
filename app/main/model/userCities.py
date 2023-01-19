from .. import db
import datetime

class UserCities(db.Model):
    """ User Cities model for user city map """
    __tablename__ = "user_cities"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, nullable=False)
    city_id = db.Column(db.Integer,db.ForeignKey('cities.id'), nullable=False)
    role = db.Column(db.String(255), nullable=True)
    status=db.Column(db.Integer, default="1")
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)