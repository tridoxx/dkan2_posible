#!/bin/sh

echo "Client ID is $CLIENTID";
URL=https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
echo "Installing from $URL";

echo '$settings['file_public_base_url'] = "http://localhost/sites/default/files";' | tee -a >> docroot/sites/settings.prod.php

composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-dev \
    --prefer-dist;
## Override frontend

# echo "Override Frontend with CGN UI"
rm -rf src/frontend

# Get latest customizations from client's repo
# wget --no-check-certificate https://github.com/markaspot/data-catalog-app/archive/refs/heads/cgn.zip
# unzip cgn.zip -d /tmp/ && rm cgn.zip
# cp -r /tmp/data-catalog-app-cgn src/frontend && rm -rf /tmp/data-catalog-app-cgn

git clone https://github.com/GetDKAN/data-catalog-react.git src/frontend
cd src/frontend/
npm install node-sass@npm:sass
npm install && npm run build




drush site:install standard --site-name "DKAN" -y
drush en dkan dkan config_update_ui -y
drush config-set system.performance css.preprocess 0 -y
drush config-set system.performance js.preprocess 0 -y

mkdir -p sites/default/files/uploaded_resources
mkdir -p sites/default/files/resources
chmod -R 777 sites/default/files

drush en -y dkan_js_frontend
drush then -y dkan_js_frontend_bartik
drush config-set -y system.theme default dkan_js_frontend_bartik

drush config-set -y system.site page.front "/home"


drush en sample_content -y
drush  dkan:sample-content:create
drush  queue:run datastore_import
drush  dkan:metastore-search:rebuild-tracker
drush  sapi-i

 # Get latest customizations from client's repo
 $URL = https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
 wget --no-check-certificate https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
 unzip master.zip -d /tmp/ && rm master.zip
 mkdir -p docroot/schema && cp -r /tmp/$CLIENTID-master/schema/collections docroot/schema/
 rm -rf /tmp/$CLIENTID-master
 echo "Installation done";
