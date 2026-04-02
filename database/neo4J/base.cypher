// 1. Nettoyage complet [cite: 1]
MATCH (n) DETACH DELETE n;

// 2. Création des nœuds et des liens de localisation en un bloc [cite: 2, 3]
CREATE (paris:Ville {nom: 'Paris'}),
       (rio:Ville {nom: 'Rio'}),
       (londres:Ville {nom: 'Londres'}),
       (ny:Ville {nom: 'New York'}),
       (la:Ville {nom: 'Los Angeles'}),
       (tokyo:Ville {nom: 'Tokyo'}),
       (cdg:Aeroport {code: 'CDG', nom: 'Charles de Gaulle'}),
       (gig:Aeroport {code: 'GIG', nom: 'Galeao'}),
       (lhr:Aeroport {code: 'LHR', nom: 'Heathrow'}),
       (jfk:Aeroport {code: 'JFK', nom: 'John F. Kennedy'}),
       (lax:Aeroport {code: 'LAX', nom: 'Los Angeles Intl'}),
       (hnd:Aeroport {code: 'HND', nom: 'Haneda'})
CREATE (cdg)-[:SITUE_A]->(paris),
       (gig)-[:SITUE_A]->(rio),
       (lhr)-[:SITUE_A]->(londres),
       (jfk)-[:SITUE_A]->(ny),
       (lax)-[:SITUE_A]->(la),
       (hnd)-[:SITUE_A]->(tokyo)
       
// 3. Création des relations de vols [cite: 4, 5, 6, 7, 8]
CREATE (cdg)-[:VOL_DIRECT {num: 'AF442', dep: 1300, arr: 1900}]->(gig),
       (cdg)-[:VOL_DIRECT {num: 'AF100', dep: 800, arr: 1000}]->(lhr),
       (lhr)-[:VOL_DIRECT {num: 'BA200', dep: 1400, arr: 2200}]->(jfk),
       (jfk)-[:VOL_DIRECT {num: 'UA300', dep: 2300, arr: 400}]->(lax),
       (jfk)-[:VOL_DIRECT {num: 'JL005', dep: 1100, arr: 1500}]->(hnd);