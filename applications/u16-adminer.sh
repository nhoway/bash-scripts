#!/bin/bash
CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"

# PROMPT CUSTOM VALUES
########################################

. $CDIR/scripts/store-config.sh
if [ -z "$1" ]; then 
  ADMINERPATH="$(askconfig $CCNF FAILOVERIP)";
else
  ADMINERPATH=$1;
fi

if [ -z "$2" ]; then 
  WEBUSER="www-data";
else
  WEBUSER=$2;
fi

sudo mkdir -p "$ADMINERPATH"
sudo cd "$ADMINERPATH"

sudo wget "https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3.php" -O "adminer.php"
sudo wget "https://raw.githubusercontent.com/arcs-/Adminer-Material-Theme/master/adminer.css" -O "adminer.css"