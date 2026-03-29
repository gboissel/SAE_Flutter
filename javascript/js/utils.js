async function aeroport(IATA) {
  try {
  let url = `http://127.0.0.1:5000/api/aeroport/${IATA}`;
  let response = await fetch(url);
  if (response.ok) {
    let data = await response.json();
    return data;
  }
return { ville: "Inconnu", CodePays: "??" };
  } catch (e) {
    return { ville: "Erreur", CodePays: "!" };
  }
}
