from flask import request
from flask_restx import Resource, Namespace , abort
from .api_model import *
# creation du namespace, racine de tous les endpoints
from .models import *
ns = Namespace("api")

@ns.route("/vols/")
class VolsCollections(Resource):
    @ns.marshal_list_with(vols_model)
    def get(self):
        """Récupère l'ensemble des vols"""
        return get_all_vols()
        
    @ns.marshal_with(vols_model)
    @ns.expect(vols_input_model)
    def post(self):
        """Créer un nouveau vols"""
        vol = create_vols(ns.payload["Compagnie"],
                    ns.payload["numVol"],
                    ns.payload["dateheureDep"],
                    ns.payload["dateheureArr"],
                    ns.payload["terminalDep"],
                    ns.payload["terminalArr"],
                    ns.payload["depart"],
                    ns.payload["arriver"])
        return vol,201



@ns.route("/vols/<string:CodeIATA>/<int:numVol>/<int:dateheureDep>")
class VolItem(Resource):

    @ns.marshal_with(vols_model)
    @ns.response(404,"Vol not found")
    def get(self,Compagnie,numVol,dateheureDep):
        """Récccupère un vol en fonction à partir de sa clée"""
        vol = get_vol(Compagnie,numVol,dateheureDep)
        if vol is None:
            abort(404,"Vol not found")
        return vol
        
    @ns.marshal_with(vols_model)
    @ns.expect(vols_input_model)
    @ns.response(404,"Vol not found")
    def put(self,Compagnie,numVol,dateheureDep):
        """modifie un vols"""
        vol = modif_vol(Compagnie,numVol,dateheureDep,
                    ns.payload["dateheureArr"],
                    ns.payload["terminalDep"],
                    ns.payload["terminalArr"],
                    ns.payload["depart"],
                    ns.payload["arriver"])
        if vol is None:
            abort(404,"Vol not found")
        return vol

    @ns.marshal_with(vols_model)
    def delete(self,Compagnie,numVol,dateheureDep):
        """Supprime un vols"""
        delete_vol(Compagnie,numVol,dateheureDep)
        return {}, 204
    
        


@ns.route("/aeroport/")
class AeroportCollections(Resource):
    @ns.marshal_list_with(aeroport_model)
    def get(self):
        """ Réccupère l'ensemble des aéroports """
        return get_all_aeroport()
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def post(self):
        """Créer un nouvel aéroport"""
        aero = create_aeroport(ns.payload["CodeIATA"],ns.payload["nomAeroport"],ns.payload["CodePays"],ns.payload["ville"])
        return aero,201


@ns.route("/aeroport/<int:CodeIATA>")
class AeroportItem(Resource):
    @ns.marshal_with(aeroport_model)
    @ns.response(404,"Aeroport not found")
    def get(self,CodeIATA):
        """Réccupère un Aeroport"""
        aero = get_aeroport(CodeIATA)
        if aero is None:
            abort(404,"Aeroport not found")
        return aero
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def put(self,CodeIATA):
        """modifie un aéropot"""
        aero = modif_aeroport(CodeIATA)
        if aero is None:
            abort(404,"Aeroport not found")
        return aero
    
    @ns.marshal_with(aeroport_model)
    def delete(self,CodeIATA):
        delete_aeroport(CodeIATA)
        return {}, 204
    


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