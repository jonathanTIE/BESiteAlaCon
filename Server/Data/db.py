from secrets import choice
from email.message import EmailMessage
import mysql.connector, string, hashlib
from mysql.connector import errorcode

config = {

        'user': 'root',
        'password': 'mysql',
        'host': 'localhost',
        'port': 3306,  # 8889 pour les macs
        'database': 'gsea19b_jonathan_corentin',  # nom de la BDD
        'raise_on_warnings': True,
}

#TODO : path départ et arrivé avion dans DB

"""
CREATE OR REPLACE VIEW vueparkinglibre AS
SELECT parking.idParking, parking.categorie FROM parking
	LEFT JOIN asso_avionparking ON parking.idParking = asso_avionparking.idParking
WHERE asso_avionparking.dateArrivee IS NULL

CREATE OR REPLACE VIEW vueAvionLibre AS
SELECT avions.idAvion FROM avions
	LEFT JOIN asso_avionparking ON avions.idAvion = asso_avionparking.idAvion
WHERE asso_avionparking.dateArrivee IS NULL
"""
#################################################################################################################
# connexion au serveur de la base de données


def connexion():
    cnx = ""
    try:
        cnx = mysql.connector.connect(**config)
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Mauvais login ou mot de passe de config de db")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("La Base de données n'existe pas.")
        else:
            print(err)
    if cnx == "":
        raise Exception("pb base de donnes : voir sur la console")
    return cnx


#################################################################################################################
# fermeture de la connexion au serveur de la base de données


def close_bd(cursor, cnx):
    cursor.close()
    cnx.close()


###################################################################################################
# transforme le résultat de la requete select en dictionnaire ayant pour index le nom des colonnes de la table en BD


def convert_dictionnary(cursor):
    columns = cursor.description
    result = []
    # reception des données sous forme de dictionnaire avec le nom des colonnes.
    for value in cursor.fetchall():
        tmp = {}
        for (index, column) in enumerate(value):
            tmp[columns[index][0]] = column
        result.append(tmp)
    return result


def getAuthData(login,mdp):

    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * FROM identification WHERE login=%s AND motPasse=%s"
        param=(login,mdp)
        cursor.execute(sql,param)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get membre Data: {}".format(err)

    return res



def add_userdata(email, nom:str, prenom:str, statut:int,login:str): #Return password not hashed
    try:
        cnx = connexion()
        cursor = cnx.cursor()

        alphabet = string.ascii_letters + string.digits
        while True:
            Default_password = ''.join(choice(alphabet) for i in range(10))
            if (any(c.islower() for c in Default_password)
                    and any(c.isupper() for c in Default_password)
                    and sum(c.isdigit() for c in Default_password) >= 3):
                break

# Lignes de code du dessus trouvées sur : https://riptutorial.com/fr/python/example/4000/creation-d-un-mot-de-passe-utilisateur-aleatoire
        print(Default_password)
        new_Mdp = 2
        Default_password_crypted = hashlib.sha256(Default_password.encode())
        Default_password_crypted = Default_password_crypted.hexdigest()

        sql = "INSERT INTO identification (nom, prenom, newMdp, motPasse, mail, login, statut) VALUES (%s, %s, %s, %s, %s,%s, %s)"
        param = (nom, prenom, new_Mdp, Default_password_crypted,email, login, statut)
        cursor.execute(sql, param)

        last_id = cursor.lastrowid
        cnx.commit()
        msg = Default_password
        close_bd(cursor, cnx)

    except mysql.connector.Error as err:
        last_id = 0
        msg = "Failed add membre Data: {}".format(err)

    return msg, last_id


def update_membreData(champ,idUser,newvalue,hash=False):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        if hash:
            newvalue = hashlib.sha256(newvalue.encode())
            newvalue = newvalue.hexdigest()
        sql = "UPDATE membre SET "+champ+" = %s WHERE idUser = %s;"
        param = (newvalue, idUser)
        cursor.execute(sql, param)
        cnx.commit()
        msg = "updateOK"
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        msg = "Failed update membre data: {}".format(err)

    return msg


"""
import smtplib, ssl
port = 587 # For starttls
smtp_server = "smtp.gmail.com" 
sender_email = "monsterdragon3.emperor@gmail.com"
receiver_email = "monsterdragon3.emperor@gmail.com"
password = "MONSTERDRAGON42500-Artemis//CHINOIS2"
message = "Subject: Creation de compte Vigie Annexe \n\n Votre login est: {""} \n\n Votre mot de passe est: {}".format(login, mdp_clair)

context = ssl.create_default_context() 
with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context) 
    server.login(sender_email, password) 
    server.sendmail(sender_email, receiver_email, message)
"""


def get_parkingData():
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """SELECT * FROM parking"""
        cursor.execute(sql)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get Parking Data: {}".format(err)

    return res

