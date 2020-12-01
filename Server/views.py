from flask import Flask, url_for, render_template, request, redirect, session

app = Flask(__name__)
app.static_folder = "../static"
app.template_folder = "../template"
#app.config.from_object('config')

@app.route('/index')
@app.route('/')
def index():

    return render_template("accueil.html")

@app.route('/vigie')
def index():

    return render_template("vigie.html")

@app.route('/Webmaster')
def index():

    return render_template("webmaster.html")