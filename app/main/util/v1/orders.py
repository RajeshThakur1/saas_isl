from app.main.model.coupon import Coupon
from app.main.model.hub import Hub
from app.main.model.hubOrderList import HubOrderLists
from app.main.model.hubOrderTax import HubOrderTax
from app.main.model.hubTaxes import HubTaxes
from app.main.util.v1.database import save_db
from app.main.model.itemOrderTax import ItemOrderTax
from app.main.model.storeTaxes import StoreTaxes
from app.main.util.v1.getdistance import GetDistance
from app.main.model.store import Store
from app.main.model.userAddress import UserAddress
import datetime
import requests
from app.main.model.itemOrderLists import ItemOrderLists
from app.main.model.storeItemVariable import StoreItemVariable
from app.main import db
from app.main.model.apiResponse import ApiResponse

def calculate_order_total(order):
    item_order_id = order.id
    items = ItemOrderLists.query.filter_by(item_order_id=item_order_id).filter_by(deleted_at = None).filter_by(status = 1).all()
    taxes = StoreTaxes.query.filter_by(store_id = order.store_id).all()

    order_total = 0
    total_tax = 0

    # if order.total_tax:
    #     total_tax = order.total_tax

    for item in items:
        if order.order_created == None:
            store_item_variable_id = item.store_item_variable_id
            price_item = StoreItemVariable.query.filter_by(id=store_item_variable_id).first().selling_price
        
        else:
            price_item = item.product_selling_price
        
        quantity = item.quantity
        order_total = order_total + price_item*quantity 

    
    
    store = order.store
    
    
    #Commission
    commission = None
    if store.commission :
        if order.walk_in_order and store.walkin_order_commission:
            commission = order_total * store.commission / 100
        
        else:
            commission = order_total * store.commission / 100
            
    final_order_total = order_total

    if order.coupon_id:
        if order.order_total_discount:
            coupon = Coupon.query.filter_by(id = order.coupon_id).first()
            if coupon:
                if coupon.min_order_value <= order_total:
                    
                    if int(coupon.deduction_type) == 1:
                        # get the pecentage of discount
                        discount_value = (coupon.deduction_amount*order.order_total)/100

                    elif int(coupon.deduction_type) == 2:
                        # get absolute discount
                        discount_value = coupon.deduction_amount
                        

                    if discount_value > coupon.max_deduction:
                        discount_value = coupon.max_deduction
                    
                    order.order_total_discount = discount_value
                    final_order_total = order_total - discount_value
                    if final_order_total < 0:
                        final_order_total = 0
                else:
                    order.coupon_id = None
                    order.order_total_discount = None
                    save_db(order,"Order")
    
    
    walkin_tax = True
    if order.walk_in_order == 1:
        if store.walkin_order_tax != 1:
            walkin_tax = False
   
    #TAX CALCULATION
    if order.ready_to_pack == None:

        if order.order_created == None:    
            for tax in taxes:

                item_order_tax = ItemOrderTax.query.filter_by(item_order_id = order.id).filter_by(tax_id = tax.id).first()

                calculated = 0

                if not walkin_tax:
                    if item_order_tax:
                        item_order_tax.deleted_at = datetime.datetime.utcnow()
                        save_db(item_order_tax,"ItemOrderTax")
                        total_tax += calculated
                    continue
                    
                if tax.tax_type == 1:
                    calculated = final_order_total * (tax.amount / 100)
                else:
                    calculated = tax.amount

                if tax.deleted_at != None:
                    if item_order_tax:
                        item_order_tax.deleted_at = datetime.datetime.utcnow()
                        save_db(item_order_tax,"ItemOrderTax")
                        
                    
                else:
                    if not item_order_tax:
                    
                        new_item_order_tax = ItemOrderTax(
                            item_order_id = order.id,
                            tax_id = tax.id,
                            tax_name = tax.name,
                            tax_type = tax.tax_type,
                            amount = tax.amount,
                            calculated = float("{:.2f}".format(calculated)),
                            created_at = datetime.datetime.utcnow()
                        )

                        save_db(new_item_order_tax, "ItemOrderTax")
                        

                    else:
                        item_order_tax.tax_name = tax.name,
                        item_order_tax.tax_type = tax.tax_type,
                        item_order_tax.amount = tax.amount,
                        item_order_tax.calculated = calculated
                        item_order_tax.updated_at = datetime.datetime.utcnow()

                        save_db(item_order_tax, "ItemOrderTax")

                    total_tax += calculated
        
        else:
            item_order_taxs = ItemOrderTax.query.filter_by(item_order_id = order.id).filter_by(deleted_at = None).all()

            calculated = 0

            for item_order_tax in item_order_taxs:

                if item_order_tax.tax_type == 1:
                    calculated = final_order_total * (item_order_tax.amount / 100)
                else:
                    calculated = item_order_tax.amount

                item_order_tax.calculated = float("{:.2f}".format(calculated))
                item_order_tax.updated_at = datetime.datetime.utcnow()

                save_db(item_order_tax, "ItemOrderTax")
                

                total_tax += calculated
    
    else:
        total_tax = order.total_tax
        
    total_tax = float("{:.2f}".format(total_tax))
    grand_order_total = final_order_total + total_tax


    if order.delivery_fee:
        grand_order_total = grand_order_total + order.delivery_fee

    if grand_order_total - int(grand_order_total) > 0:
        grand_order_total = int(grand_order_total) + 1 
    
    
    
    
    order.commission = commission    
    order.order_total = order_total
    order.final_order_total = final_order_total
    order.grand_order_total = grand_order_total
    order.total_tax = total_tax
    order.updated_at = datetime.datetime.utcnow()

    save_db(order, "ItemOrder")

    
    return order_total, final_order_total, grand_order_total

