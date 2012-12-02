import json
import logging
import os

from flask import request, Blueprint, g, redirect, url_for, abort,\
                    render_template, jsonify
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import set_session_key, remove_session_key

log = logging.getLogger(__name__)

mod = Blueprint('user', __name__)

@mod.route("/create", methods=["POST"])
def create():
    log.info("Attempting to create new user.")
    log.debug("Info submitted by user: %s"%request.form)
    username = request.form.get("username", "")
    email = request.form.get("email", "")
    password = request.form.get("password", "")
    url = os.path.join(PARSE_BASE_API, "users")
    
    payload = {"username": username, "password": password,
                "email": email}
    r = requests.post(url, data=json.dumps(payload), headers=PARSE_HEADERS)
    if r.status_code != requests.codes.created:
        juser = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Error creating user: %s %s"%(r.status_code, r.json))
    else:
        log.info("User created successfully.")
        log.info("Redirecting to login.")
        return redirect(url_for("user.login", username=username, password=password))
    
@mod.route("/login", methods=["GET"])
def login():
    log.info("Attempting to login for user")
    log.debug("Info submitted by user: %s"%request.form)
    username = request.args.get("username", "")
    password = request.args.get("password", "")
    url = os.path.join(PARSE_BASE_API, "login")

    params = {"password": password, "username": username}
    r = requests.get(url, params=params, headers=PARSE_HEADERS)
    if r.status_code != requests.codes.ok:
        res = {"code":r.status_code,
                 "message":"No such username/password combination found."}
        log.info("Login failed.")
    else:
        log.info("User login successfully.")
        res = {"code":requests.codes.ok}
        set_session_key(r.json["objectId"])
    
    return jsonify(res)
    
@mod.route("/logout")
def logout():
    log.info("Logging out.")
    remove_session_key()
    return redirect(url_for("index"))
    