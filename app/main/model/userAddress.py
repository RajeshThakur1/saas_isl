from .. import db
import datetime

class UserAddress(db.Model):
    """ Store Model for storing Store related details """
    __tablename__ = "user_address"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'),nullable=False)
    
    address1 = db.Column(db.String(255), nullable=True)
    address2 = db.Column(db.String(255), nullable=True)
    address3 = db.Column(db.String(255), nullable=True)
    landmark = db.Column(db.String(255), nullable=True)
    phone    = db.Column(db.String(255), nullable=True)
    latitude = db.Column(db.String(255), nullable=True)
    longitude = db.Column(db.String(255), nullable=True)
    status=db.Column(db.Integer, default="1")
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    city_id=db.Column(db.Integer, db.ForeignKey('cities.id'))


    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()
