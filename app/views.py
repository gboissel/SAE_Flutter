from flask_restx import Resource, Namespace , abort
from api_model import *
# creation du namespace, racine de tous les endpoints
from models import *
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
        """Crée un nouveau vols"""
        vol = create_vols(ns.payload["Compagnie"],
                    ns.payload["numVol"],
                    ns.payload["dateheureDep"],
                    ns.payload["dateheureArr"],
                    ns.payload["terminalDep"],
                    ns.payload["terminalArr"],
                    ns.payload["depart"],
                    ns.payload["arriver"])
        return vol,201


@ns.route("/vols/<string:Compagnie>/<int:numVol>/<int:dateheureDep>/")
class VolItem(Resource):

    @ns.marshal_with(vols_model)
    @ns.response(404,"Vol not found")
    def get(self,Compagnie,numVol,dateheureDep):
        """Récupère un vol à partir de sa compagnie, son numéro de vol et la date de départ"""
        vol = get_vol(Compagnie,numVol,dateheureDep)
        if vol is None:
            abort(404,"Vol not found")
        return vol
        
    @ns.marshal_with(vols_model)
    @ns.expect(vols_input_model)
    @ns.response(404,"Vol not found")
    def put(self,Compagnie,numVol,dateheureDep):
        """Modifie les information du vol à partir de sa compagnie, son numéro de vol et la date de départ"""
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
        """Supprime le vol identifier à partir de sa compagnie, son numéro de vol et la date de départ"""
        delete_vol(Compagnie,numVol,dateheureDep)
        return {}, 204
    

@ns.route("/aeroport/")
class AeroportCollections(Resource):
    @ns.marshal_list_with(aeroport_model)
    def get(self):
        """ Récupère l'ensemble des aéroports """
        return get_all_aeroport()
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def post(self):
        """Créer un nouvel aéroport"""
        aero = create_aeroport(ns.payload["CodeIATA"],ns.payload["nomAeroport"],ns.payload["CodePays"],ns.payload["ville"])
        return aero,201


@ns.route("/aeroport/<string:CodeIATA>/")
class AeroportItem(Resource):
    @ns.marshal_with(aeroport_model)
    @ns.response(404,"Aeroport not found")
    def get(self,CodeIATA):
        """Récupère un Aeroport"""
        aero = get_aeroport(CodeIATA)
        if aero is None:
            abort(404,"Aeroport not found")
        return aero
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def put(self,CodeIATA):
        """Modifie l'aéropot identifier par son Code IATA"""
        aero = modif_aeroport(CodeIATA)
        if aero is None:
            abort(404,"Aeroport not found")
        return aero
    
    @ns.marshal_with(aeroport_model)
    def delete(self,CodeIATA):
        """Supprime l'aéropot identifier par son Code IATA"""
        delete_aeroport(CodeIATA)
        return {}, 204