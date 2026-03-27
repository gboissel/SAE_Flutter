from .extensions import db
from sqlalchemy import text
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

def modif_vol(Compagnie,numVol,dateheureDep):
    pass #TODO modif vol

def delete_vol(Compagnie,numVol,dateheureDep):
    vol = Vols.query.get((Compagnie,numVol,dateheureDep))
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


def get_destinations_by_escales(ville_depart='Paris', code_pays='FR', escales='0'):
    if escales == '0':
        query = text(
            """
            select distinct A2.ville
            from vols V
            join aeroport A1 on V.depart = A1.CodeIATA
            join aeroport A2 on V.arriver = A2.CodeIATA
            where A1.ville = :ville_depart and A1.CodePays = :code_pays
            """
        )
    elif escales == '1':
        query = text(
            """
            select distinct A3.ville
            from vols V1
            join aeroport A1 on V1.depart = A1.CodeIATA
            join aeroport A2 on V1.arriver = A2.CodeIATA
            join vols V2 on V2.depart = A2.CodeIATA
            join aeroport A3 on V2.arriver = A3.CodeIATA
            where A1.ville = :ville_depart and A1.CodePays = :code_pays
              and V2.dateheureDep > V1.dateheureArr
            """
        )
    elif escales == '2':
        query = text(
            """
            select distinct A4.ville
            from vols V1
            join aeroport A1 on V1.depart = A1.CodeIATA
            join aeroport A2 on V1.arriver = A2.CodeIATA
            join vols V2 on V2.depart = A2.CodeIATA
            join aeroport A3 on V2.arriver = A3.CodeIATA
            join vols V3 on V3.depart = A3.CodeIATA
            join aeroport A4 on V3.arriver = A4.CodeIATA
            where A1.ville = :ville_depart and A1.CodePays = :code_pays
              and V2.dateheureDep > V1.dateheureArr
              and V3.dateheureDep > V2.dateheureArr
            """
        )
    elif escales == 'all':
        query = text(
            """
            with recursive Trajets(code_iata, ville_actuelle, heure_arriver) as (
                select A2.CodeIATA, A2.ville, V.dateheureArr
                from vols V
                join aeroport A1 on V.depart = A1.CodeIATA
                join aeroport A2 on V.arriver = A2.CodeIATA
                where A1.ville = :ville_depart and A1.CodePays = :code_pays
                union
                select A_dest.CodeIATA, A_dest.ville, V_suiv.dateheureArr
                from Trajets T
                join vols V_suiv on V_suiv.depart = T.code_iata
                join aeroport A_dest on V_suiv.arriver = A_dest.CodeIATA
                where V_suiv.dateheureDep > T.heure_arriver
            )
            select distinct ville_actuelle as ville from Trajets
            """
        )
    else:
        return []

    result = db.session.execute(
        query,
        {'ville_depart': ville_depart, 'code_pays': code_pays},
    )

    return [{'ville': row[0]} for row in result]