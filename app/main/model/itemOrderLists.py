from .. import db
import datetime

class ItemOrderLists(db.Model):
    """ Item Order List Model List for storing Item Order Lis related details """
    __tablename__ = "item_order_lists"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    item_order_id = db.Column(db.Integer, db.ForeignKey('item_orders.id'),nullable=False)
    store_item_id = db.Column(db.Integer, nullable=False)
    store_item_variable_id = db.Column(db.Integer, nullable=False)
    product_packaged = db.Column(db.String(255), nullable=True)
    quantity = db.Column(db.Integer, nullable=False)
    removed_by = db.Column(db.Integer, default="0", nullable=False)
    status=db.Column(db.Integer,  default="1",nullable=False)
    product_mrp=db.Column(db.Float,nullable=True)
    product_selling_price=db.Column(db.Float,nullable=True)
    product_quantity= db.Column(db.Float,nullable=True)
    product_quantity_unit = db.Column(db.Integer,nullable=True)
    product_name = db.Column(db.String(255),nullable=True)
    product_brand_name = db.Column(db.String(255),nullable=True)
    product_image = db.Column(db.String(255), default=None,nullable=True)
    created_at=db.Column(db.DateTime, nullable=True)
    updated_at=db.Column(db.DateTime, nullable=True)
    deleted_at=db.Column(db.DateTime, nullable=True)
