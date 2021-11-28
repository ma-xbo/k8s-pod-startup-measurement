from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Webserver'

@app.route('/cakes')
def cakes():
    return 'Yummy cakes!'
