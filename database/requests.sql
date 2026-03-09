PROMPT ==========================================
PROMPT 1. VOLS DIRECTS DEPUIS PARIS (FR)
PROMPT ==========================================
select distinct A2.ville from Vol V 
Join Aeroport A1 on V.depart=A1.CodeIATA
Join Aeroport A2 on V.arriver=A2.CodeIATA
Where A1.ville='Paris' and A1.CodePays='FR';

PROMPT
PROMPT ==========================================
PROMPT 2. DESTINATIONS AVEC UNE ESCALE DEPUIS PARIS
PROMPT ==========================================
select distinct A3.ville
From Vol V1
Join Aeroport A1 on V1.depart=A1.CodeIATA
Join Aeroport A2 on V1.arriver=A2.CodeIATA
Join Vol V2 on V2.depart=A2.CodeIATA
Join Aeroport A3 on V2.arriver=A3.CodeIATA
where A1.ville='Paris' and A1.CodePays='FR'
and V2.dateHeureDep>V1.dateHeureArr;

PROMPT
PROMPT ==========================================
PROMPT 3. DESTINATIONS AVEC DEUX ESCALES DEPUIS PARIS
PROMPT ==========================================
select distinct A4.ville
From Vol V1
Join Aeroport A1 on V1.depart=A1.CodeIATA
Join Aeroport A2 on V1.arriver=A2.CodeIATA
Join Vol V2 on V2.depart=A2.CodeIATA
Join Aeroport A3 on V2.arriver=A3.CodeIATA
Join Vol V3 on V3.depart = A3.CodeIATA
Join Aeroport A4 on V3.arriver=A4.CodeIATA
where A1.ville='Paris' and A1.CodePays='FR'
and V2.dateHeureDep>V1.dateHeureArr
and V3.dateHeureDep>V2.dateHeureArr;

PROMPT
PROMPT ==========================================
PROMPT 4. TOUTES LES DESTINATIONS POSSIBLES (RECURSIF) DEPUIS PARIS
PROMPT ==========================================
WITH Trajets(ville_actuelle, heure_arriver) AS (
    SELECT A2.ville, V.dateHeureArr
    FROM Vol V
    JOIN Aeroport A1 ON V.depart = A1.CodeIATA
    JOIN Aeroport A2 ON V.arriver = A2.CodeIATA
    WHERE A1.ville = 'Paris' and A1.CodePays='FR'
    UNION ALL
    SELECT A_dest.ville, V_suiv.dateHeureArr
    FROM Trajets T
    JOIN Aeroport A_esc ON T.ville_actuelle = A_esc.ville
    JOIN Vol V_suiv ON A_esc.CodeIATA = V_suiv.depart
    JOIN Aeroport A_dest ON V_suiv.arriver = A_dest.CodeIATA
    WHERE V_suiv.dateHeureDep > T.heure_arriver
)
SELECT DISTINCT ville_actuelle FROM Trajets;