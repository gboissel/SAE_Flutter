async function modifVol(vol) {
    const divVols = document.getElementById("vols");
    const titre = document.getElementById("titre");
    divVols.innerHTML = "";
    let aeroDepart = await aeroport(vol["depart"]);
    let aeroArrivee = await aeroport(vol["arriver"]);

    titre.textContent = "Modifier un Vol";

    let colonneGauche = document.createElement("li");

    let labelCompagnie = document.createElement("label");
    labelCompagnie.textContent = "Compagnie : ";
    let compagnie = document.createElement("input");
    compagnie.className = 'ajout_modif';
    compagnie.id = "Compagnie";
    compagnie.type = "text";
    compagnie.value = vol.Compagnie;

    let labelAD = document.createElement("label");
    labelAD.textContent = "IATA de départ : ";
    let aeroportD = document.createElement("input");
    aeroportD.className = 'ajout_modif';
    aeroportD.id = "AD";
    aeroportD.type = "text";
    aeroportD.value = aeroDepart.CodeIATA;

    let labelVD = document.createElement("label");
    labelVD.textContent = "Ville départ : ";
    let VilleD = document.createElement("input");
    VilleD.className = 'ajout_modif';
    VilleD.id = "VD";
    VilleD.type = "text";
    VilleD.value = aeroDepart.ville;


    let dateBruteD = vol.dateheureDep;
    let partiesD = dateBruteD.split('T');
    let laDateD = partiesD[0];
    let lHeureD = partiesD[1].substring(0, 5);


    let dateBruteA = vol.dateheureArr;
    let partiesA = dateBruteA.split('T');
    let laDateA = partiesA[0];
    let lHeureA = partiesA[1].substring(0, 5);


    let labelDD = document.createElement("label");
    labelDD.textContent = "Date départ : ";
    let DateD = document.createElement("input");
    DateD.className = 'ajout_modif';
    DateD.id = "DD";
    DateD.type = "date";
    DateD.value = laDateD;


    let labelAA = document.createElement("label");
    labelAA.textContent = "IATA d'arrivée: ";
    let aeroportA = document.createElement("input");
    aeroportA.className = 'ajout_modif';
    aeroportA.id = "AA";
    aeroportA.type = "text";
    aeroportA.value = aeroArrivee.CodeIATA;

    let labelVA = document.createElement("label");
    labelVA.textContent = "Ville arrivée : ";
    let VilleA = document.createElement("input");
    VilleA.className = 'ajout_modif';
    VilleA.id = "VA";
    VilleA.type = "text";
    VilleA.value = aeroArrivee.ville;

    let labelDA = document.createElement("label");
    labelDA.textContent = "Date arrivée : ";
    let DateA = document.createElement("input");
    DateA.className = 'ajout_modif';
    DateA.id = "DA";
    DateA.type = "date";
    DateA.value = laDateA;

    let colonneDroite = document.createElement("li");

    let Labelnum = document.createElement("label");
    Labelnum.textContent = "N° du vol : ";
    let num = document.createElement("input");
    num.className = 'ajout_modif';
    num.id = "Num";
    num.type = "text";
    num.value = vol.numVol;

    let labelPaysD = document.createElement("label");
    labelPaysD.textContent = "Code pays départ : ";
    let PaysD = document.createElement("input");
    PaysD.className = 'ajout_modif';
    PaysD.id = "PD";
    PaysD.type = "text";
    PaysD.value = aeroDepart.CodePays;

    let LabelTerminalD = document.createElement("label");
    LabelTerminalD.textContent = "Terminal départ : ";
    let TerminalD = document.createElement("input");
    TerminalD.className = 'ajout_modif';
    TerminalD.id = "TD";
    TerminalD.type = "text";
    TerminalD.value = vol.terminalDep;

    let LabelHeureD = document.createElement("label");
    LabelHeureD.textContent = "Heure départ : ";
    let HeureD = document.createElement("input");
    HeureD.className = 'ajout_modif';
    HeureD.id = "HD";
    HeureD.type = "time";
    HeureD.value = lHeureD;


    let labelPaysA = document.createElement("label");
    labelPaysA.textContent = "Code pays arrivée : ";
    let PaysA = document.createElement("input");
    PaysA.className = 'ajout_modif';
    PaysA.id = "PA";
    PaysA.type = "text";
    PaysA.value = aeroArrivee.CodePays;

    let LabelTerminalA = document.createElement("label");
    LabelTerminalA.textContent = "Terminal arrivée : ";
    let TerminalA = document.createElement("input");
    TerminalA.className = 'ajout_modif';
    TerminalA.id = "TA";
    TerminalA.type = "text";
    TerminalA.value = vol.terminalArr;

    let LabelHeureA = document.createElement("label");
    LabelHeureA.textContent = "Heure arrivée : ";
    let HeureA = document.createElement("input");
    HeureA.className = 'ajout_modif';
    HeureA.id = "HA";
    HeureA.type = "time";
    HeureA.value = lHeureA;


    let ligneBouton = document.createElement("div");
    ligneBouton.id = "conteneur-bouton";

    let modifer = document.createElement("input");
    modifer.className = 'ajout_modif';
    modifer.id = "modifer";
    modifer.type = "button";
    modifer.value = "Modifer le vol";
    modifer.addEventListener("click", () => sauvegarderVol(vol.Compagnie, vol.numVol, vol.dateheureDep));

    colonneGauche.append(labelCompagnie, compagnie,
        labelAD, aeroportD, labelVD, VilleD, labelDD, DateD,
        labelAA, aeroportA, labelVA, VilleA, labelDA, DateA,
    )

    colonneDroite.append(Labelnum, num,
        labelPaysD, PaysD, LabelTerminalD, TerminalD, LabelHeureD, HeureD,
        labelPaysA, PaysA, LabelTerminalA, TerminalA, LabelHeureA, HeureA,
    )
    ligneBouton.append(modifer);
    divVols.append(colonneGauche, colonneDroite, ligneBouton);


}

