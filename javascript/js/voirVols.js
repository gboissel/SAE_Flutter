async function afficherVols() {
  const divVols = document.getElementById("vols");
  const titre = document.getElementById("titre");
  let url = 'http://127.0.0.1:5000/api/vols/';
  let response = await fetch(url);
  if (response.ok) {
    let data = await response.json();
    console.log("Données reçues de l'API :", data);
    divVols.innerHTML = "";
    titre.textContent = "Tous les vols";
    let ul = document.createElement("ul");
    ul.className = "listeVols";
    
    for (let vol of data) {
      let li = document.createElement("li");
      li.className = 'Vol';
      let ulVol = document.createElement("ul");
      
      let liNumCompagnie = document.createElement("li");
      liNumCompagnie.className = "texteVol"; 
      liNumCompagnie.textContent = "N°" + vol["numVol"] + " - " + vol["Compagnie"];

      let aeroDepart = await aeroport(vol["depart"]);
      let aeroArrivee = await aeroport(vol["arriver"]);

      let liVilles = document.createElement("li");
      liVilles.className = "texteVol";
      liVilles.textContent = ` ${aeroDepart.ville} (${aeroDepart.CodePays}) - ${aeroArrivee.ville} (${aeroArrivee.CodePays}) `;

      let liDepart = document.createElement("li");
      liDepart.className = "texteVol";
      liDepart.textContent = "Départ :" + new Date(vol.dateheureDep).toLocaleString('fr-FR', {
                      day: '2-digit',
                      month: '2-digit',
                      year: 'numeric',
                      hour: '2-digit',
                      minute: '2-digit'
                    }).replace(',', ' à').replace(':', 'h')
                    + ", " + vol["depart"] + ", " + vol["terminalDep"];

      let liArrivee = document.createElement("li");
      liArrivee.className = "texteVol";
      liArrivee.textContent = "Arrivée :" + new Date(vol.dateheureArr).toLocaleString('fr-FR', {
                      day: '2-digit',
                      month: '2-digit',
                      year: 'numeric',
                      hour: '2-digit',
                      minute: '2-digit'
                    }).replace(',', ' à').replace(':', 'h') + ", " + vol["arriver"] + ", " + vol["terminalArr"];

      let boutonSupp = document.createElement("input");
      boutonSupp.id = "Supp"; 
      boutonSupp.className = "BoutonVol";
      boutonSupp.type = "button";
      boutonSupp.value = "Supp";
      boutonSupp.addEventListener("click", () => suppVol(vol));

      let boutonModif = document.createElement("input");
      boutonModif.id = "Modif";
      boutonModif.className = "BoutonVol";
      boutonModif.type = "button";
      boutonModif.value = "Modif";
      boutonModif.addEventListener("click", () => modifVol(vol));

      let divBoutons = document.createElement("div");
      divBoutons.style.display = "flex";
      divBoutons.append(boutonSupp, boutonModif);

      ulVol.append(liNumCompagnie, liVilles, liDepart, liArrivee);
      li.append(ulVol, divBoutons);
      ul.appendChild(li);
    }
    divVols.append(ul);
    
  }
}