from flask import Flask
from flask import render_template

app = Flask(__name__)


@app.route("/")
def frontPage():
    return render_template('main.html')


@app.route("/login")
def login():
    return render_template('login.html')

if __name__ == "__main__":
    app.debug = True
    app.run()
