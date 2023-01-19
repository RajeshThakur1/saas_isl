from .. import db, flask_bcrypt
import datetime
import jwt
from app.main.model.blacklist import BlacklistToken
from ..config import key
# from sqlalchemy_utils import PhoneNumber

class SuperAdmin(db.Model):
    """ User Model for storing user related details """
    __tablename__ = "super_admin"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    name=db.Column(db.String(255),  nullable=False)
    password_hash = db.Column(db.String(100))
    active = db.Column(db.Boolean(), default=False)
    phone=db.Column(db.String(255), unique=True, nullable=False)
    image = db.Column(db.String, nullable=True)
    role=db.Column(db.String(255), default='super_admin')
    email_verified_at=db.Column(db.DateTime, nullable=True)
    phone_verified_at=db.Column(db.DateTime, nullable=True)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)

    @property
    def password(self):
        raise AttributeError('password: write-only field')

    @password.setter
    def password(self, password):
        self.password_hash = flask_bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return flask_bcrypt.check_password_hash(self.password_hash, password)

    def __repr__(self):
        return "<SuperAdmin '{}'>".format(self.email)


    def encode_auth_token(self, user_id,role):
        """
        Generates the Auth Token
        :return: string
        """
        try:
            payload = {
                'exp': datetime.datetime.utcnow() + datetime.timedelta(days = 30),
                'iat': datetime.datetime.utcnow(),
                'sub': user_id,
                'role': role,
            }
            return jwt.encode(
                payload,
                key,
                algorithm='HS256'
            )
        except Exception as e:
            return e
        
