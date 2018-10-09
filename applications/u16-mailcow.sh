#!/bin/bash
# This script is not quiet : generate_config needs informations
# TODO: select required informations to build config from bash-scripts
# Install Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# umask should be 0022
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo ./generate_config.sh
sudo docker-compose pull
sudo docker-compose up -d