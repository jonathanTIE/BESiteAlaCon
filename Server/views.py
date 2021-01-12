from flask import Flask, url_for, render_template, request, redirect, session, jsonify
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
    return render_template("accueil.html", msg=request.args.get('msg'))

@app.route('/vigie')
def vigie():
    return render_template("vigie.html")

@app.route('/webmaster')
def webmaster():
    return render_template("webmaster.html")

@app.route("/creation-compte")
def create_account():
    return render_template("compte.html")

@app.route("/build-account", methods=['POST'])
def build():
    Auth.add_account(request)
    return redirect(url_for('create_account'))


@app.route('/statistiques')
def stats():
    return render_template("statistiques.html")

@app.route('/connecter', methods=['POST'])
def connecter():
    msg = Auth.connect_account(request)

    if msg != True:
        return redirect(url_for('index', msg=msg))
    else:
        return redirect(url_for('vigie'))

@app.route('/maj-mdp', methods=['POST'])
def update_pwd():
    return Auth.update_pwd_account(request)

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/getParking', methods=['POST'])
def getParking():
    data = db.get_parkingData()
    return jsonify(data)


@app.route('/getWaypoint', methods=['POST'])
def getWaypoint():
    data = db.get_WaypointData()
    return jsonify(data)

@app.route('/getAvionLibre', methods=['POST','GET'])
def getAvionLibre():
    data = db.get_AvionLibre()
    return jsonify(data)


@app.route('/getParkingSolution', methods=['POST'])
def getPlaneFree():
    data = db.get_parking_free(3)
    return jsonify(data)