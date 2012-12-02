import json
import logging
import os

from flask import request, Blueprint, g, redirect, url_for, abort,\
                    render_template, Response
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import login_required, set_session_key, remove_session_key
from common import TASK_STATUS_OPEN, TASK_STATUS_COMPLETED

from app import realtime

log = logging.getLogger(__name__)

mod = Blueprint('task', __name__)

@mod.route("/", methods=["POST"])
@login_required
def create():
    log.info("Attempting to create new task.")
    log.debug("Info submitted by user: %s"%request.json)
    household_id = request.json.get("household_id", "")
    description = request.json.get("description", "")
    title = request.json.get("title", "")
    assignee_id = request.json.get("assignee_id", "")
    location = request.json.get("location", "")
    status = TASK_STATUS_OPEN
    
    if not household_id:
        res = {"code":requests.codes.bad_request,
               "message":"No household ID."}
        return Response(json.dumps(res), mimetype="application/json")

    url = os.path.join(PARSE_BASE_API, "classes/task")
    
    payload = {"household_id": household_id, "description": description,
                "title": title, "assignee_id": assignee_id,
                "location": location, "status": status}
    headers = PARSE_HEADERS
    headers["Content-Type"] = "application/json"

    r = requests.post(url, data=json.dumps(payload), headers=headers)
    if r.status_code != requests.codes.created:
        jtask = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Error creating new task: %s %s"%(r.status_code, r.json))
    else:
        log.info("Task created successfully.")
        jtask = r.json
        log.debug(json.dumps(jtask))

    realtime.add_message(jtask)
        
    return Response(json.dumps(jtask), mimetype="application/json")
    
@mod.route("/<task_id>", methods=["DELETE"])
@login_required
def delete(task_id):
    log.info("Attempting to delete new task.")
    if not task_id:
        res = {"code":requests.codes.bad_request,
               "message":"No task ID."}
        return Response(json.dumps(res), mimetype="application/json")

    url = os.path.join(PARSE_BASE_API, "classes/task", task_id)

    payload = {"status": 2}
    headers = PARSE_HEADERS
    headers["Content-Type"] = "application/json"
    r = requests.put(url, data=json.dumps(payload), headers=headers)

    if r.status_code != requests.codes.ok:
        res = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Failed to delete task %s: %s %s"%(task_id, 
                                                    r.status_code, r.json))
    else:
        log.info("Task deleted successfully.")
        res = {"code":r.status_code, "message": "Task deleted successfully."}
    
    return Response(json.dumps(res), mimetype="application/json")

@mod.route("/<task_id>", methods=["PUT"])
@login_required
def edit(task_id):
    log.info("Attempting to edit task %s."%task_id)
    if not task_id:
        res = {"code":requests.codes.bad_request,
               "message":"No task ID."}
        return Response(json.dumps(res), mimetype="application/json")
    
    description = request.json.get("description", "")
    title = request.json.get("title", "")
    assignee_id = request.json.get("assignee_id", "")
    location = request.json.get("location", "")
    status = int(request.json.get("status"))
    
    url = os.path.join(PARSE_BASE_API, "classes/task", task_id)
    
    payload = {"description": description, "title": title,
               "assignee_id": assignee_id, "location": location,
               "status": status}
    # a hack for older version of requests?
    headers = PARSE_HEADERS
    headers["Content-Type"] = "application/json"
    
    r = requests.put(url, data=json.dumps(payload), headers=headers)
    if r.status_code != requests.codes.ok:
        res = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Failed to edit task %s: %s %s"%(task_id, 
                                                    r.status_code, r.json))
    else:
        log.info("Task edited successfully.")
        res = {"code":r.status_code,
               "message":"Task %s edited successfully."%title}
    
    return Response(json.dumps(res), mimetype="application/json")