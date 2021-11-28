from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Webserver'

@app.route('/dummy')
def dummy():
    return 'This is a dummy route!'
