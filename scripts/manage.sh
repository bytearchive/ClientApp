#!/usr/bin/env bash

cd Externals/django-rest-framework-api-server &&
source venv/bin/activate &&
source .env &&
python manage.py $1
