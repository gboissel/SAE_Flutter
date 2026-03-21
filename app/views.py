from flask_restx import Resource, Namespace
from .api_model import *
# creation du namespace, racine de tous les endpoints
from .models import *
ns = Namespace("api")

@ns.route("/vols")
class VolsCollections(Resource):
    @ns.marshal_list_with(vols_models)
    def get(self):
        """ Réccupère l'ensemble des vols """
        return get_all_vols()
    
    @ns.marshal_list_with(vols_models)
    def post(self):
        """Créer un nouvelle vols"""
        pass

    @ns.marshal_list_with(vols_models)
    def delete(self):
        """Supprime un vols"""
        pass

    @ns.marshal_list_with(vols_models)
    def put(self):
        """modifie un vols"""
        pass

@ns.route("/aeroport")
class AeroportCollections(Resource):
    @ns.marshal_list_with(aeroport_model)
    def get(self):
        """ Réccupère l'ensemble des aéroports """
        return get_all_aeroport()
    
    @ns.marshal_list_with(aeroport_model)
    def post(self):
        """Créer un nouvel aéroport"""
        pass

    @ns.marshal_list_with(aeroport_model)
    def delete(self):
        """Supprime un aéroport"""
        pass

    @ns.marshal_list_with(aeroport_model)
    def put(self):
        """modifie un aéropot"""
        pass