async function sauvegarderVol(CompagnieOrigine, numVolOrigine, DDHOrigine) {
    let num = document.getElementById('Num').value;
    let compagnie = document.getElementById('Compagnie').value;
    let IATAD = document.getElementById('AD').value;
    let IATAA = document.getElementById('AA').value;
    let villeD = document.getElementById('VD').value;
    let villeA = document.getElementById('VA').value;
    let paysD = document.getElementById('PD').value;
    let paysA = document.getElementById('PA').value;
    let terminalD = document.getElementById('TD').value;
    let terminalA = document.getElementById('TA').value;
    let dateD = document.getElementById('DD').value;
    let dateA = document.getElementById('DA').value;
    let heureD = document.getElementById('HD').value;
    let heureA = document.getElementById('HA').value;

    let aeroportDVoulu = await aeroport(IATAD);
    let aeroportAVoulu = await aeroport(IATAA);
    if (num && compagnie && IATAD && IATAA && villeD && villeA && paysD && paysA && terminalD && terminalA && dateD && dateA && heureD && heureA) {
        if (aeroportDVoulu && aeroportAVoulu) {
            if ((aeroportDVoulu.CodeIATA === IATAD && aeroportDVoulu.CodePays === paysD && aeroportDVoulu.ville === villeD) &&
                (aeroportAVoulu.CodeIATA === IATAA && aeroportAVoulu.CodePays === paysA && aeroportAVoulu.ville === villeA)) {
                let response = await fetch(`http://127.0.0.1:5000/api/vols/${CompagnieOrigine}/${numVolOrigine}/${Date.parse(DDHOrigine)}/`, {
                    method: 'PUT', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        Compagnie: compagnie,
                        numVol: num,
                        dateheureDep: Date.parse(dateD + "T" + heureD),
                        dateheureArr: Date.parse(dateA + "T" + heureA),
                        terminalDep: terminalD,
                        terminalArr: terminalA,
                        depart: IATAD,
                        arriver: IATAA,
                    })
                });
                if (response.ok) {
                    alert("Vol mis à jour !");
                    console.log("Type de afficherVols :", typeof afficherVols);
                    if (typeof afficherVols === "function") {
                        await afficherVols();
                    } else {
                        console.error("La fonction afficherVols n'est pas accessible ici !");
                    }
                } else {
                    alert("Erreur lors de la modification");
                }
            }
            else {
                alert("Une des informations concernant le pays ou la ville d'un aéroport ne correspond pas à la réalité");
            }
        }
        else {
            alert("Un des code IATA n'existe pas.");
        }
    }
    else {
        alert("Tous les champs ne sont pas remplis.");
    }

}