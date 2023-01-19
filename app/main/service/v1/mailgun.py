import requests
from app.main.config import MAILGUN_API_KEY, MAILGUN_MESSAGES_ENDPOINT, test_server_domain,MAILING_HOST

import os
import logging

logging_str = "[%(asctime)s: %(levelname)s: %(module)s]: %(message)s"
log_dir = "/tmp/mailgun_service/logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(filename=os.path.join(log_dir, 'running_logs.log'), level=logging.INFO, format=logging_str,
                    filemode="a")

def send_mail(email, html, subject, domain=test_server_domain):

    resp = requests.post(MAILGUN_MESSAGES_ENDPOINT,
                        auth=("api", MAILGUN_API_KEY),
                        data={"from": f'{domain}@{MAILING_HOST}',
                              "to": email,
                              "subject": subject,
                              "html": html}
                        )
    return resp


