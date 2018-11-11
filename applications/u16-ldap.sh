#!/bin/bash
# Source : https://documentation.fusiondirectory.org/en/documentation/admin_installation

CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"

. $CDIR/bash-scripts/scripts/store-config.sh
if [ -z "$1" ]; then 
  . $CDIR/bash-scripts/scripts/generate-password.sh
  LDAP_PASSWD="$(generatePassword 25)";
  setconfig $CCNF "LDAP_PASSWD" "$LDAP_PASSWD";
else
  LDAP_PASSWD=$1;
fi

# INSTALL LDAP SERVER
########################################

export DEBIAN_FRONTEND=noninteractive

echo -e "
slapd    slapd/internal/generated_adminpw    password   $LDAP_PASSWD
slapd    slapd/internal/adminpw    password $LDAP_PASSWD
slapd    slapd/password1    password    $LDAP_PASSWD
slapd    slapd/password2    password    $LDAP_PASSWD
" | sudo debconf-set-selections

sudo apt-get install -y slapd ldap-utils

# => https://doc.ubuntu-fr.org/slapd
