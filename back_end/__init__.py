from flask import Flask, g, jsonify, request

from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker

from blueprints.volunteer_venice import vv_blueprint

SECRET_KEY = 'development key'


def register_server(url_prefix='', settings={}):
    app = Flask(__name__, **settings)
    app.secret_key = SECRET_KEY

    app.register_blueprint(vv_blueprint,
                           url_prefix='{}'.format(url_prefix))

    @app.before_request
    def before_request():
        local_engine = create_engine("sqlite:///test_db")
        g.db = scoped_session(sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=local_engine))

    @app.teardown_request
    def teardown_request(error=None):
        if hasattr(g, 'db'):
            g.db.close()
            g.db.remove()

    @app.after_request
    def after_request(response):
        origin = request.headers.get('Origin', '*')
        response.headers.add('Access-Control-Allow-Origin', origin)
        response.headers.add('Access-Control-Allow-Credentials', 'true')

        return response

    @app.route('/location')
    def organization(org_id=None):
        result = {
            'location': [
                {
                    'name': 'Venice Beach',
                    'LatLng': {'lat':33.990, "lng":118.459},
                    'id': 1
                }
            ]
        }
        return jsonify(result)

    @app.errorhandler(404)
    def page_not_found(e):
        return "Error: Invalid API Path", 404

    return app
