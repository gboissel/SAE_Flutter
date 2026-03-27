from flask import request
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


@ns.route("/destinations")
class DestinationsCollections(Resource):
    @ns.marshal_list_with(destination_model)
    def get(self):
        """Récupère les destinations possibles selon le nombre d'escales"""
        ville_depart = request.args.get('ville', 'Paris')
        code_pays = request.args.get('pays', 'FR')
        escales = request.args.get('escales', '0')

        if escales not in {'0', '1', '2', 'all'}:
            escales = '0'

        return get_destinations_by_escales(ville_depart, code_pays, escales)