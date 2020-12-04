import mysql.connector
from mysql.connector import errorcode

config = {

        'user': 'root',
        'password': 'mysql',
        'host': 'localhost',
        'port': 3306,  # 8889 pour les macs
        'database': 'gsea19b_jonathan_corentin',  # nom de la BDD
        'raise_on_warnings': True,
}

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
"""
def get_membreData():

    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * FROM membre"
        cursor.execute(sql)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get membre Data: {}".format(err)

    return res

def del_membreData(idUser):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "DELETE FROM membre WHERE idUser=%s"
        param = (idUser,)
        cursor.execute(sql, param)
        cnx.commit()
        msg = "suppOK"
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        msg = "Failed delete membre Data: {}".format(err)

    return msg

def add_membreData(nom, idEquipe):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "INSERT INTO membre (nom, idEquipe) VALUES (%s, %s)"
        param = (nom, idEquipe)
        cursor.execute(sql, param)
        cnx.commit()
        msg = "addOK"
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        msg = "Failed add membre Data: {}".format(err)

    return msg

def update_membreData(champ,idUser,newvalue):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
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
def getAuthData(login,mdp):
    try:
        cnx = connexion()
        cursor = cnx.cursor()
        sql = "SELECT * FROM identification WHERE login=%s and motPasse=%s"
        param = (login, mdp)
        cursor.execute(sql, param)
        res = convert_dictionnary(cursor)
        close_bd(cursor,cnx)

    except mysql.connector.Error as err:
        res = "Failed get verifAuth Data: {}".format(err)

    return res