#!/usr/bin/env bash

cd Externals/django-rest-framework-api-server &&

if [ ! -d venv ]; then
virtualenv venv --distribute
fi

source venv/bin/activate &&
pip install -r requirements.txt &&
pip install -r requirements-dev.txt &&

if [ ! -f .env ]; then
    touch .env
    echo "export LOCAL_DEV=1" >> .env
    echo "export ALLOWED_HOSTS='localhost,127.0.0.1'" >> .env
    echo "export SECRET_KEY='secret'" >> .env
fi

source .env &&
python manage.py migrate &&
python manage.py collectstatic &&

echo "Server and its dependencies installed correctly." &&
echo "Run .scripts/server.sh to run the development server."

