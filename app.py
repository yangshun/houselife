from flask import Flask
from flask import render_template, redirect, url_for

app = Flask(__name__)


@app.route("/")
def frontPage():
    return redirect(url_for('login'))


@app.route("/login")
def login():
    return render_template('login.html')

if __name__ == "__main__":
    app.debug = True
    app.run()
