from flask import Flask, session, render_template, request, redirect, url_for
from Server.Data import db
import hashlib


class Statut(object):
    pass


def add_account(request):
    """

    :return: password (not hashed)
    """
    user = request.form['login']
    nom = request.form['nom']
    prenom = request.form['prenom']
    statut = request.form['radio-inline']
    email = request.form["email"]
    return db.add_userdata(email, nom, prenom, statut, user)


def connect_account(request):
    """

    :param request:
    :return: True if login/pwd correct, error message if incorrect
    """
    login = request.form['login']
    mdp = request.form['password']
    Default_password_crypted = hashlib.sha256(mdp.encode())
    Default_password_crypted = Default_password_crypted.hexdigest()
    print(request)
    res = db.getAuthData(login, Default_password_crypted)
    try:
        session["idUser"] = res[0]['idUser']
        session["nom"] = res[0]['nom']
        session["prenom"] = res[0]['prenom']
        session["login"] = res[0]['login']
        session["statut"] = res[0]['statut']
        session["mail"] = res[0]['mail']
        session["newMdp"] = res[0]['newMdp']
        msg = True
    except:
        msg = "Echec d'authentification : vérifiez le mdp ou le login"
    return msg


def update_pwd_account(request):
    pwd = request.form['inputPassword']
    pwdConfirmation = request.form['inputConfirmPassword']
    if pwd == pwdConfirmation:
        db.update_membreData('motPasse', session["idUser"], pwd, True)
        db.update_membreData('newMdp', session["idUser"], 0, False)
        session["newMdp"] = 0
    return redirect(url_for("vigie"))
