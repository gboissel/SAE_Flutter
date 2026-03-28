# SAE_Flutter

Sommaire:



## Mise en place de l'environnements de developement 
Merci de suivre l'ordre des instructions pour être sur que l'environement fonctionnne

#### Mise en place de l'api

dans un environement virtuel executer les commandes suivantes:  

```bash
cd app/
pip install -r requierement.txt
```

ensuite on va lancer dans le terminal

```bash
flask run 
```

#### Mise en place du site web
à faire

#### Mise en place du Web
à faire

## API
Nous avons utiliser une API restX pour gérée le le backend de notre application
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
pas encore fait à venir


## SPA
### Routage


## BD

