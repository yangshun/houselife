import json
import logging
import os

from flask import request, Blueprint, g, redirect, url_for, abort,\
                    render_template
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import set_session_key

log = logging.getLogger(__name__)

mod = Blueprint('user', __name__)

@mod.route("/create", methods=["POST"])
def create():
    log.info("Attempting to create new user.")
    log.debug("Info submitted by user: %s"%request.form)
    username = request.form["username"]
    email = request.form["email"]
    password = request.form["password"]
    url = os.path.join(PARSE_BASE_API, "users")
    
    payload = {"username": username, "password": password,
                "email": email}
    r = requests.post(url, data=json.dumps(payload), headers=PARSE_HEADERS)
    if r.status_code != requests.codes.created:
        juser = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Error creating user: %s %s"%(r.status_code, r.json))
    else:
        log.info("User created successfully.")
        juser = {"code":requests.codes.ok,
                 "userId":r.json["objectId"],
                 "sessionToken":r.json["sessionToken"]}
        set_session_key(r.json["objectId"])

    return json.dumps(juser)