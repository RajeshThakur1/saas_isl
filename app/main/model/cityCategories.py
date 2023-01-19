from .. import db
import datetime

class CityCategories(db.Model):
    """ City Categories Model for storing City Categories related details """
    __tablename__ = "city_categories"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    city_id = db.Column(db.Integer(), db.ForeignKey('cities.id', ondelete='CASCADE'))
    category_id = db.Column(db.Integer(), db.ForeignKey('categories.id', ondelete='CASCADE'))
    status=db.Column(db.Integer, default="1")
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)

