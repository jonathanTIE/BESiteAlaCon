from flask import Flask, url_for, render_template, request, redirect, session
from Server.Data import db
from Server.controller import Auth

app = Flask(__name__)
app.static_folder = "../static"
app.template_folder = "../template"
#app.config.from_object('config')

@app.route('/index')
@app.route('/')
def index():
    #session['statut'] = 0 #pour tester le menu
    print(session.get('idUser'))
    return render_template("accueil.html")

@app.route('/vigie')
def vigie():
    return render_template("vigie.html")

@app.route('/webmaster')
def webmaster():
    return render_template("webmaster.html")

@app.route('/creation-compte')
def create_account():
    return render_template("compte.html")

@app.route('/statistiques')
def stats():
    return render_template("statistiques.html")

@app.route('/connecter', methods=['POST','GET'])
def connecter():
    print(request.form)
    msg = Auth.connect_account(request)

    if msg == "echec":
        return render_template("index.html", infoC = "Echec d'authentification")
    else:
        return redirect(url_for('vigie'))

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))