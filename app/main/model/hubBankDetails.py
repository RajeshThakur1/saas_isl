from app.main import db 

class HubBankDetails(db.Model):
    __tablename__ = "hub_bank_details"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_id=db.Column(db.Integer, db.ForeignKey('hub.id', ondelete='CASCADE'), nullable=False)
    beneficiary_name = db.Column(db.String(255), nullable=True)
    name_of_bank =  db.Column(db.String(100), nullable=True)
    ifsc_code=db.Column(db.String(55), nullable=True)
    vpa=db.Column(db.String(255), nullable=True)
    account_number=db.Column(db.String(100), nullable=True)
    status=db.Column(db.Integer, default="1")
    confirmed=db.Column(db.Integer, default=0)
    added_by_id = db.Column(db.Integer, nullable=True)
    added_by_role = db.Column(db.String, nullable=True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)