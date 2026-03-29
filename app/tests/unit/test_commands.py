from models import Aeroport, Vols

def test_syncdb_command(runner):
    """
    Teste la commande 'flask syncdb' définie dans commands.py.
    Vérifie la suppression des anciennes données et l'insertion des nouvelles.
    """
    # Exécution de la commande via le runner pytest-flask
    result = runner.invoke(args=["syncdb"])
    
    # Vérification du succès de l'exécution
    assert result.exit_code == 0
    
    # Vérification que les aéroports par défaut sont créés
    assert Aeroport.query.get("AF") is not None
    assert Aeroport.query.get("JFK") is not None
    
    # Vérification que le vol par défaut est inséré
    assert Vols.query.count() == 1
    vol = Vols.query.first()
    assert vol.Compagnie == 'Air France'
    assert vol.numVol == 134