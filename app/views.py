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
        """Récupère la liste de tous les vols.

        Returns:
            list[Vols]: Liste des vols.
        """
        return get_all_vols()
        
    @ns.marshal_with(vols_model)
    @ns.expect(vols_input_model)
    def post(self):
        """Crée un vol à partir du payload JSON.

        Returns:
            tuple[Vols, int]: Le vol créé et le code HTTP 201.
        """
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
        """Récupère un vol selon ses identifiants.

        Args:
            Compagnie (str): Compagnie du vol.
            numVol (int): Numéro du vol.
            dateheureDep (int): Horodatage de départ.

        Returns:
            Vols: Le vol correspondant, sinon 404.
        """
        vol = get_vol(Compagnie,numVol,dateheureDep)
        if vol is None:
            abort(404,"Vol not found")
        return vol
        
    @ns.marshal_with(vols_model)
    @ns.expect(vols_input_model)
    @ns.response(404,"Vol not found")
    def put(self,Compagnie,numVol,dateheureDep):
        """Met à jour un vol selon ses identifiants.

        Args:
            Compagnie (str): Compagnie du vol.
            numVol (int): Numéro du vol.
            dateheureDep (int): Horodatage de départ.

        Returns:
            Vols: Le vol modifié, sinon 404.
        """
        vol = modif_vol(Compagnie,numVol,dateheureDep,
                    ns.payload["Compagnie"],
                    ns.payload["numVol"],
                    ns.payload["dateheureDep"],
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
        """Supprime un vol selon ses identifiants.

        Args:
            Compagnie (str): Compagnie du vol.
            numVol (int): Numéro du vol.
            dateheureDep (int): Horodatage de départ.

        Returns:
            tuple[dict, int]: Réponse vide et code HTTP 204.
        """
        delete_vol(Compagnie,numVol,dateheureDep)
        return {}, 204
    

@ns.route("/aeroport/")
class AeroportCollections(Resource):
    @ns.marshal_list_with(aeroport_model)
    def get(self):
        """Récupère la liste de tous les aéroports.

        Returns:
            list[Aeroport]: Liste des aéroports.
        """
        return get_all_aeroport()
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def post(self):
        """Crée un aéroport à partir du payload JSON.

        Returns:
            tuple[Aeroport, int]: L'aéroport créé et le code HTTP 201.
        """
        aero = create_aeroport(ns.payload["CodeIATA"],ns.payload["nomAeroport"],ns.payload["CodePays"],ns.payload["ville"])
        return aero,201


@ns.route("/aeroport/<string:CodeIATA>/")
class AeroportItem(Resource):
    @ns.marshal_with(aeroport_model)
    @ns.response(404,"Aeroport not found")
    def get(self,CodeIATA):
        """Récupère un aéroport à partir de son code IATA.

        Args:
            CodeIATA (str): Code IATA de l'aéroport.

        Returns:
            Aeroport: L'aéroport correspondant, sinon 404.
        """
        aero = get_aeroport(CodeIATA)
        if aero is None:
            abort(404,"Aeroport not found")
        return aero
    
    @ns.marshal_with(aeroport_model)
    @ns.expect(aeroport_input_model)
    def put(self,CodeIATA):
        """Met à jour un aéroport à partir de son code IATA.

        Args:
            CodeIATA (str): Code IATA de l'aéroport.

        Returns:
            Aeroport: L'aéroport modifié, sinon 404.
        """
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
        """Liste les destinations atteignables selon les filtres de requête.

        Returns:
            list[dict[str, str]]: Destinations calculées selon les escales.
        """
        ville_depart = request.args.get('ville', 'Paris')
        code_pays = request.args.get('pays', 'FR')
        escales = request.args.get('escales', '0')

        if escales not in {'0', '1', '2', 'all'}:
            escales = '0'

        return get_destinations_by_escales(ville_depart, code_pays, escales)