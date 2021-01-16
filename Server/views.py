from flask import Flask, url_for, render_template, request, redirect, session, jsonify
from Server.Data import db
from Server.controller import Auth
from Server.controller import form

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

@app.route('/getAvionLibre', methods=['POST'])
def getPlaneFree():
    data = db.get_plane_free()
    return jsonify(data)

@app.route('/getParkingLibre', methods=['GET', 'POST'])
def getParkingFree():
    data = db.get_parking_free(3)
    return jsonify(data)

@app.route('/getAvionCategorie', methods=['POST'])
def getPlaneCat(immat):
    data = db.get_plane_cat(immat)
    return jsonify(data)

@app.route("/assignerAvion", methods=['POST'])
def assignPlane():
    #TODO : validation des données dans form
    ids = form.select_parking_with_session(request)
    return db.set_parking_choice(*ids)

@app.route("/supprimerAssociationsAvions", methods=['POST'])
def deletePlanes():
    print(db.reset_planes())
    return redirect(url_for('vigie'))

@app.route('/getPlane', methods=['POST'])
def getPlane():
    data = db.get_plane_free()
    return jsonify(data)

@app.route('/flightplan', methods=['POST'])
def flightplan():
    msg = "Yoh"
    return msg