#!/bin/bash

# Update and install required packages
sudo apt update
sudo apt install -y msmtp msmtp-mta ca-certificates mailutils

# Create msmtp configuration file
cat << EOF > ~/.msmtprc
# Default settings
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Gmail account
account        gmail
host           smtp.gmail.com
port           587
from           gunaachar003@gmail.com
user           gunaachar003@gmail.com
password       ekcvsxhdudyslryo

# Set default account
account default : gmail
EOF

# Secure permissions
chmod 600 ~/.msmtprc

# Create log file
touch ~/.msmtp.log
chmod 600 ~/.msmtp.log

echo "msmtp configuration completed. You can now send email using Gmail SMTP."
