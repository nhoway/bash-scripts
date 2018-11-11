#!/bin/bash
CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"

. $CDIR/scripts/store-config.sh
if [ -z "$1" ]; then 
  DOMAIN="$(askconfig $CCNF DOMAIN)";
else
  DOMAIN=$1;
fi

if [ -z "$2" ]; then 
  EMAIL="$(askconfig $CCNF EMAIL)";
else
  EMAIL=$2;
fi

sudo apt-get install letsencrypt -y

sudo service nginx stop
sudo letsencrypt certonly --standalone -d "$DOMAIN" --email "$EMAIL" --agree-tos
sudo service nginx start

# ADD CRONTAB FOR RENEWAL
########################################

(sudo crontab -l 2>/dev/null; echo "20 3 1 * * service nginx stop && letsencrypt renew && service nginx start") | sudo crontab -