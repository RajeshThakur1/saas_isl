from .. import db, flask_bcrypt
import datetime
import jwt
from ..config import key
# from sqlalchemy_utils import PhoneNumber

class UserOtp(db.Model):
    """ User OTP Model for storing OTP details """
    __tablename__ = "otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer,  nullable=False)
    user_role = db.Column(db.String, nullable=False)
    isEmailVerified = db.Column(db.Boolean, default=0)
    emailVerificationAttempted = db.Column(db.Integer, default=0)
    isPhoneVerified = db.Column(db.Boolean, default=0)
    phoneVerificationAttempted = db.Column(db.Integer, default=0)
    counter = db.Column(db.Integer, default=0)
    otp_hash = db.Column(db.String, nullable=True)
    otp_type = db.Column(db.Integer, nullable=False)
    otp_route = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    expiring_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime)
    deleted_at=db.Column(db.DateTime)
    emailVerifiedAt = db.Column(db.DateTime)
    phoneVerifiedAt = db.Column(db.DateTime)

    #Relationship


    #Properties
    @property
    def otp(self):
        raise AttributeError('otp: write-only field')

    @otp.setter
    def otp(self, otp):
        self.otp_hash = flask_bcrypt.generate_password_hash(otp).decode('utf-8')

    def check_otp(self, otp):
        return flask_bcrypt.check_password_hash(self.otp_hash, otp)

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()


class OTPType(db.Model):
    """Otp Type Mapping"""
    __tablename__ = "otp_type"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    type = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime)
    deleted_at=db.Column(db.DateTime)

class OTPRoute(db.Model):
    """Otp Route Mapping"""
    __tablename__ = "otp_route"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    route = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime)
    deleted_at=db.Column(db.DateTime)


class MerchantOtp(db.Model):
    """ Merchant OTP Model for storing OTP details """
    __tablename__ = "merchant_otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    isVerified = db.Column(db.Boolean, default=0)
    counter = db.Column(db.Integer, default=0)
    otp = db.Column(db.Integer, db.ForeignKey('user.id'),nullable=False)
    #Relationship

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()



class SupervisorOtp(db.Model):
    """ Supervisor OTP Model for storing OTP details """
    __tablename__ = "supervisor_otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    isVerified = db.Column(db.Boolean, default=0)
    counter = db.Column(db.Integer, default=0)
    otp = db.Column(db.Integer, db.ForeignKey('supervisor.id'),nullable=False)
    #Relationship

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()


class AdminOtp(db.Model):
    """ Admin OTP Model for storing OTP details """
    __tablename__ = "admin_otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    isVerified = db.Column(db.Boolean, default=0)
    counter = db.Column(db.Integer, default=0)
    otp = db.Column(db.Integer, db.ForeignKey('admin.id'),nullable=False)
    #Relationship

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()

class DistributorOtp(db.Model):
    """ Distributor OTP Model for storing OTP details """
    __tablename__ = "distributor_otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    isVerified = db.Column(db.Boolean, default=0)
    counter = db.Column(db.Integer, default=0)
    otp = db.Column(db.Integer, db.ForeignKey('distributor.id'),nullable=False)
    #Relationship

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()

class DeliveryAssociateOtp(db.Model):
    """ DeliveryAssociate OTP Model for storing OTP details """
    __tablename__ = "delivery_associate_otp"


    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    isVerified = db.Column(db.Boolean, default=0)
    counter = db.Column(db.Integer, default=0)
    otp = db.Column(db.Integer, db.ForeignKey('delivery_associate.id'),nullable=False)
    #Relationship

    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()