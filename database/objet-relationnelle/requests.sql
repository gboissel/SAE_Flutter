PROMPT ==========================================
PROMPT 1. Nombre de personnes de l’équipage par fonction.
PROMPT ==========================================
SELECT 
    v.NumVol, 
    e.fonction, 
    COUNT(*) AS nombre_personnes
FROM 
    vols v, 
    TABLE(v.Equipage) e
GROUP BY 
    v.NumVol, 
    e.fonction
ORDER BY 
    v.NumVol, e.fonction;

PROMPT ==========================================
PROMPT 2. Nombre de vols par pilote.
PROMPT ==========================================

SELECT 
    e.nom, 
    COUNT(*) AS nb_vols
FROM 
    vols v, 
    TABLE(v.Equipage) e
WHERE 
    e.fonction = 'Pilote'
GROUP BY 
    e.nom;


PROMPT ==========================================
PROMPT 3. Impact des indices de qualité pour chaque vol.
PROMPT ==========================================

SELECT 
    v.NumVol,
    i.label,
    i.poids1 * i.poids2 AS impact
FROM 
    vols v, 
    TABLE(v.IndicesQualite) i;

PROMPT ==========================================
PROMPT 4. Impact moyen des indices de qualité.
PROMPT ==========================================

SELECT 
    i.label,
    AVG(i.poids1 * i.poids2) AS impact_moyen
FROM 
    vols v, 
    TABLE(v.IndicesQualite) i
GROUP BY 
    i.label; 
