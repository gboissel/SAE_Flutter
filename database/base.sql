CREATE TABLE Aeroport (
    CodeIATA VARCHAR2(5) PRIMARY KEY,
    CodePays VARCHAR2(2),
    Ville VARCHAR2(50),
    nomAeroport VARCHAR2(50) UNIQUE  
);
CREATE TABLE Vol (
    nomCompagnie VARCHAR2(50),
    numVol NUMBER,
    dateHeureDep TIMESTAMP,
    dateHeureArr TIMESTAMP,
    terminalDep NUMBER,
    terminalArr NUMBER,
    depart VARCHAR2(5),
    arriver VARCHAR2(5),
    PRIMARY KEY (nomCompagnie,numVol,dateHeureDep)
);
ALTER TABLE Vol ADD CONSTRAINT fk_dep FOREIGN KEY (depart) REFERENCES Aeroport(CodeIATA);
ALTER TABLE Vol ADD CONSTRAINT fk_arr FOREIGN KEY (arriver) REFERENCES Aeroport(CodeIATA);