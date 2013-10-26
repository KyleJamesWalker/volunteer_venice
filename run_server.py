#!/usr/bin/env python
'''
    Run server mimicking setup on production server.
'''
from back_end import register_server


if __name__ == '__main__':
    # Mimic production setup for development.
    settings = {'static_url_path': '', 'static_folder': '../zoo'}
    app = register_server('/api', settings)

    app.debug = True
    # Launch server and listen globally.
    app.run(host='0.0.0.0')
