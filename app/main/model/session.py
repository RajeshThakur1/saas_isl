import hashlib

import flask_bcrypt

from .. import db
import datetime

class Session(db.Model):
    """user session related information"""

    __tabelname__ = "session"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    auth_token_hash = db.Column(db.String)
    session_start_time = db.Column(db.DateTime, nullable=True)
    session_end_time = db.Column(db.DateTime, nullable=True)
    os= db.Column(db.String ,nullable=True)
    created_at = db.Column(db.DateTime, nullable=True)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)

    @property
    def auth_token(self):
        raise AttributeError('password: write-only field')

    @auth_token.setter
    def auth_token(self, auth_token):
        hash_file_name = hashlib.sha256(bytes(auth_token,'utf-8'))
        self.auth_token_hash = hash_file_name.hexdigest()
        #self.auth_token_hash = flask_bcrypt.generate_password_hash(auth_token).decode('utf-8')

    def check_auth_token(self, auth_token):
        return flask_bcrypt.check_password_hash(self.auth_token_hash, auth_token)