def get_parking_free(nb=3, cat=None):
    """

    :param nb:
    :param cat: array/list of the authorized categories
    :return:
    """
    if cat is None or len(cat)==1:
        cat = ["A"]
    if len(cat) == 1:
        cat.append("Z") #problem when formatting below if array/list is length 1
    cat = tuple(cat)
    #sql_cat = ', '.join('"{0}"'.format(w) for w in cat)#https://stackoverflow.com/questions/27882402/give-parameterlist-or-array-to-in-operator-python-sql
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """
            SELECT * FROM vueparkinglibre
            WHERE categorie IN {}
            ORDER BY RAND() LIMIT %s;
        """.format(cat)
        params=(nb, )
        cursor.execute(sql, params)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get Parking Data: {}".format(err)

    return res


def get_WaypointData():
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * FROM waypoint"
        cursor.execute(sql)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get Waypoint Data: {}".format(err)

    return res


def get_plane_free():
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * FROM vueavionlibre"  #Il n'est pas capable de lire les vues d'où le rouge mais ça fonctionne
        cursor.execute(sql)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get Avion Data: {}".format(err)

    return res




def set_parking_choice(planeId, parkingId, userId):
    """
    set automatically landing date with date of calling this function/sql request
    :param planeId:
    :param parkingId:
    :param userId:
    :return: true or false if request got executed or not
    """
 #return
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """
            INSERT INTO asso_avionparking (idAvion, idParking, dateArrivee, dateDepart, idUserValidation)
            VALUES 
            (%s, %s, NOW(), NULL, %s);
            """  #Il n'est pas capable de lire les vues d'où le rouge mais ça fonctionne
        params = (planeId, parkingId, userId)
        cursor.execute(sql, params)
        cnx.commit()
        res = "insertion in asso_avionParking executed"
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed assign to Parking of Agent: {}".format(err)

    return res

def get_plane_id(planeImmat):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT idAvion from avions WHERE immatAvion=%s;"  #Il n'est pas capable de lire les vues d'où le rouge mais ça fonctionne
        params = (planeImmat, )
        cursor.execute(sql, params)
        res = convert_dictionnary(cursor)[0]
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get plane ID: {}".format(err)


    return res

def get_plane_data(planeImmat):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * from avions WHERE immatAvion=%s;"  #Il n'est pas capable de lire les vues d'où le rouge mais ça fonctionne
        params = (planeImmat, )
        cursor.execute(sql, params)
        res = convert_dictionnary(cursor)[0]
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get plane category: {}".format(err)

    return res

def reset_planes():
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "DELETE FROM asso_avionparking"  #Il n'est pas capable de lire les vues d'où le rouge mais ça fonctionne
        cursor.execute(sql)
        res = "Supression asso_avionparking"
        cnx.commit()
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed to reset asso_parkingavion: {}".format(err)

    return res

def get_path(waypointBegin):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = 'SELECT asso_waypoint.Path from asso_waypoint WHERE asso_waypoint.WaypointBegin = %s LIMIT 1'
        params = (waypointBegin , )
        cursor.execute(sql, params)
        res = convert_dictionnary(cursor)[0]
        cnx.commit()
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed to get from db path from waypoint: {}".format(err)

    return res

def get_parking_terminal_waypoint(parking):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """
            SELECT waypointProche from parking
            WHERE idParking = %s; 
            """
        params = (parking , )
        cursor.execute(sql, params)
        res = convert_dictionnary(cursor)[0]
        cnx.commit()
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed to get terminal waypoint for parking : {}".format(err)

    return res

def get_gps_coordinates(path): #path should be an array
    pathOrderBy = ["`idWaypoint`"] + path
    pathOrderBy = tuple(pathOrderBy)
    path = tuple(path)
    try:
        cnx = connexion()
        cursor = cnx.cursor()

        sql = """
        (SELECT `waypoint`.`idWaypoint` AS `idWaypoint`, `waypoint`.`coordonnees` from `waypoint`
        WHERE `waypoint`.`idWaypoint` IN  {})
        UNION
        (SELECT `parking`.`idParking` AS `idWaypoint`, `parking`.`coordonnees` from `parking`
        WHERE `parking`.`idParking` IN  {})
        ORDER BY FIELD{}
        """.format(path, path, pathOrderBy)
        sql = sql.replace("\'`", "`")
        sql = sql.replace("`\'", "`")
        cursor.execute(sql)
        res = convert_dictionnary(cursor)
        cnx.commit()
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed to get gps coordinates for path : {}".format(err)


    return res
def get_ChartData(DateArr,DateDep):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """SELECT DISTINCT(idParking) as x, COUNT(idAvion) as y
              from asso_avionparking WHERE CAST(dateArrivee AS DATE)>=%s AND CAST(dateDepart AS DATE)<=%s GROUP BY idParking """
        param=(DateArr,DateDep)
        cursor.execute(sql,param)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get chartData Data: {}".format(err)

    return res

def set_departure_date_to_now(planeId):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = """
        UPDATE asso_avionparking
        SET dateDepart = NOW()
        WHERE idAvion = %s;
        """
        params = (planeId, )
        cursor.execute(sql, params)
        cnx.commit()
        res = "update in asso_avionParking executed"
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed update to Parking  {}".format(err)

    return res


# [{x:"Parking 1",y :3},{x:"Parking 2",y :3}]