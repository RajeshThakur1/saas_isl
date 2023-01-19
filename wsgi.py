import os
import unittest
from app.main.model import user,store,storeItems,itemOrders,itemOrderLists,quantityUnit,category,menuCategory,locality,city,storeMenuCategory,storeCategory,storeItemUploads,storeItemVariable
from app.main.model import storeLocalities,cityCategories,superAdmin
from app.main.model import *
from app.main.model import user,store,userAddress,admin,merchant,storeMerchant,merchantTransactions,userOtp
from app.main.model import coupon,couponCategories,couponCities,userCities,supervisor
from app.main.model import coupon,couponCategories,couponCities,couponMerchant,couponStores, storeMis
from app.main.model import cityMisDetails, misDetails, storeTaxes, itemOrderTax, deliveryAgent,session
from app.main.model import refund,transactions,notification
from app.main.model import progress, hub, distributor, hubBankDetails, hubTaxes, hubOrderTax, hubOrderList, hubOrders
from flask_migrate import Migrate, MigrateCommand
from flask_script import Manager
from app import blueprint
from app.main import create_app, db
from app.main.service.v1.store_payments_service import create_store_payments

app = create_app('development')
app.register_blueprint(blueprint)
app.app_context().push()

manager = Manager(app)

migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename='running_logs.log', level=logging.INFO, format=logging_str,
                    filemode="a")

@manager.command
def run():
    logging.info("testing")
    app.run(host='0.0.0.0', port = 8002, debug=True)
    # app.run(port=8001,debug=True)




@manager.command
def test():
    """Runs the unit tests."""
    tests = unittest.TestLoader().discover('app/test', pattern='test*.py')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    if result.wasSuccessful():
        return 0
    return 1

if __name__ == '__main__':
    manager.run()
