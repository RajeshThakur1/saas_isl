from app.main import db

class Refund(db.Model):

    __tablename__ = 'refund'

    id = db.Column(db.Integer,primary_key=True,autoincrement=True)
    order_id = db.Column(db.Integer, db.ForeignKey('item_orders.id'))
    txnid= db.Column(db.Integer, nullable=False)
    amount = db.Column(db.String(255), nullable=True)
    refund_method = db.Column(db.String(255), nullable=False)
    gateway = db.Column(db.String(255), nullable=True)
    issued_by = db.Column(db.Integer, nullable=True,default=0)
    status = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, nullable=False)
    updated_at = db.Column(db.DateTime, nullable=True)
    #deleted_at = db.Column(db.DateTime, nullable=True)



    def update_to_db(self, data):
        for key, value in data.items():
            setattr(self, key, value)
        db.session.commit()