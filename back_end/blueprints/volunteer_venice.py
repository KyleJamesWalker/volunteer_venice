from flask import Blueprint, jsonify, current_app, g

from ..dbdefs.volunteer_venice import Organization, Category

import traceback

vv_blueprint = Blueprint('volunteer_venice', __name__)


@vv_blueprint.route('/organization/<org_id>')
@vv_blueprint.route('/organization/')
def organization(org_id=None):
    '''
    First Test Route
    '''
    result = dict()

    try:
        feilds = [Organization.id,
                  Organization.name,
                  Organization.website,
                  Organization.address,
                  Organization.description,
                  Organization.category,
                  Organization.phone_number,
                  Organization.email,
                  Organization.picture_location,
                  Organization.video_location,
                  ]

        query_data = g.db.query(*feilds).order_by(Organization.id)

        if org_id is not None:
            query_data = query_data.filter(Organization.id == org_id)
            

        result['organization'] = []
        for x in query_data:
            db_result = {'id': x.id,
                         'name': x.name,
                         'website': x.website,
                         'address': x.address,
                         'description': x.description,
                         'category': x.category,
                         'phone_number': x.phone_number,
                         'email': x.email,
                         'picture_location': x.picture_location,
                         'video_location': x.video_location,
                         }
            if org_id is None:
                result['organization'].append(db_result)
            else:
                result = db_result

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
