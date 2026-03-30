# SAE_Flutter


## Mise en place de l'environnements de developement 
Merci de suivre l'ordre des instructions pour être sûr que l'environement fonctionnne

#### Mise en place de l'api

dans un environement virtuel (venv) executer les commandes suivantes:  

```bash
pip install -r requierement.txt
cd app/
```

ensuite on va lancer dans le terminal cette commande :

```bash
flask run 
```

#### Mise en place du site web
Depuis la racine du projet, dans un terminal différent de celui où vous avez l'API, exécutez ces commandes : 

```bash
cd javascript/
python -m http.server 5500
```
Dans un navigateur allez à l’adresse suivante pour voir la SPA : 

http://localhost:5500

Vous pouvez maintenant interagir avec la SPA.

#### Mise en place de l'application mobile
Depuis la racine du projet, dans un terminal différent de celui où vous avez l'API, exécutez ces commandes : 

```bash
cd mobile/
flutter pub get
flutter run -d web-server --web-port 8080
```
Dans un navigateur allez à l’adresse suivante pour voir l'application mobile : 

http://localhost:8080

Vous pouvez aussi remplacer la dernière commande par celle-ci :

```bash
flutter -d chrome
```
Dans ce cas, une fenêtre s'ouvrira directement avec l'application.

Vous pouvez maintenant voir les différents vols grâce à l'application mobile.

## API
Nous avons utilisé une API restX pour gérer le le backend de notre application
### Modèle relationnel
[MCD](MCD.png)
### Annexe des Routes
#### Gestion des Aéroports

**Get**
tous les aéroports
```bash
curl -X GET http://localhost:5000/api/aeroport/
```
un seul aéroport
```bash
curl -X GET http://localhost:5000/api/aeroport/CDG/
```
 
**Post**
création d'un aéroport
```bash
curl -X POST http://localhost:5000/api/aeroport/ \
  -H "Content-Type: application/json" \
  -d '{"CodeIATA": "CDG", "nomAeroport": "Charles de Gaulle", "CodePays": "FR", "ville": "Paris"}'
```
 
**Put**
modification d'un aéroport
```bash
curl -X PUT http://localhost:5000/api/aeroport/CDG/ \
  -H "Content-Type: application/json" \
  -d '{"CodeIATA": "CDG", "nomAeroport": "Charles de Gaulle", "CodePays": "FR", "ville": "Paris"}'
```
 
**Delete**
suppression d'un aéroport
```bash
curl -X DELETE http://localhost:5000/api/aeroport/CDG/
```
 
---
 
#### Gestion des Vols
 
**Get**
tous les vols
```bash
curl -X GET http://localhost:5000/api/vols/
```
un seul vol
```bash
curl -X GET http://localhost:5000/api/vols/AF/42/1710835200/
```
 
**Post**
création d'un vol
```bash
curl -X POST http://localhost:5000/api/vols/ \
  -H "Content-Type: application/json" \
  -d '{"Compagnie": "AF", "numVol": 42, "dateheureDep": 1710835200, "dateheureArr": 1710849600, "terminalDep": "2E", "terminalArr": "1", "depart": "CDG", "arriver": "JFK"}'
```
 
**Put**
modification d'un vol
```bash
curl -X PUT http://localhost:5000/api/vols/AF/42/1710835200/ \
  -H "Content-Type: application/json" \
  -d '{"dateheureArr": 1710849600, "terminalDep": "2E", "terminalArr": "1", "depart": "CDG", "arriver": "JFK"}'
```
 
**Delete**
suppression d'un vol
```bash
curl -X DELETE http://localhost:5000/api/vols/AF/42/1710835200/
```

### Test de l'API
Pour tester l'API il faut se placer dans le dossier `app/`
puis executer la commande suivante:
```bash
python -m pytest --cov=. --cov-report=term-missing tests/
```

Ainsi vous verrez un coverage de 77%.
Par ailleur j'ai utilisé de l'IA dans la correction de bugs pour la création des tests. Il y avais un problème avec sqlite. Pour votre information l'erreur était due à sqlite et la manière dont il gérait ses métadonnées qui donnait des résultat faux.
Cela empêchais la création de l'environement de test. Ce qui par conséquent empêchais l'ensemble des tests de fonctionner.  

## SPA
### Routage


## BD

