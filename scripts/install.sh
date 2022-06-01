#!/bin/sh

#source /Users/sun/.zprofile


 export DKTL_PROXY_DOMAIN="localhost"


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


 # cd src/frontend/
 # npm install

 # Get latest customizations from client's repo
 curl -LO 'https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip'
 unzip master.zip -d /tmp/
 cp -r /tmp/$CLIENTID-master/schema/collections docroot/schema/
 rm -r /tmp/$CLIENTID-master
