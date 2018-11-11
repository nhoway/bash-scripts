#!/bin/bash
# Source : https://www.howtoforge.com/tutorial/install-mongodb-on-ubuntu-16.04/
CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"

. $CDIR/scripts/store-config.sh
if [ -z "$1" ]; then
  . $CDIR/scripts/generate-password.sh
  MONGO_PASSWD="$(generatePassword 25)";
  setconfig $CCNF "MONGO_PASSWD" "$MONGO_PASSWD";
else
  MONGO_PASSWD=$1;
fi

# INSTALL MONGO
########################################
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl daemon-reload
sudo service mongod start

# ADD USERS AND COLLECTIONS
########################################
mongo < "use admin
db.createUser(
  {
    user: \"mongo_root\",
    pwd: \"$MONGO_PASSWD\",
    roles:[{role:\"root\", db:\"admin\"}]
  }
);"

# CHANGE STORAGE PATH
########################################
#sudo mkdir -p /data/db/
#sudo chown -R ubuntu:ubuntu /data/db
#sudo sed -i -e 's/\/var\/lib\/mongodb/custom\/path/' /etc/mongod.conf

# ENABLE USER AUTH
########################################
#sudo vi /etc/mongod.conf
#uncomment security
sudo sed -i -e 's/#security:/security:\n  authorization: enabled/' /etc/mongod.conf

# vim /lib/systemd/system/mongod.service
# On the 'ExecStart' line 9, add the new option '--auth'.
# ExecStart=/usr/bin/mongod --quiet --auth --config /etc/mongod.conf
#sudo sed -i -e'/^ExecStart/s/quiet/quiet --auth/' /lib/systemd/system/mongod.service

# ENABLE DISTANT ACCESS
########################################
MAINIF=$( route -n | grep '^0\.0\.0\.0' | head -n 1 | awk '{print $NF}' )
SERVERIP=$( ifconfig $MAINIF | { IFS=' :';read r;read r r a r;echo $a; } )
sudo sed -i -e "s/127.0.0.1/127.0.0.1,$SERVERIP/" /etc/mongod.conf

# CHANGE LISTENING PORT
########################################
#sudo sed -i_bk -e 's/27017/27018/' /etc/mongod.conf

# RESTART MONGO DB
########################################
sudo systemctl daemon-reload
sudo service mongod restart

# CONNECT TO MONGO WITH AUTH
########################################
# mongo -u "USERNAME" -p "PASSWORD" --authenticationDatabase admin
