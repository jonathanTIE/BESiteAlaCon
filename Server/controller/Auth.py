from flask import Flask, session, render_template, request, redirect, url_for
from Server.Data import db

class Statut(object):
    pass

#def add_account(request):
#    user = request.form['login']
#    password = request.form['password']
#    return msg

def connect_account(request):
    """

    :param request:
    :return: True if login/pwd correct, error message if incorrect
    """
    login = request.form['login']
    mdp = request.form['password']
    print(request)
    res = db.getAuthData(login,mdp)
    #print(res)
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
        msg = "echec d'authentification : vérifiez le mdp/login"
    return msg