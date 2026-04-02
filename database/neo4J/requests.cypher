// On part d'une ville et de son aéroport
MATCH (v1:Ville)-[:SITUE_A]-(a1:Aeroport)

// On suit tous les chemins de vols possibles (*) vers un autre aéroport
MATCH p = (a1)-[:VOL_DIRECT*]->(a2:Aeroport)

// On récupère la ville liée à l'aéroport d'arrivée
MATCH (a2)-[:SITUE_A]-(v2:Ville)

// On filtre les boucles et on affiche les résultats
WHERE v1 <> v2
RETURN v1.nom AS Ville_Depart, 
       v2.nom AS Ville_Arrivee, 
       length(p) AS Distance_Arcs
ORDER BY Ville_Depart ASC;