def order_total_calculate(order):
    item_order_id = order.id
    items = ItemOrderLists.query.filter_by(item_order_id=item_order_id)

    order_total = 0
    for item in items:
        store_item_variable_id = item.store_item_variable_id
        price_item = StoreItemVariable.query.filter_by(id=store_item_variable_id).first().selling_price
        quantity = item.quantity
        order_total = order_total + price_item*quantity
    
    order.order_total = order_total

    try:
        db.session.add(order)
        db.session.commit()
    
    except Exception as e:
        db.session.rollback()
        error = ApiResponse(False,"Database Server Error",None,f"Database Name: ItemOrder Error: {str(e)}")
        return error.__dict__, 500
    
    return order_total

def delivery_fee_calc(order,store,address):
    
    
    store_cords = {'lat':store.store_latitude, 'long':store.store_longitude}
    user_address_cords = {'lat':address.latitude, 'long':address.longitude}
    
    if order.delivery_fee == None:
        msg = 'Delivery Fee Added'
    
    else: 
        msg = 'Delivery Fee Updated'
    
    #Self Order
    if store.da_id == 1:
        order.delivery_fee = store.self_delivery_price
        order.da_id = 1 
        save_db(order, "ItemOrder")
    
    #Other DA
    else:
        # url = ""
        # authorization = ""
        # headers = {
        # 'accept': 'application/json',
        # 'Authorization': authorization,
        # 'Content-Type' : 'application/json' 
        # }
        # payload = {}
        # response = request.post(url, data=payload, headers=headers)
        # data = response
        # order.delivery_fee = data['*']
        
        #Currently Hard Coded to 50 Ruppees
        order.delivery_fee = 50.0
    
    save_db(order, "ItemOrder")

    return order.delivery_fee, msg
    
def order_distance(order):
    if order.user_address_id != 0 and order.user_address_id != None:
        address = UserAddress.query.filter_by(id = order.user_address_id).first()
        store = Store.query.filter_by(id = order.store_id, deleted_at = None).first()

        store_cords = (float(store.store_latitude), float(store.store_longitude))
        user_address_cords = (float(address.latitude), float(address.longitude))

        distance = GetDistance(store_cords,user_address_cords)

        return round(distance, 2)
    
    distance = "Unable to Calculate"

    return distance


def calculate_hub_order_total(order):
    hub_order_id = order.id
    items = HubOrderLists.query.filter_by(hub_order_id=hub_order_id).filter_by(deleted_at = None).filter_by(status = 1).all()
    taxes = HubTaxes.query.filter_by(hub_id = order.hub_id).all()

    order_total = 0
    total_tax = 0

    # if order.total_tax:
    #     total_tax = order.total_tax

    for item in items:
        price_item = 0 if not item.product_selling_price else item.product_selling_price
        quantity = item.quantity
        order_total = order_total + price_item*quantity 
    
   
    if order.assigned_to_da == None:

        if order.order_created == None:
            for tax in taxes:

                hub_order_tax = HubOrderTax.query.filter_by(hub_order_id = order.id).filter_by(tax_id = tax.id).first()

                calculated = 0

                if tax.tax_type == 1:
                    calculated = order_total * (tax.amount / 100)
                else:
                    calculated = tax.amount

                if tax.deleted_at != None:
                    if hub_order_tax:
                        hub_order_tax.deleted_at = datetime.datetime.utcnow()
                        save_db(hub_order_tax,"HubOrderTax")

                else:
                    if not hub_order_tax:
                    
                        new_hub_order_tax = HubOrderTax(
                            hub_order_id = order.id,
                            tax_id = tax.id,
                            tax_name = tax.name,
                            tax_type = tax.tax_type,
                            amount = tax.amount,
                            calculated = calculated,
                            created_at = datetime.datetime.utcnow()
                        )

                        save_db(new_hub_order_tax, "HubOrderTax")

                    else:
                        hub_order_tax.tax_name = tax.name,
                        hub_order_tax.tax_type = tax.tax_type,
                        hub_order_tax.amount = tax.amount,
                        hub_order_tax.calculated = calculated
                        hub_order_tax.updated_at = datetime.datetime.utcnow()

                        save_db(hub_order_tax, "ItemOrderTax")

                    total_tax += calculated
            
        else:
            hub_order_taxs = HubOrderTax.query.filter_by(hub_order_id = order.id).filter_by(deleted_at = None).all()

            calculated = 0

            for hub_order_tax in hub_order_taxs:

                if hub_order_tax.tax_type == 1:
                    calculated = order_total * (hub_order_tax.amount / 100)
                else:
                    calculated = hub_order_tax.amount

                hub_order_tax.calculated = calculated
                hub_order_tax.updated_at = datetime.datetime.utcnow()

                save_db(hub_order_tax, "HubOrderTax")

                total_tax += calculated
        
    else:
        total_tax = order.total_tax
        
    total_tax = float("{:.2f}".format(total_tax))
    grand_order_total = order_total + total_tax

    if order.delivery_fee:
        grand_order_total = grand_order_total + order.delivery_fee

    if grand_order_total - int(grand_order_total) > 0:
        grand_order_total = int(grand_order_total) + 1 
    
    order.order_total = order_total
    order.grand_order_total = grand_order_total
    order.total_tax = total_tax
    order.updated_at = datetime.datetime.utcnow()

    save_db(order, "HubOrder")

    
    return order_total, grand_order_total


