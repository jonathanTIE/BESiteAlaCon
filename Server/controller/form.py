from flask import session
from Server.Data.db import get_plane_id

def select_parking_with_session(request):
    #TODO : vérification de champs
    idPlane = get_plane_id(request.form['plane'])['idAvion']
    idParking = request.form['parking']
    idUser = session.get('idUser')
    return(idPlane, idParking, idUser)
