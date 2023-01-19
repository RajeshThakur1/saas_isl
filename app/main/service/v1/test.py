import logging
import os

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename='running_logs.log', level=logging.INFO, format=logging_str,
                    filemode="a")

logging.info("test")