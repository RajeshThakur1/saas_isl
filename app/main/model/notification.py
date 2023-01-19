from .. import db
import datetime
import uuid


def generate_uuid():
    return str(uuid.uuid4())

class Notification(db.Model):
    """ Store Model for storing Store related details """
    __tablename__ = "notification"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer,nullable=False)
    user_role = db.Column(db.String,nullable=True)
    uid = db.Column(db.String(255),default=generate_uuid,nullable=False)
    target = db.Column(db.String(255), nullable=False)
    text = db.Column(db.Text, nullable=False)
    not_type = db.Column(db.String(255), nullable=False)
    message    = db.Column(db.Text, nullable=True)
    status=db.Column(db.Integer, default="0")
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)


    def update_to_db(self, data):
        for key, value in data.items():
            # print("hello",key)
            setattr(self, key, value)
            print(setattr(self,key,value),"this iis the value")
            # print("in loop")
        db.session.commit()
        # print("after loop")


class NotificationTemplates(db.Model):
    __tablename__ = "notification_templates"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    dlt_template_id  = db.Column(db.String(255), nullable=False)
    template = db.Column(db.Text, nullable=False)
    name = db.Column(db.String(255),unique=True, nullable=False)
    t_type= db.Column(db.String(255), nullable=False)
    status=db.Column(db.Integer, default="1", nullable=False)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)


    def update_to_db(self, data):
        for key, value in data.items():
            print(data[key],"<<<===")
            setattr(self, key, value)
        db.session.commit()