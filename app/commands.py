import click
from datetime import datetime
from extensions import db
from models import Aeroport, Vols

@click.command('syncdb')
def syncdb():
    """Réinitialise puis peuple la base de données avec des données de test."""
    
    # S'assure que les tables existent (utile pour le premier lancement)
    db.create_all()
    
    # Nettoyage des anciennes données
    db.session.query(Vols).delete()
    db.session.query(Aeroport).delete()
    
    # 1. Création des Aéroports
    aeroports = [
        Aeroport(CodeIATA='ORY', nomAeroport='Orly', CodePays='FR', ville='Paris'),
        Aeroport(CodeIATA='CDG', nomAeroport='Charles de Gaulle', CodePays='FR', ville='Paris'),
        Aeroport(CodeIATA='NCE', nomAeroport='Cote d Azur', CodePays='FR', ville='Nice'),
        Aeroport(CodeIATA='LYS', nomAeroport='Lyon Saint Exupery', CodePays='FR', ville='Lyon'),
        Aeroport(CodeIATA='MRS', nomAeroport='Marseille Provence', CodePays='FR', ville='Marseille'),
        Aeroport(CodeIATA='JFK', nomAeroport='John F. Kennedy', CodePays='US', ville='New York'),
        Aeroport(CodeIATA='LAX', nomAeroport='Los Angeles', CodePays='US', ville='Los Angeles'),
        Aeroport(CodeIATA='SFO', nomAeroport='San Francisco', CodePays='US', ville='San Francisco'),
        Aeroport(CodeIATA='MAD', nomAeroport='Adolfo Suarez Madrid', CodePays='ES', ville='Madrid'),
        Aeroport(CodeIATA='BCN', nomAeroport='Barcelona El Prat', CodePays='ES', ville='Barcelone'),
        Aeroport(CodeIATA='LHR', nomAeroport='London Heathrow', CodePays='GB', ville='Londres'),
        Aeroport(CodeIATA='AMS', nomAeroport='Schiphol', CodePays='NL', ville='Amsterdam'),
        Aeroport(CodeIATA='FRA', nomAeroport='Frankfurt Main', CodePays='DE', ville='Francfort'),
        Aeroport(CodeIATA='DXB', nomAeroport='Dubai International', CodePays='AE', ville='Dubai'),
        Aeroport(CodeIATA='HND', nomAeroport='Tokyo Haneda', CodePays='JP', ville='Tokyo'),
    ]

    # 2. Données brutes des Vols
    vols_data = [
        ('Air France', 1001, '2026-04-01T08:00:00', '2026-04-01T09:25:00', 1, 2, 'ORY', 'LHR'),
        ('Air France', 1002, '2026-04-01T11:00:00', '2026-04-01T13:20:00', 1, 2, 'LHR', 'AMS'),
        ('Air France', 1003, '2026-04-01T15:00:00', '2026-04-01T17:10:00', 2, 3, 'AMS', 'FRA'),
        ('Air France', 1004, '2026-04-02T09:00:00', '2026-04-02T17:20:00', 2, 4, 'FRA', 'JFK'),
        ('Air France', 1005, '2026-04-03T10:00:00', '2026-04-03T13:05:00', 2, 3, 'JFK', 'LAX'),
        ('Air France', 1006, '2026-04-04T14:00:00', '2026-04-04T16:35:00', 3, 2, 'LAX', 'SFO'),
        ('Air France', 1007, '2026-04-05T09:30:00', '2026-04-05T20:00:00', 2, 5, 'SFO', 'HND'),
        ('Air France', 1008, '2026-04-06T12:00:00', '2026-04-06T20:30:00', 4, 3, 'HND', 'DXB'),
        ('Air France', 1009, '2026-04-07T09:00:00', '2026-04-07T14:30:00', 3, 1, 'DXB', 'CDG'),
        ('Air France', 1010, '2026-04-08T07:15:00', '2026-04-08T09:00:00', 2, 1, 'CDG', 'MAD'),
        ('Air France', 1011, '2026-04-08T11:30:00', '2026-04-08T12:45:00', 1, 2, 'MAD', 'BCN'),
        ('Air France', 1012, '2026-04-09T08:10:00', '2026-04-09T09:35:00', 2, 2, 'BCN', 'LYS'),
        ('Air France', 1013, '2026-04-09T12:00:00', '2026-04-09T13:00:00', 1, 1, 'LYS', 'MRS'),
        ('Air France', 1014, '2026-04-10T08:40:00', '2026-04-10T10:05:00', 3, 2, 'MRS', 'NCE'),
        ('Air France', 1015, '2026-04-10T13:10:00', '2026-04-10T14:35:00', 2, 1, 'NCE', 'ORY'),
        ('EasyJet', 2201, '2026-04-11T06:45:00', '2026-04-11T08:05:00', 1, 2, 'ORY', 'BCN'),
        ('EasyJet', 2202, '2026-04-11T10:00:00', '2026-04-11T11:25:00', 2, 3, 'BCN', 'LHR'),
        ('Lufthansa', 3301, '2026-04-12T09:20:00', '2026-04-12T10:50:00', 2, 1, 'CDG', 'FRA'),
        ('Lufthansa', 3302, '2026-04-12T13:30:00', '2026-04-12T18:00:00', 1, 2, 'FRA', 'DXB'),
        ('Iberia', 4401, '2026-04-13T07:55:00', '2026-04-13T09:10:00', 1, 1, 'MAD', 'ORY'),
        ('Iberia', 4402, '2026-04-13T11:00:00', '2026-04-13T12:25:00', 1, 2, 'ORY', 'MAD'),
        ('Delta', 5501, '2026-04-14T10:30:00', '2026-04-14T18:20:00', 3, 4, 'CDG', 'JFK'),
        ('Delta', 5502, '2026-04-15T09:50:00', '2026-04-15T17:35:00', 4, 2, 'JFK', 'CDG'),
        ('KLM', 6601, '2026-04-16T08:35:00', '2026-04-16T10:00:00', 2, 2, 'ORY', 'AMS'),
        ('KLM', 6602, '2026-04-16T12:10:00', '2026-04-16T13:40:00', 2, 1, 'AMS', 'ORY'),
    ]

    # Transformation des données brutes en objets Vols
    vols = [
        Vols(
            Compagnie=c, numVol=n,
            dateheureDep=datetime.fromisoformat(d),
            dateheureArr=datetime.fromisoformat(a),
            terminalDep=td, terminalArr=ta,
            depart=dep, arriver=arr
        ) for c, n, d, a, td, ta, dep, arr in vols_data
    ]

    # Enregistrement en base
    db.session.add_all(aeroports)
    db.session.add_all(vols)
    db.session.commit()
    
    click.echo("Base de données synchronisée avec succès !")