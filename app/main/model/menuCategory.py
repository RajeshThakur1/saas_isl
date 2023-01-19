from .. import db
import datetime
from slugify import slugify


class MenuCategory (db.Model):
    """
    MenuCategories table
    """
    __tablename__ = 'menu_categories'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id'))
    name= db.Column(db.String(255), nullable=False)
    image = db.Column(db.String(255), nullable=True)
    slug = db.Column(db.String(255), nullable=False)
    status = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)


    def __init__(self, *args, **kwargs):
        if not 'slug' in kwargs:
            kwargs['slug'] = slugify(kwargs.get('name', ''))
            print("===>>>",kwargs['slug'])
        super().__init__(*args, **kwargs)