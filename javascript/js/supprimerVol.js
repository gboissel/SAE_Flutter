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