import logging
from functools import wraps

from flask import session, url_for, request, redirect, g

log = logging.getLogger(__name__)

SESSION_KEY = "_hl_login_id"

def login_required(func):
    """
    A wrapper function for ensuring that user is loggedin when
    accessing pages that require them to do so.
    Usage: put @login_required before method declaration.
    """
    
    @wraps(func)
    def check_login(*args, **kwargs):
        if session.get(SESSION_KEY, None) is None:
            log.info("User is not logged in. User came from %s. Redirecting to login page..."%request.url)
            return redirect(url_for("login"))

        g.user_id = session.get(SESSION_KEY)
        
        return func(*args, **kwargs)

    return check_login
    
def set_session_key(val):
    session[SESSION_KEY] = val

def remove_session_key():
    session.pop(SESSION_KEY, None)
    g.user_id = None