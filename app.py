import json
import logging
import os

from flask import jsonfiy, Flask, request, redirect, url_for, g, abort,\
                    session, render_template
import requests

from blueprints import PARSE_BASE_API, PARSE_HEADERS
from common.auth import login_required

app = Flask(__name__)

logging.basicConfig(format='%(levelname)s %(asctime)s:    '\
                        '%(message)s', level=logging.DEBUG)
log = logging.getLogger(__name__)

HOST = "127.0.0.1"
PORT = 5000
DEBUG_MODE = True

@app.route("/")
def index():
    log.info("Re-routing to login page from index.")
    return redirect(url_for('login'))
    
@app.route("/login")
def login():
    return render_template('login.html')
    
@app.route("/logout")
def logout():
    return redirect(url_for('user.logout'))
    
@app.route("/dashboard/expenses")
@app.route("/dashboard/analytics")
@app.route("/dashboard/profile")
@app.route("/dashboard/todo")
@app.route("/dashboard")
@login_required
def dashboard():
    user_id = g.user_id
    log.info("Getting user data for dashboard. user %s"%user_id)
    url = os.path.join(PARSE_BASE_API, "users", user_id)

    r = requests.get(url, headers=PARSE_HEADERS)
    juser = r.json
    if not "household_id" in juser or not juser["household_id"]:
        juser["household_id"] = 0
    user = jsonfiy(juser)
    return render_template('main.html', user=user)  

def attach_blueprints_to_app():
    from blueprints import user
    app.register_blueprint(user.mod, url_prefix='/%s' % user.mod.name)
    
    from blueprints import task
    app.register_blueprint(task.mod, url_prefix='/%s' % task.mod.name)
    
    from blueprints import household
    app.register_blueprint(household.mod, url_prefix='/%s' % household.mod.name)

if __name__ == '__main__':
    attach_blueprints_to_app()
    
    app.secret_key = "|D\xd1s/\x98\xdb\xed\x89Mz\xae\x88\xfdx<\rx\xa7`%\x9c\xd3\x89"
    app.run(host=HOST, port=PORT, debug=DEBUG_MODE)