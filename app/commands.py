from .extensions import db
from .models import Aeroport, Vols
from .myapp import app

@app.cli.command()
def syncdb():
    db.create_all()
    db.session.query(Vols).delete()
    db.session.query(Aeroport).delete()