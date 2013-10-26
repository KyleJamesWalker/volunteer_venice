from flask import Flask, g, jsonify

from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker

from blueprints.volunteer_venice import vv_blueprint

SECRET_KEY = 'development key'


def register_server(url_prefix='', settings={}):
    app = Flask(__name__, **settings)
    app.secret_key = SECRET_KEY

    app.register_blueprint(vv_blueprint,
                           url_prefix='{}/'.format(url_prefix))

    @app.before_request
    def before_request():
        pass
        #g.db = get_db()

    @app.teardown_request
    def teardown_request(error=None):
        pass
        #if hasattr(g, 'db'):
        #    g.db.close()
        #    g.db.remove()

    @app.after_request
    def after_request(response):
        return response

    @app.errorhandler(404)
    def page_not_found(e):
        return "Error: Invalid API Path", 404

    return app
