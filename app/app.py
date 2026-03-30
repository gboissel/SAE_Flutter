from flask import Flask
from app.extensions import api, db
from app.views import ns
from flask_cors import CORS
from app.commands import syncdb
app = Flask(__name__)
cors = CORS(app, resources={r"/api/*": {"origins" : "*"} })

# initialisation de la BD
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"


api.init_app(app)
db.init_app(app)

# ajout du namespace defini dans views
api.add_namespace(ns)
app.cli.add_command(syncdb)