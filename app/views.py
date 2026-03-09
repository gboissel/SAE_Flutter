from flask_restx import Resource, Namespace
# creation du namespace, racine de tous les endpoints
ns = Namespace("api")

@ns.route("/hello")
class Hello(Resource):
    def get(self):
        return {"hello": "restx"}