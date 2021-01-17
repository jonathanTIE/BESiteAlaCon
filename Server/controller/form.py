from flask import session
from Server.Data.db import get_plane_id, get_parking_free

def select_parking_with_session(request):
    #TODO : vérification de champs (id Avion)
    idPlane = get_plane_id(request.form['plane'])['idAvion']
    idParking = request.form['parking']
    idUser = session.get('idUser')
    return(idPlane, idParking, idUser)

def get_free_park(request):
    authorized = { #plane is of category '', gives stands of category ''
        'A':['A'],
        'B': ['A','B'],
        'C': ['A','B','C']
    }
    category = authorized.get(request.form["category"], None)
    if category == None:
        raise Exception("invalid category given by user")
    data = get_parking_free(int(request.form['qtPark']), category)
    return data
