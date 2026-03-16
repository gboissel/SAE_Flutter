from flask_restx import Resource, Namespace
# creation du namespace, racine de tous les endpoints
from .models import Aeroport,Vols
ns = Namespace("api")

@ns.route("/vols")
class VolsCollections(Resource):
    def get(self):
        return Vols.query.all()