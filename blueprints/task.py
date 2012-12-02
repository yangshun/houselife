import json
import logging
import os

from flask import request, Blueprint, g, redirect, url_for, abort,\
                    render_template, Response
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import login_required, set_session_key, remove_session_key
from common import TASK_STATUS_OPEN, TASK_STATUS_COMPLETED

log = logging.getLogger(__name__)

mod = Blueprint('task', __name__)

@mod.route("/create", methods=["POST"])
@login_required
def create():
    log.info("Attempting to create new task.")
    log.debug("Info submitted by user: %s"%request.form)
    household_id = request.form.get("household_id", "")
    description = request.form.get("description", "")
    title = request.form.get("title", "")
    assignee_id = request.form.get("assignee_id", "")
    location = request.form.get("location", "")
    status = TASK_STATUS_OPEN
    
    if not household_id:
        res = {"code":requests.codes.bad_request,
               "message":"No household ID."}
        return Response(json.dumps(res), mimetype="application/json")

    url = os.path.join(PARSE_BASE_API, "classes/task")
    
    payload = {"household_id": household_id, "description": description,
                "title": title, "assignee_id": assignee_id,
                "location": location, "status": status}
    r = requests.post(url, data=json.dumps(payload), headers=PARSE_HEADERS)
    if r.status_code != requests.codes.created:
        jtask = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Error creating new task: %s %s"%(r.status_code, r.json))
    else:
        log.info("Task created successfully.")
        jtask = r.json
        log.debug(json.dumps(jtask))
        
    return Response(json.dumps(jtask), mimetype="application/json")
    
@mod.route("/<task_id>s/delete", methods=["POST"])
@login_required
def delete(task_id):
    log.info("Attempting to delete new task.")
    if not task_id:
        res = {"code":requests.codes.bad_request,
               "message":"No task ID."}
        return Response(json.dumps(res), mimetype="application/json")

    url = os.path.join(PARSE_BASE_API, "classes/task", task_id)

    r = requests.delete(url, headers=PARSE_HEADERS)
    
    if r.status_code != requests.codes.ok:
        res = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Failed to delete task %s: %s %s"%(task_id, 
                                                    r.status_code, r.json))
    else:
        log.info("Task deleted successfully.")
        res = {"code":r.status_code, "message": "Task deleted successfully."}
    
    return Response(json.dumps(res), mimetype="application/json")

@mod.route("/<task_id>", methods=["POST"])
@login_required
def edit(task_id):
    log.info("Attempting to edit task %s."%task_id)
    if not task_id:
        res = {"code":requests.codes.bad_request,
               "message":"No task ID."}
        return Response(json.dumps(res), mimetype="application/json")
    
    description = request.form.get("description", "")
    title = request.form.get("title", "")
    assignee_id = request.form.get("assignee_id", "")
    location = request.form.get("location", "")
    status = int(request.form.get("status"))
    
    url = os.path.join(PARSE_BASE_API, "classes/task", task_id)
    
    payload = {"description": description, "title": title,
               "assignee_id": assignee_id, "location": location,
               "status": status}
    r = requests.put(url, data=json.dumps(payload), headers=PARSE_HEADERS)
    
    if r.status_code != requests.codes.ok:
        res = {"code":r.status_code, "message":r.json["error"]}
        log.debug("Failed to edit task %s: %s %s"%(task_id, 
                                                    r.status_code, r.json))
    else:
        log.info("Task edited successfully.")
        res = {"code":r.status_code,
               "message":"Task %s edited successfully."%title}
    
    return Response(json.dumps(res), mimetype="application/json")