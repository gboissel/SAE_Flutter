from flask_restx import fields
from .extensions import api

aeroport_model = api.model("Aeroport",{
    "CodeIATA":fields.String,
    "nomAeroport":fields.String,
    "CodePays":fields.String,
    "ville":fields.String
})

vols_models = api.model("Vols",{
    "Compagnie":fields.String,
    "numVol":fields.Integer,
    "dateheureDep": fields.DateTime(dt_format='iso8601'), 
    "dateheureArr": fields.DateTime(dt_format='iso8601'),
    "terminalDep":fields.Integer,
    "terminalArr":fields.Integer,
    "depart":fields.String,
    "arriver":fields.String
})