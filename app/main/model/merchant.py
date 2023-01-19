from sqlalchemy.orm import backref
from app.main.model.store import Store
from .. import db, flask_bcrypt
import datetime
import jwt
from app.main.model.blacklist import BlacklistToken
from ..config import key
# from sqlalchemy_utils import PhoneNumber

class Merchant(db.Model):
    """ User Model for storing user related details """
    __tablename__ = "merchant"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    name=db.Column(db.String(255),  nullable=False)
    password_hash = db.Column(db.String(100))
    active = db.Column(db.Boolean(), default=False)
    phone=db.Column(db.String(255), nullable=False)
    image = db.Column(db.String, nullable=True)
    role=db.Column(db.String(255), default='merchant')
    email_verified_at=db.Column(db.DateTime, nullable=True)
    phone_verified_at=db.Column(db.DateTime, nullable=True)
    created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
    updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
                         onupdate=db.func.current_timestamp())
    deleted_at=db.Column(db.DateTime, nullable=True)
    #Relationship
    hub_order = db.relationship('HubOrders', backref = 'merchant', lazy = True)
    store = db.relationship('Store', backref = 'merchant', lazy = True)
    # Store = db.relationship('Store', backref='merchant', lazy=True)
    # itemOrder = db.relationship('ItemOrder', backref='user', lazy=True)
    # address = db.relationship("UserAddress", uselist=True, back_populates="user")


    @property
    def password(self):
        raise AttributeError('password: write-only field')

    @password.setter
    def password(self, password):
        self.password_hash = flask_bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return flask_bcrypt.check_password_hash(self.password_hash, password)

    def __repr__(self):
        return "<Merchant '{}'>".format(self.email)


    def encode_auth_token(self, merchant_id,role):
        """
        Generates the Auth Token
        :return: string
        """
        try:
            payload = {
                'exp': datetime.datetime.utcnow() + datetime.timedelta(days = 30),
                'iat': datetime.datetime.utcnow(),
                'sub': merchant_id,
                'role': role,
                
            }
            return jwt.encode(
                payload,
                key,
                algorithm='HS256'
            )
        except Exception as e:
            return e
 
    def decode_auth_token(auth_token):
        """
        Decodes the auth token
        :param auth_token:
        :return: integer|string
        """
        try:
            payload = jwt.decode(auth_token, key, algorithm=['HS256'])
            role='role'
            is_blacklisted_token = BlacklistToken.check_blacklist(auth_token)
            if is_blacklisted_token:
                return 'Token blacklisted. Please log in again.'
            
            # if the token consist role field also 
            # elif role in  payload:
            #     return payload['sub'],payload['role']
            
            # if the token does not contain role field 
            else:
                return payload
            
        except jwt.ExpiredSignatureError:
            return 'Signature expired. Please log in again.'
        except jwt.InvalidTokenError:
            return 'Invalid token. Please log in again.'



    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()

#previous code _ merchant as like admin module

# from .. import db, flask_bcrypt
# import datetime
# import jwt
# from app.main.model.blacklist import BlacklistToken
# from ..config import key
# # from sqlalchemy_utils import PhoneNumber

# class Merchant(db.Model):
#     """ User Model for storing user related details """
#     __tablename__ = "merchant"

#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     email = db.Column(db.String(255), unique=True, nullable=False)
#     name=db.Column(db.String(255),  nullable=False)
#     password_hash = db.Column(db.String(100))
#     active = db.Column(db.Boolean(), default=False)
#     phone=db.Column(db.String(255), unique=True, nullable=False)
#     role=db.Column(db.String(255), default='merchant')
#     email_verified_at=db.Column(db.DateTime, nullable=True)
#     phone_verified_at=db.Column(db.DateTime, nullable=True)
#     created_at=db.Column(db.DateTime,default=db.func.current_timestamp())
#     updated_at=db.Column(db.DateTime,default=db.func.current_timestamp(),
#                          onupdate=db.func.current_timestamp())


#     @property
#     def password(self):
#         raise AttributeError('password: write-only field')

#     @password.setter
#     def password(self, password):
#         self.password_hash = flask_bcrypt.generate_password_hash(password).decode('utf-8')

#     def check_password(self, password):
#         return flask_bcrypt.check_password_hash(self.password_hash, password)

#     def __repr__(self):
#         return "<Merchant '{}'>".format(self.email)


#     def encode_auth_token(self, user_id,role):
#         """
#         Generates the Auth Token
#         :return: string
#         """
#         try:
#             payload = {
#                 'exp': datetime.datetime.utcnow() + datetime.timedelta(days=1, seconds=5),
#                 'iat': datetime.datetime.utcnow(),
#                 'sub': user_id,
#                 'role': role,
#             }
#             return jwt.encode(
#                 payload,
#                 key,
#                 algorithm='HS256'
#             )
#         except Exception as e:
#             return e
        