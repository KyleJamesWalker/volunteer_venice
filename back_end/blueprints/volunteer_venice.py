from flask import Blueprint, jsonify, current_app

import traceback

vv_blueprint = Blueprint('volunteer_venice', __name__)


@vv_blueprint.route('/')
def first(user_id=None):
    '''First Test Route
    '''
    result = dict()

    try:
        result['data'] = "Hello World"

    # Error occurred, add to message.
    except Exception as e:
        result['error'] = dict()
        result['error']['desc'] = str(e)
        # Only show traceback and type if the app is in debug
        if current_app._get_current_object().debug:
            result['error']['type'] = type(e).__name__
            result['error']['trace'] = traceback.format_exc()

    finally:
        return jsonify(result)
