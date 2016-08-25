sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo mkdir -p /data/db/
sudo chown -R ubuntu:ubuntu /data/db
sudo service mongod start

# Enable user auth
#sudo vi /etc/mongod.conf
#uncomment security

mongo
use admin
db.createUser(
  {
    user: "adm",
    pwd: "password",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
);
db.grantRolesToUser("adm",["readWrite"]);

use myDB
db.createUser(
  {
    user: "usr",
    pwd: "password",
    roles: [ { role: "readWrite", db: "myDB" } ]
  }
);

# db.auth("usr", "password")
# db.changeUserPassword("usr", "new password")

# Enable distant access
# sudo vi /etc/mongod.conf
# Add bindips separated by commas