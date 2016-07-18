# Install Ajenti
apt-get update
wget http://repo.ajenti.org/debian/key -O- | apt-key add -
echo "deb http://repo.ajenti.org/ng/debian main main ubuntu" >> /etc/apt/sources.list
apt-get update
apt-get install ajenti -y
service ajenti restart

# Uninstall Apache2
sudo apt-get autoremove && sudo apt-get remove apache2* -y

# Install Ajenti-v
apt-get install ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php-fpm php5-mysql -y

# Install Ruby
apt-get install ajenti-v-ruby-puma -y

# Install Python
apt-get install ajenti-v-python-gunicorn -y
apt-get install python-pip -y

# Install FTP Server
apt-get install ajenti-v-ftp-pureftpd -y

# Install Mail Server
apt-get install ajenti-v-mail -y

# Add POP support
apt-get install courier-pop -y

# Restart Services
sudo service php5-fpm restart
sudo service nginx restart
sudo service ajenti restart
