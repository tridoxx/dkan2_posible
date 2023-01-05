#!/bin/sh

# echo "Client ID is $CLIENTID";
# URL=https://github.com/markaspot/$CLIENTID/archive/refs/heads/master.zip
# echo "Installing from $URL";

echo "------------------------------";
echo "Init Medata installing";


echo "------------------------------";
echo "Deleting docroot/sites/settings.prod.php";
rm docroot/sites/settings.prod.php

echo "------------------------------";
echo "Creating docroot/sites/settings.prod.php";
touch docroot/sites/settings.prod.php

echo "------------------------------";
echo "Giving permissions docroot/sites/settings.prod.php";
chmod -R 777 docroot/sites/settings.prod.php

echo "------------------------------";
echo "Echo settings['file_public_base_url'] on docroot/sites/settings.prod.php";
echo '$settings["file_public_base_url"] = "http://ec2-3-129-204-103.us-east-2.compute.amazonaws.com/sites/default/files";' | tee -a >> docroot/sites/settings.prod.php

echo "------------------------------";
echo "ini_set('memory_limit', '4000M'); on docroot/sites/default/settings.php";
echo "ini_set('memory_limit', '4000M');" | tee -a >> docroot/sites/default/settings.php

echo "------------------------------";
echo "Deleting last line on docroot/sites/default/settings.prod.php";
sed -i "$(( $(wc -l < docroot/sites/default/settings.prod.php))),$ d" docroot/sites/default/settings.prod.php

echo "------------------------------";
echo "Echo settings['file_public_base_url'] on docroot/sites/default/settings.prod.php";
echo '$settings["file_public_base_url"] = "http://ec2-3-129-204-103.us-east-2.compute.amazonaws.com/sites/default/files";' | tee -a >> docroot/sites/default/settings.prod.php

echo "------------------------------";
echo "Installing Easy breadcrumbs...";
composer require 'drupal/easy_breadcrumb:^2.0'

echo "------------------------------";
echo "Executing composer update";
composer update \
    --ignore-platform-reqs \
    --no-interaction \
    --no-dev \
    --prefer-dist;

echo "------------------------------";
echo "Deleting docroot/themes/custom";
rm -rf docroot/themes/custom

echo "------------------------------";
echo "Creating docroot/themes/custom";
mkdir -p docroot/themes/custom

echo "------------------------------";
echo "Giving permissions docroot/themes/custom";
chmod -R 777 docroot/themes/custom

echo "------------------------------";
echo "Cloning custom_drupal9_theme theme on docroot/themes/custom/custom_drupal9_theme";
git clone https://github.com/CarlosJaramilloDev/custom_drupal9_theme.git docroot/themes/custom/custom_drupal9_theme

# echo "Override Frontend with CGN UI"
echo "------------------------------";
echo "Deleting src/frontend";
rm -rf src/frontend

echo "------------------------------";
echo "Cloning https://github.com/CarlosJaramilloDev/data-catalog-dkan-medata.git on src/frontend";
git clone https://github.com/CarlosJaramilloDev/data-catalog-dkan-medata.git src/frontend

echo "------------------------------";
echo "Go to src/frontend/";
cd src/frontend/

echo "------------------------------";
echo "Runing npm install && npm run build";
npm install && npm run build

echo "------------------------------";
echo "Go to /app/data";
cd /app/data

echo "------------------------------";
echo "Install DKAN from DRUSH and execute drush commands";
drush site:install standard --site-name "Medata" -y
drush en dkan dkan config_update_ui -y
drush config-set system.performance css.preprocess 0 -y
drush config-set system.performance js.preprocess 0 -y

echo "------------------------------";
echo "Create docroot/sites/default/files/uploaded_resources &&  docroot/sites/default/files/resources folders. Give permissions";
mkdir -p docroot/sites/default/files/uploaded_resources
mkdir -p docroot/sites/default/files/resources
chmod -R 777 docroot/sites/default/files

echo "------------------------------";
echo "DRUSH Enable dkan_js_frontend, theme enable dkan_js_frontend_bartik and config default dkan_js_frontend";
drush en -y dkan_js_frontend
drush then -y dkan_js_frontend_bartik
drush config-set -y system.theme default dkan_js_frontend_bartik

echo "------------------------------";
echo "Enable Medata Theme and config default dkan_js_frontend";
# drush en -y custom_drupal9_theme
drush then -y custom_drupal9_theme
drush config-set -y system.theme default custom_drupal9_theme

echo "------------------------------";
echo "Set /home as default page";
drush config-set -y system.site page.front "/home"

echo "------------------------------";
echo "Import dkan content with drush";
drush en sample_content -y
echo "enable mysql_importer_for_datasets";
composer require 'drupal/blog:^3.1'
drush pm:enable datastore_mysql_import
drush pm:enable easy_breadcrumb
drush pm:enable blog
rm -rf /tmp/$CLIENTID-master
echo "------------------------------";
echo "Installation done";
drush user:password admin "5uE05Tlx@aM7"

rm -r docroot/sites/default/files/resources/*
rm -r docroot/sites/default/files/distribution/*


time  drush dkan:harvest:register '{ "identifier": "50_datasets", "extract": { "type": "\\Harvest\\ETL\\Extract\\DataJson", "uri": "http://portal.antivirusparaladesercion.com/schema_ejemplo_structura.json" }, "transforms": ["\\Drupal\\harvest\\Transform\\ResourceImporter"], "load": { "type": "\\Drupal\\harvest\\Load\\Dataset" } }'
time drush dkan:harvest:run 50_datasets
time drush  queue:run datastore_import
drush dkan:metastore-search:rebuild-tracker
time drush  sapi-i 
