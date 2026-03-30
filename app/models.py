from sqlalchemy import text
from extensions import db
from datetime import datetime
class Aeroport(db.Model):
    """Modèle SQLAlchemy représentant un aéroport."""
    __tablename__='aeroport'
    CodeIATA = db.Column(db.String(5),primary_key=True)
    nomAeroport = db.Column(db.String(50))
    CodePays =db.Column(db.String(2))
    ville = db.Column(db.String(50))

    vols_depart = db.relationship("Vols",back_populates="rel_depart",foreign_keys="Vols.depart")
    vols_arriver = db.relationship("Vols",back_populates="rel_arriver",foreign_keys="Vols.arriver")

class Vols(db.Model):
    """Modèle SQLAlchemy représentant un vol."""
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
    """Récupère un vol à partir de sa clé primaire composite.

    Args:
        compagnie (str): Nom de la compagnie.
        numVol (int): Numéro du vol.
        dateheureDep (datetime | str): Date/heure de départ.

    Returns:
        Vols | None: Le vol trouvé, sinon None.
    """
    if isinstance(dateheureDep, str):
        dateheureDep = datetime.fromisoformat(dateheureDep.replace('Z', '+00:00'))
    return Vols.query.get((compagnie,numVol,dateheureDep))

def create_vols(Compagnie,numVol,dateheureDep,dateheureArr,terminalDep,terminalArr,depart,arriver):
    """Crée un vol puis l'enregistre en base de données.

    Args:
        Compagnie (str): Nom de la compagnie.
        numVol (int): Numéro du vol.
        dateheureDep (datetime | str): Date/heure de départ.
        dateheureArr (datetime | str): Date/heure d'arrivée.
        terminalDep (int): Terminal de départ.
        terminalArr (int): Terminal d'arrivée.
        depart (str): Code IATA de l'aéroport de départ.
        arriver (str): Code IATA de l'aéroport d'arrivée.

    Returns:
        Vols: Le vol créé.
    """
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
    """Récupère un aéroport à partir de son code IATA.

    Args:
        CodeIATA (str): Code IATA de l'aéroport.

    Returns:
        Aeroport | None: L'aéroport trouvé, sinon None.
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
    db.session.commit()

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


def get_destinations_by_escales(ville_depart='Paris', code_pays='FR', escales='0'):
    """Retourne les destinations atteignables selon le nombre d'escales.

    Args:
        ville_depart (str): Ville de départ.
        code_pays (str): Code pays de la ville de départ.
        escales (str): Nombre d'escales autorisé ('0', '1', '2' ou 'all').

    Returns:
        list[dict[str, str]]: Liste de destinations avec code IATA et ville.
    """
    if escales == '0':
        query = text(
            """
            select distinct A2.CodeIATA, A2.ville
            from vols V
            join aeroport A1 on V.depart = A1.CodeIATA
            join aeroport A2 on V.arriver = A2.CodeIATA
            where A1.ville = :ville_depart and A1.CodePays = :code_pays
            """
        )
    elif escales == '1':
        query = text(
            """
            select distinct A3.CodeIATA, A3.ville
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
            select distinct A4.CodeIATA, A4.ville
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
                union all
                select A_dest.CodeIATA, A_dest.ville, V_suiv.dateheureArr
                from Trajets T
                join vols V_suiv on V_suiv.depart = T.code_iata
                join aeroport A_dest on V_suiv.arriver = A_dest.CodeIATA
                where V_suiv.dateheureDep > T.heure_arriver
            )
            select distinct code_iata as CodeIATA, ville_actuelle as ville from Trajets
            """
        )
    else:
        return []

    result = db.session.execute(
        query,
        {'ville_depart': ville_depart, 'code_pays': code_pays},
    )

    return [{'codeIATA': row[0], 'ville': row[1]} for row in result]