#!/bin/sh

export DKTL_PROXY_DOMAIN="localhost"
echo "Client ID is $CLIENTID";
URL=https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
echo "Updating from $URL";
# exit;

# cd src/frontend/
# npm install

# Get latest customizations from client's repo
$URL = https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
echo $URL;
wget --no-check-certificate https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
unzip master.zip -d /tmp/
cp -r /tmp/$CLIENTID-master/schema/collections docroot/schema/
rm -r /tmp/$CLIENTID-master
echo "Installation done"
