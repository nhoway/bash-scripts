# Install virtualenv & djangoadmin
sudo apt-get install python3-django -y
sudo pip install virtualenv

# Create virtual environnement to host Django
cd ~
sudo chown ubuntu:ubuntu /home/ubuntu -R
virtualenv -p /usr/bin/python3.5 venvdjango

# Activate virtualenv
source ~/venvdjango/bin/activate

# Install Django
pip install django gunicorn

# Init Django project
django-admin startproject myproject
mv myproject/myproject/wsgi.py myproject/wsgi.py

# Quit virtualenv
deactivate

# Configure owning & groups
sudo adduser ubuntu www-data
sudo chown www-data:ubuntu myproject/ -R

# Set Ajenti V new Website
# Content Tab > Python WSGI
# Python WSGI > Application Module 	= wsgi
# Python WSGI > Virtualenv path 	= <path to venv>/venvdjango