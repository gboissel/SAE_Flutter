from .extensions import db
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
    return Vols.query.all()

def get_vol(compagnie,numVol,dateheureDep):
    """Renvoie le vol correspondant à l'ID demander rien sinon"""
    if isinstance(dateheureDep, str):
        dateheureDep = datetime.fromisoformat(dateheureDep.replace('Z', '+00:00'))
    return Vols.query.get((compagnie,numVol,dateheureDep))

def create_vols(Compagnie,numVol,dateheureDep,dateheureArr,terminalDep,terminalArr,depart,arriver):
    """Creer une instance de Vol et l'ajoute a la BD"""
    if isinstance(dateheureDep, str):
        dateheureDep = datetime.fromisoformat(dateheureDep.replace('Z', '+00:00'))
    if isinstance(dateheureArr, str):
        dateheureArr = datetime.fromisoformat(dateheureArr.replace('Z', '+00:00'))
    vol = Vols(Compagnie=Compagnie,numVol=numVol,dateheureDep=dateheureDep,dateheureArr=dateheureArr,terminalDep=terminalDep,terminalArr=terminalArr,depart=depart,arriver=arriver)
    db.session.add(vol)
    db.session.commit()
    return vol


def modif_vol(CompagnieO, numVolO, dateheureDepO, Compagnie, numVol,
              dateheureDep, dateheureArr, terminalDep, terminalArr, depart,
              arriver):
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
    dt_dep_origine = datetime.fromtimestamp(dateheureDepO / 1000.0)
    vol = Vols.query.get((CompagnieO, numVolO, dt_dep_origine))
    vol.Compagnie = Compagnie
    vol.numVol = numVol
    vol.dateheureDep = datetime.fromtimestamp(dateheureDep / 1000.0)
    vol.dateheureArr = datetime.fromtimestamp(dateheureArr / 1000.0)
    vol.terminalDep = terminalDep
    vol.terminalArr = terminalArr
    vol.depart = depart
    vol.arriver = arriver
    db.session.commit()
    return vol

def delete_vol(Compagnie,numVol,dateheureDep):
    vol = Vols.query.get((Compagnie,numVol,datetime.fromtimestamp(dateheureDep / 1000.0)))
    if vol is None:
        return
    db.session.delete(vol)
    db.session.commit()


# Fonctions pour les Aeroport
def get_all_aeroport():
    return Aeroport.query.all()

def get_aeroport(CodeIATA):
    return Aeroport.query.get(CodeIATA)

def create_aeroport(CodeIATA,nomAeroport,CodePays,ville):
    aeroport = Aeroport(CodeIATA=CodeIATA,nomAeroport=nomAeroport,CodePays=CodePays,ville=ville)
    db.session.add(aeroport)
    db.session.commit()
    return aeroport

def modif_aeroport(CodeIATA,nomAeroport,CodePays,ville):
    aero = get_aeroport(CodeIATA)
    if aero is None:
        return
    aero.nomAeroport = nomAeroport
    aero.codePays = CodePays
    aero.ville = ville
    db.commit()

def delete_aeroport(CodeIATA):
    aero = Aeroport.query.get(CodeIATA)
    if aero is None:
        return
    db.session.delete(aero)
    db.session.commit()
