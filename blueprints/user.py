import json
import logging
import os

from flask import Blueprint, g, redirect, url_for, abort,\
                    render_template
import requests

from common.auth import set_session_key

log = logging.getLogger(__name__)

mod = Blueprint('user', __name__)

@mod.route("/create", methods=["POST"])
def create():
    log.info("Attempting to create new user.")
    
    username = request.forms['username']
    email = request.forms['email']
    password = request.forms['password']
    url = os.path.join(PARSE_BASE_API, "users")
    
    payload = {"username": username, "password": password,
                "email": email}
    r = requests.post(url, data=json.dumps(payload), headers=PARSE_HEADERS)
    if r.status_code != requests.codes.created:
        juser = {"code":r.status_code, "message":r.json["error"]}
    else:
        juser = {"code":requests.codes.ok,
                 "userId":r.json["objectId"],
                 "sessionToken":r.json["sessionToken"]}
        set_session_key(r.json["objectId"])

    return json.dumps(juser)