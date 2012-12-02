import json
import logging
import os

from flask import request, Blueprint, g, redirect, url_for, abort,\
                    render_template
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import login_required, set_session_key, remove_session_key

log = logging.getLogger(__name__)

mod = Blueprint('household', __name__)

@mod.route("/<household_id>/tasks", methods=["GET"])
@login_required
def household_tasks(household_id):
    log.info("Getting tasks for household id %s."%household_id)
    if household_id in (None, "0"):
        jtasks = {"code":requests.codes.ok,
                  "message":"User is not in any household yet."}
    else:
        url = os.path.join(PARSE_BASE_API, "classes/task")
        query = dict(household_id=household_id)
        params = dict(where=json.dumps(query))
        
        r = requests.get(url, params=params, headers=PARSE_HEADERS)
        if r.status_code != requests.codes.ok:
            log.info("Failed to get tasks.")
            jtasks = {"code":r.status_code,
                     "message":"Error getting tasks."}
        else:
            log.info("Got tasks for household %s successfully."%household_id)
            jtasks = r.json["results"]
            log.debug(jtasks)
    
    return json.dumps(jtasks)