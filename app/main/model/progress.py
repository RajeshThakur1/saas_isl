from enum import unique
from .. import db, flask_bcrypt
import datetime

class Progress(db.Model):
    """Progress Table for storing file import progress"""

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, nullable=True)
    uid = db.Column(db.String(255), nullable=False, unique=True)
    store_id = db.Column(db.Integer, nullable=True)
    total = db.Column(db.Integer, nullable=True)
    success = db.Column(db.Integer, nullable=True)
    skipped = db.Column(db.Integer, nullable=True)
    status = db.Column(db.Integer, default = 0, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime, nullable=True)
    deleted_at = db.Column(db.DateTime, nullable=True)