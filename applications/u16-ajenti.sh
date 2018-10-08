#!/bin/bash
sudo su

# Install Ajenti
wget http://repo.ajenti.org/debian/key -O- | apt-key add -
echo "deb http://repo.ajenti.org/ng/debian main main ubuntu" >> /etc/apt/sources.list
apt-get update -y
apt-get upgrade -y

# Get mysql root password
CDIR="$(dirname `realpath -s $0`)/../.."
CCNF="$CDIR/.sya"

. $CDIR/bash-scripts/scripts/store-config.sh
if [ -z "$1" ]; then 
  MYSQL_PASSWD=$1;
else
  . $CDIR/bash-scripts/scripts/generate-password.sh
  MYSQL_PASSWD="$(generatePassword 25)";
  setconfig $CCNF "MYSQL_PASSWD" "$MYSQL_PASSWD";
fi

# Prepare debconf
apt-get install debconf -y
echo mysql-server mysql-server/root_password select "$MYSQL_PASSWD" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "$MYSQL_PASSWD" | debconf-set-selections

# Install Ajenti
apt-get install ajenti -y
service ajenti restart

# Uninstall Apache2
sudo apt-get autoremove -y && sudo apt-get remove apache2* -y

# Install Ajenti-v
apt-get install ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php7.0-fpm zip -y

# Install NodeJS
apt-get install ajenti-v-nodejs -y

# Install Python
apt-get install ajenti-v-python-gunicorn -y
apt-get install python-pip -y

# Install FTP Server
apt-get install ajenti-v-ftp-pureftpd -y


# Install Ruby
#apt-get install ajenti-v-ruby-puma -y

# Install Mail Server
#apt-get install ajenti-v-mail -y

# Add POP support
#apt-get install courier-pop -y

# Restart Services
service php7.0-fpm restart
service nginx restart
service ajenti restart

# Exit sudo
exit