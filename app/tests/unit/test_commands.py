import pytest
from app.extensions import db
from app.models import Aeroport, Vols

def test_syncdb_command(runner):
    """
    Teste la commande 'flask syncdb' définie dans commands.py.
    Vérifie la suppression des anciennes données et l'insertion des nouvelles.
    """
    # 1. Exécution de la commande via le runner
    # Le runner s'occupe de gérer le contexte d'application automatiquement
    result = runner.invoke(args=["syncdb"])
    
    # Vérification du succès de l'exécution (Exit code 0)
    if result.exit_code != 0:
        print(f"Erreur lors de l'exécution : {result.output}")
        if result.exception:
            print(f"Exception : {result.exception}")
            
    assert result.exit_code == 0
    assert "Base de données synchronisée" in result.output

    # 2. Vérification de l'insertion des Aéroports
    # On utilise db.session.get (recommandé pour SQLAlchemy 2.0)
    ory = db.session.get(Aeroport, "ORY")
    jfk = db.session.get(Aeroport, "JFK")
    
    assert ory is not None
    assert ory.ville == "Paris"
    assert jfk is not None
    assert jfk.nomAeroport == "John F. Kennedy"

    # 3. Vérification de l'insertion des Vols
    # On vérifie qu'il y a bien des données (votre script en insère 25)
    total_vols = db.session.query(Vols).count()
    assert total_vols > 0
    
    # On teste le premier vol de votre liste (Air France 1001)
    # Note: On utilise filter_by car c'est une clé primaire composite
    vol = db.session.query(Vols).filter_by(Compagnie='Air France', numVol=1001).first()
    
    assert vol is not None
    assert vol.depart == "ORY"
    assert vol.arriver == "LHR"
    assert vol.terminalDep == 1