#!/bin/bash

# INSTALL NODE JS
########################################

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs -y

# If node command doesn't come :
#sudo apt install nodejs-legacy -y

# CREATE SIMLINK FOR NODE
########################################

sudo ln -s /usr/bin/nodejs /usr/local/bin/node
