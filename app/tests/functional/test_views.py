def test_api_aeroport(client):
    # Test POST
    data = {"CodeIATA": "LHR", "nomAeroport": "London", "CodePays": "GB", "ville": "London"}
    res = client.post("/api/aeroport/", json=data)
    assert res.status_code == 201

    # Test GET Collections
    res = client.get("/api/aeroport/")
    assert len(res.json) >= 1

    # Test GET Item
    res = client.get("/api/aeroport/LHR/")
    assert res.status_code == 200

    # Test 404
    assert client.get("/api/aeroport/NULL/").status_code == 404

def test_api_vols(client):
    # Setup
    client.post("/api/aeroport/", json={"CodeIATA": "ORY", "nomAeroport": "Orly", "CodePays": "FR", "ville": "Paris"})
    client.post("/api/aeroport/", json={"CodeIATA": "JFK", "nomAeroport": "JFK", "CodePays": "US", "ville": "NY"})
    
    vol_data = {
        "Compagnie": "AF", "numVol": 123, "dateheureDep": "2026-05-01T12:00:00Z",
        "dateheureArr": "2026-05-01T20:00:00Z", "terminalDep": 1, "terminalArr": 2,
        "depart": "ORY", "arriver": "JFK"
    }
    # Test POST
    res = client.post("/api/vols/", json=vol_data)
    assert res.status_code == 201

    # Test GET Collections
    res = client.get("/api/vols/")
    assert res.status_code == 200