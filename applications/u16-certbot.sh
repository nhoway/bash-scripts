#!/bin/bash
CDIR="$(dirname `realpath -s $0`)/../.."
CCNF="$CDIR/.sya"

. $CDIR/bash-scripts/scripts/store-config.sh
if [[ $1 ]]; then
  DOMAIN=$1;
else
  DOMAIN="$(askconfig $CCNF DOMAIN)";
fi

if [[ $2 ]]; then
  EMAIL=$2;
else
  EMAIL="$(askconfig $CCNF EMAIL)";
fi

sudo apt-get install letsencrypt -y

sudo service nginx stop
sudo letsencrypt certonly --standalone -d "$DOMAIN" --email "$EMAIL" --agree-tos
sudo service nginx start

# ADD CRONTAB FOR RENEWAL
########################################

(sudo crontab -l 2>/dev/null; echo "20 3 1 * * service nginx stop && letsencrypt renew && service nginx start") | sudo crontab -