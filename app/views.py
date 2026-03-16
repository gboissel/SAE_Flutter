from flask_restx import Resource, Namespace
from .api_model import *
# creation du namespace, racine de tous les endpoints
from .models import *
ns = Namespace("api")

@ns.route("/vols")
class VolsCollections(Resource):
    @ns.marshal_list_with(vols_models)
    def get(self):
        return get_all_vols()