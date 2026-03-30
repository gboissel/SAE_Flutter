from flask_restx import fields
from extensions import api

aeroport_model = api.model("Aeroport",{
    "CodeIATA":fields.String,
    "nomAeroport":fields.String,
    "CodePays":fields.String,
    "ville":fields.String
})


aeroport_input_model = api.model("AeroportInput",{
    "CodeIATA":fields.String,
    "nomAeroport":fields.String,
    "CodePays":fields.String,
    "ville":fields.String
})


vols_model = api.model("Vols",{
    "Compagnie":fields.String,
    "numVol":fields.Integer,
    "dateheureDep": fields.DateTime(dt_format='iso8601'), 
    "dateheureArr": fields.DateTime(dt_format='iso8601'),
    "terminalDep":fields.Integer,
    "terminalArr":fields.Integer,
    "depart":fields.String,
    "arriver":fields.String
})


vols_input_model = api.model("VolInput",{
    "Compagnie":fields.String,
    "numVol":fields.Integer,
    "dateheureDep": fields.DateTime(dt_format='iso8601'), 
    "dateheureArr": fields.DateTime(dt_format='iso8601'),
    "terminalDep":fields.Integer,
    "terminalArr":fields.Integer,
    "depart":fields.String,
    "arriver":fields.String
})