/**
 * Supprime un vol de la base de données via l'API.
 * @async
 * @function suppVol
 * @param {Object} vol - L'objet vol complet à supprimer.
 * @param {string} vol.Compagnie - Nom de la compagnie (ex: "AF").
 * @param {string} vol.numVol - Numéro du vol (ex: "123").
 * @param {string} vol.dateheureDep - Date de départ au format ISO.
 * @returns Rafraîchit l'affichage après la suppression.
 */
async function suppVol(vol) {
  let url = `http://127.0.0.1:5000/api/vols/${vol.Compagnie}/${vol.numVol}/${Date.parse(vol.dateheureDep)}/`
  let response = await fetch(url, { method: 'DELETE', headers: { 'Content-Type': 'application/json' } });
  if (response.ok) {
    alert("Vol Supprimé !");
    await afficherVols(); 
  } else {
    alert("Erreur lors de la suppression");
  }
}