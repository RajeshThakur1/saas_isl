from app.main import db  

class DeliveryAgent(db.Model):
    __tablename__ = 'delivery_agent'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    api_link = db.Column(db.String, nullable=False)
    api_key = db.Column(db.String, nullable=False)
    status = db.Column(db.Integer, default = 1,nullable=False)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
    store = db.relationship('Store', backref='delivery_agent', lazy= True)
    
    