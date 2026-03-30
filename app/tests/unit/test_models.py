from app.models import *

def test_aeroport_functions(app):
    # Create et Get
    aero = create_aeroport("CDG", "Charles de Gaulle", "FR", "Paris")
    assert get_aeroport("CDG").nomAeroport == "Charles de Gaulle"
    assert len(get_all_aeroport()) == 1
    
    modif_aeroport("CDG", "Paris-CDG", "FR", "Roissy")
    assert get_aeroport("CDG").ville == "Roissy"
    
    # Delete
    delete_aeroport("CDG")
    assert get_aeroport("CDG") is None
    # Test suppression inexistante (pour le coverage)
    delete_aeroport("NONEXIST")

def test_vols_functions(app):
    create_aeroport("ORY", "Orly", "FR", "Paris")
    create_aeroport("JFK", "JFK", "US", "New York")
    
    # Create
    dt_dep = "2026-03-30T10:00:00"
    vol = create_vols("AF", 100, dt_dep, "2026-03-30T18:00:00", 1, 2, "ORY", "JFK")
    assert vol.numVol == 100
    
    # Get et Delete
    assert get_vol("AF", 100, dt_dep) is not None
    delete_vol("AF", 100, vol.dateheureDep)
    assert get_vol("AF", 100, dt_dep) is None