DROP TABLE vols;

DROP TYPE equipage_tab;
DROP TYPE indices_tab;

DROP TYPE membre_t;
DROP TYPE indice_t;


CREATE OR REPLACE TYPE membre_t AS OBJECT (
    nom VARCHAR2(50),
    fonction VARCHAR2(50)
);
/ 
--valider le bloc

CREATE OR REPLACE TYPE indice_t AS OBJECT (
    label VARCHAR2(20),
    poids1 NUMBER,
    poids2 NUMBER
);
/

CREATE OR REPLACE TYPE equipage_tab AS TABLE OF membre_t;
/


CREATE OR REPLACE TYPE indices_tab AS TABLE OF indice_t;
/


CREATE TABLE vols (
    NumVol VARCHAR2(10) PRIMARY KEY,
    AeroDep CHAR(3),
    DateHeureDep DATE,
    AeroArr CHAR(3),
    DateHeureArr DATE,
    Equipage equipage_tab,
    IndicesQualite indices_tab
) 
NESTED TABLE Equipage STORE AS table_equipage_stock,
NESTED TABLE IndicesQualite STORE AS table_indices_stock;



