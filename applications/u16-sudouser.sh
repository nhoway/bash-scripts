#!/bin/bash
CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"
. $CDIR/scripts/store-config.sh

# Get username
if [ -z "$1" ]; then
  SUDO_USERNAME="$(askconfig $CCNF SUDO_USERNAME)";
else
  SUDO_USERNAME=$1;
fi

if [ -z "$(getent passwd $SUDO_USERNAME)" ]; then
  # Get password
  if [ -z "$2" ]; then 
    . $CDIR/scripts/generate-password.sh
    SUDO_USERPWD="$(generatePassword 25)";
    setconfig $CCNF "SUDO_USERPWD" "$SUDO_USERPWD";
    echo "User password was generated and stored in config file.";
  else
    SUDO_USERPWD=$2;
  fi

  # Add new user
  sudo useradd -p "$SUDO_USERPWD" -d "/home/$SUDO_USERNAME" -m "$SUDO_USERNAME"
else
  echo "User $SUDO_USERNAME already exists, skipping creation."
fi

# Grant sudo
sudo usermod -aG sudo "$SUDO_USERNAME"

# Backup SSH authorized keys file
mkdir -p "/home/$SUDO_USERNAME/.ssh"
if [ -f "/home/$SUDO_USERNAME/.ssh/authorized_keys" ]; then
  cp "/home/$SUDO_USERNAME/.ssh/authorized_keys" "/home/$SUDO_USERNAME/.ssh/authorized_keys_backup"
else
  touch "/home/$SUDO_USERNAME/.ssh/authorized_keys"
  chmod 644 "/home/$SUDO_USERNAME/.ssh/authorized_keys"
fi

# Get SSH Public key
read -p "Please enter Public Key path: " KEYPATH;
if [ ! -f "$KEYPATH" ]; then
  echo "Public Key file not found."
  read -p "Please paste your Public Key: " KEYCONTENT;
fi

if [ ! -z "$KEYCONTENT" ]; then
  KEYPATH="$CDIR/public_key.tmp"
  echo "$KEYCONTENT" > $KEYPATH
fi

# Check public key validity & do copy
if [ -z "$(ssh-keygen -l -f $1 2>/dev/null)" ]; then
  echo "Given key is not valid, abording.";
else
  cat "$KEYPATH" >> "/home/$SUDO_USERNAME/.ssh/authorized_keys";
  echo "Public key succesfully added to authorized keys.";
fi

# Clear temporary public key file if key was given into stdin
if [ ! -z "$KEYCONTENT" ]; then
  rm $KEYPATH
fi