#!/bin/bash

# Pydio Community repositories
echo "deb https://download.pydio.com/pub/linux/debian/ xenial main" > /etc/apt/sources.list.d/pydio.list
wget -qO - https://download.pydio.com/pub/linux/debian/key/pubkey | sudo apt-key add -
sudo apt-get update -y

sudo apt-get install pydio -y
sudo apt-get install pydio-all -y
sudo apt-get install php-xml -y