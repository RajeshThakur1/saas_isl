from app.main.model.quantityUnit import QuantityUnit
from app.main.util.v1.database import save_db
from sqlalchemy import func
from app.main.model.apiResponse import ApiResponse
from app.main.service.v1.auth_helper import Auth
from flask import request, jsonify
from app.main.model.menuCategory import MenuCategory
from app.main.service.v1.store_item_service import create_store_item
from app.main.config import UPLOAD_FOLDER, download_dir
from app.main.model.progress import Progress
from flask import request

import os
import json
import datetime
import uuid

import pandas as pd


def create_excel(data, filename):
    df = pd.DataFrame(data)
    df.to_excel(download_dir+filename)
    url = request.base_url + '/download/'+filename
    url = url.replace("/superadmin/dashboard/detailed_mis_report" , "")
    return url



