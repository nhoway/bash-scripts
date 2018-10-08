#!/bin/bash
# Configure emails
# Install msmtp:

sudo apt-get install msmtp ca-certificates
sudo nano /etc/msmtprc

#Create the following lines, only if you need TLS enabled and if you need to authenticate to the SMTP server:

# Set defaults.
defaults

# Enable or disable TLS/SSL encryption.
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

# Set up a default account's settings.
account default
host your_smtp_server_here
port 587
auth on
user your_username_here
password password
from sender_name@your_domain.com
logfile /var/log/msmtp/msmtp.log

#Obviously, you need to use your own values for the host, port, user, password, and from settings above…
#Edit the PHP.ini file (/etc/php5/apache2/php.ini) and change the sendmail path to point to /usr/bin/msmtp -t
#Then, issue these commands:

sudo mkdir /var/log/msmtp
sudo chown www-data:adm /var/log/msmtp
sudo vi /etc/logrotate.d/msmtp

#Create the following lines in that file:

/var/log/msmtp/*.log {
  rotate 12
  monthly
  compress
  missingok
  notifempty
}
