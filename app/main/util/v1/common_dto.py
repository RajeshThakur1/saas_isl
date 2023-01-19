from flask_restx import Namespace, fields
from sqlalchemy.sql.expression import desc
class CommonDto:
    api = Namespace('Common Apis', description="Apis that are common for all users")
    
    order_by_slug = api.model('order_by_slug',{
        'slug': fields.String(required=True, description="Order Slug")
    })
    
    hub_order_by_slug = api.model('hub_order_by_slug',{
        'slug': fields.String(required=True, description="Hub Order Slug")
    })