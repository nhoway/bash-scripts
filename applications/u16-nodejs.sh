#!/bin/bash

# INSTALL NODE JS
########################################

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install nodejs -y

# CREATE SIMLINK FOR NODE
########################################

sudo ln -s /usr/bin/nodejs /usr/local/bin/node
