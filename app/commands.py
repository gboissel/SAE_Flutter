from .extensions import db
from .models import Aeroport, Vols
from .myapp import app
from datetime import datetime

@app.cli.command()
def syncdb():
    db.create_all()
    db.session.query(Vols).delete()
    db.session.query(Aeroport).delete()
    aer1 = Aeroport(CodeIATA='ORY',nomAeroport = 'Orly',CodePays='FR',ville = 'Paris')
    aer2 = Aeroport(CodeIATA='JFK',nomAeroport = 'New York-Kennedy',CodePays='US',ville = 'New York')

    vol = Vols(Compagnie= 'Air France',
               numVol = 134,
               dateheureDep = datetime.fromtimestamp(int('1773663528')),
               dateheureArr=datetime.fromtimestamp(int('1773749928')),
               terminalDep = 1,
               terminalArr = 2, 
               depart = aer1.CodeIATA, arriver = aer2.CodeIATA)
    db.session.add(aer1)
    db.session.add(aer2)
    db.session.add(vol)
    db.session.commit()