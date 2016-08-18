# Install virtualenv & djangoadmin
sudo apt-get install build-essential libpq-dev python-dev -y
sudo apt-get install python3-django -y
sudo pip install virtualenv

# Create virtual environnement to host Django
cd ~
sudo chown ubuntu:ubuntu /home/ubuntu -R
virtualenv -p /usr/bin/python3.5 venvdjango
source ~/venvdjango/bin/activate
pip install django gunicorn

# If MongoDB -> WONT WORK WITH PYTHON 3.X !
#pip install git+https://github.com/django-nonrel/django@nonrel-1.5
#pip install git+https://github.com/django-nonrel/djangotoolbox
#pip install git+https://github.com/django-nonrel/mongodb-engine

# Init Django project within virtualenv
django-admin startproject myproject
mv myproject/myproject/wsgi.py myproject/wsgi.py

# Quit virtualenv
deactivate

# Configure owning & groups (giving access to www-data)
sudo chmod 664 myproject/ -R

# Set Ajenti V new Website
# Content Tab > Python WSGI
# Python WSGI > Application Module 	= wsgi
# Python WSGI > Virtualenv path 	= <path to venv>/venvdjango
# Python WSGI > Username			= ubuntu