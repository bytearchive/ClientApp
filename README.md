Client App
==========

A simple native iOS client configured to log in to a mobile web service api.
The server code is a simple django site that uses django-rest-framework.
It is pinned at a particular revision to this ClientApp repo as a git submodule.

This client-server pair is meant to be used as a starting point for a variety
of applications that need to do client-server communication with authentication.

Quick start
==========

To install and run the development server:

    git submodule update --init --recursive
    ./scripts/setup_server.sh
    ./scripts/manage.sh createsuperuser
    ./scripts/server.sh

