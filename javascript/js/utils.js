/**
 * @typedef {Object} Aeroport
 * @property {string} CodeIATA - Code de la compagnie ou de l'aéroport (ex: "AF")
 * @property {string} CodePays - Code du pays (ex: "FR")
 * @property {string} nomAeroport - Nom de l'aéroport (ex: "Orly")
 * @property {string} ville - Nom de la ville (ex: "Paris")
 */

/**
 * Récupère les informations détaillées d'un aéroport à l'aide de l'API.
 * @param {string} IATA 
 * @returns {Promise<Aeroport>}
 */
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
