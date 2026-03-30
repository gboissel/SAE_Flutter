from extensions import db
from datetime import datetime
class Aeroport(db.Model):
    __tablename__='aeroport'
    CodeIATA = db.Column(db.String(5),primary_key=True)
    nomAeroport = db.Column(db.String(50))
    CodePays =db.Column(db.String(2))
    ville = db.Column(db.String(50))

    vols_depart = db.relationship("Vols",back_populates="rel_depart",foreign_keys="Vols.depart")
    vols_arriver = db.relationship("Vols",back_populates="rel_arriver",foreign_keys="Vols.arriver")

class Vols(db.Model):
    __tablename__='vols'

    Compagnie = db.Column(db.String(50),primary_key = True)
    numVol = db.Column(db.Integer,primary_key = True)
    dateheureDep = db.Column(db.TIMESTAMP,primary_key = True)
    dateheureArr = db.Column(db.TIMESTAMP)
    terminalDep = db.Column(db.Integer)
    terminalArr = db.Column(db.Integer)
    depart = db.Column(db.String(5),db.ForeignKey("aeroport.CodeIATA"))
    arriver = db.Column(db.String(5),db.ForeignKey("aeroport.CodeIATA"))

    rel_depart = db.relationship("Aeroport", back_populates="vols_depart", foreign_keys=[depart])
    rel_arriver = db.relationship("Aeroport", back_populates="vols_arriver", foreign_keys=[arriver])


# Fonctions pour les vols
def get_all_vols():
    """
    Recupère tous les vols
    Returns:
        list[Vols]: ensembles des vols de la base de donnée
    """
    return Vols.query.all()

def get_vol(compagnie,numVol,dateheureDep):
    """Renvoie le vol correspondant à l'ID (la compagnie, le numéro du vol et la date-heure de départ) demander rien sinon"""
    if isinstance(dateheureDep, str):
        dateheureDep = datetime.fromisoformat(dateheureDep.replace('Z', '+00:00'))
    return Vols.query.get((compagnie,numVol,dateheureDep))

def create_vols(Compagnie,numVol,dateheureDep,dateheureArr,terminalDep,terminalArr,depart,arriver):
    """
    Creer une instance de Vol et l'ajouter a la BD
    Args:
        Compagnie (str): nom de la compagnie
        numVol (int): numéro du vol
        dateheureDep (int): date et heure de départ
        dateheureArr (int): date et heure d'arriver
        terminalDep (int): numéro du terminal de départ
        terminalArr (int): numéro du terminal d'arriver
        depart (str): Code IATA de l'aéroport de départ
        arriver (str): Code IATA de l'aéroport d'arriver

    Returns:
        Vols: le vol tout juste creer
    """
    if isinstance(dateheureDep, str):
        dateheureDep = datetime.fromisoformat(dateheureDep.replace('Z', '+00:00'))
    if isinstance(dateheureArr, str):
        dateheureArr = datetime.fromisoformat(dateheureArr.replace('Z', '+00:00'))
    vol = Vols(Compagnie=Compagnie,numVol=numVol,dateheureDep=dateheureDep,dateheureArr=dateheureArr,terminalDep=terminalDep,terminalArr=terminalArr,depart=depart,arriver=arriver)
    db.session.add(vol)
    db.session.commit()
    return vol

def modif_vol(Compagnie,numVol,dateheureDep,dateheureArr,terminalDep,terminalArr,depart,arriver):
    """
    Récupère l'instance correspondante aux paramètres de la clé primaire (Compagnie,numVol,dateheureDep)
    puis la modifie avec les valeur des autre paramètre  (dateheureArr,terminalDep,terminalArr,depart,arriver)
    Args:
        Compagnie (str): nom de la compagnie aérienne
        numVol (int): numéro du vol
        dateheureDep (int): heure du départ du vol (timestamp)
        dateheureArr (int): heure d'arriver du vol (timestamp)
        terminalDep (int): numéro du terminal de transport
        terminalArr (int): numéro du terminal d'arriver
        depart (str): CodeIATA de l'aéroport de départ
        arriver (str):  CodeIATA de l'aéroport de arriver
    """
    vol = Vols.query.get((Compagnie,numVol,dateheureDep))
    vol.dateheureArr = dateheureArr
    vol.terminalDep = terminalDep
    vol.terminalArr = terminalArr
    vol.depart = depart
    vol.arriver = arriver
    db.commit()

def delete_vol(Compagnie,numVol,dateheureDep):
    """
    supprime l'instance du vol de la BD
    Args:
        Compagnie (str): nom de la compagnie aérienne
        numVol (int): numéro du vol
        dateheureDep (int): heure du départ du vol
    """
    vol = Vols.query.get((Compagnie,numVol,dateheureDep))
    if vol is None:
        return
    db.session.delete(vol)
    db.session.commit()


# Fonctions pour les Aeroport
def get_all_aeroport():
    """
    Récupère tout les aeroports
    Returns:
        list[Aeroport]: ensembles des aéroport de la BD
    """
    return Aeroport.query.all()

def get_aeroport(CodeIATA):
    """
    Récupère un aéroport en fonction de son Code IATA

    Args:
        CodeIATA (str): Le code IATA de l'Aeroport
    Returns:
        Aeroport: l'instance de l'Aeroport demander, None si elle n'existe pas
    """
    return Aeroport.query.get(CodeIATA)

def create_aeroport(CodeIATA,nomAeroport,CodePays,ville):
    """
    Crée une nouvelle instance d'Aeroport et l'ajoute a la BD
    Args:
        CodeIATA (str): le code IATA du future aéroport
        nomAeroport (str): le nom de l'Aéroport
        CodePays (str): le code du pays 
        ville (str): le nom de la ville

    Returns:
        Aeroport: l'instance de l'aeroport tout juste creer
    """
    aeroport = Aeroport(CodeIATA=CodeIATA,nomAeroport=nomAeroport,CodePays=CodePays,ville=ville)
    db.session.add(aeroport)
    db.session.commit()
    return aeroport

def modif_aeroport(CodeIATA,nomAeroport,CodePays,ville):
    """
    Modifie une instance d'aéroport identifier par son code IATA
    Args:
        CodeIATA (str): le code IATA de l'aéroport
        nomAeroport (str): le nouveau nom de l'Aéroport
        CodePays (str): le nouveau  code du pays 
        ville (str): le nouveau nom de la ville
    """
    aero = get_aeroport(CodeIATA)
    if aero is None:
        return
    aero.nomAeroport = nomAeroport
    aero.codePays = CodePays
    aero.ville = ville
    db.commit()

def delete_aeroport(CodeIATA):
    """
    Supprime une instance d'aeroport de la BD
    Args:
        CodeIATA (str): le Code IATA 
    """
    aero = Aeroport.query.get(CodeIATA)
    if aero is None:
        return
    db.session.delete(aero)
    db.session.commit()