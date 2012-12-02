import json
import logging
import os

from flask import Flask, request, redirect, url_for, g, abort, session, \
                    render_template
import requests


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

def attach_blueprints_to_app():
    app.register_blueprint(user.mod, url_prefix='/%s' % user.mod.name)

if __name__ == '__main__':
    attach_blueprints_to_app()
    
    app.secret_key = "|D\xd1s/\x98\xdb\xed\x89Mz\xae\x88\xfdx<\rx\xa7`%\x9c\xd3\x89"
    app.run(host=HOST, port=PORT, debug=DEBUG_MODE)