from .extensions import db

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

# Fonctions pour les Aeroport
def get_all_aeroport():
    return Aeroport.query.all()

def get_aeroport(id):
    return Aeroport.query.get(id)