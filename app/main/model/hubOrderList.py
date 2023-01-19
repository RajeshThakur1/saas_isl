from .. import db
import datetime

class HubOrderLists(db.Model):
    """ Hub Order List Model for storing Hub Order Lis related details """
    __tablename__ = "hub_order_lists"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hub_order_id = db.Column(db.Integer, db.ForeignKey('hub_orders.id'),nullable=True)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'), nullable=False)
    store_item_id = db.Column(db.Integer, db.ForeignKey('store_item.id'),nullable=False)
    store_item_variable_id = db.Column(db.Integer, db.ForeignKey('store_item_variable.id'),nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    removed_by_id = db.Column(db.Integer, nullable=True)
    removed_by_role = db.Column(db.String , nullable=True)
    status=db.Column(db.Integer,  default="1",nullable=False)
    product_mrp=db.Column(db.Float,nullable=True)
    product_selling_price=db.Column(db.Float,nullable=True)
    product_quantity= db.Column(db.Float,nullable=False)
    product_quantity_unit = db.Column(db.ForeignKey('quantity_unit.id'),nullable=False)
    product_name = db.Column(db.String(255),nullable=False)
    product_brand_name = db.Column(db.String(255),nullable=False)
    product_image = db.Column(db.String(255), default=None,nullable=False)
    created_at=db.Column(db.DateTime, nullable=False)
    updated_at=db.Column(db.DateTime, nullable=False)
    deleted_at=db.Column(db.DateTime, nullable=True)