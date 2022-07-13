<?php

// @codingStandardsIgnoreFile

/**
 * @file
 * Drupal site-specific configuration file.
 */

// Other helpful settings.
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';
$settings['entity_update_batch_size'] = 50;
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

// Database connection.
$databases['default']['default'] = [
  'database' => getenv('DRUPAL_DATABASE_NAME'),
  'username' => getenv('DRUPAL_DATABASE_USERNAME'),
  'password' => getenv('DRUPAL_DATABASE_PASSWORD'),
  'prefix' => '',
  'host' => getenv('DKAN_MARIADB_SERVICE_HOST'),
  'port' => 3306,
  'namespace' => 'Drupal\Core\Database\Driver\mysql',
  'driver' => 'mysql',
];

$settings['hash_salt'] = getenv('DRUPAL_HASH_SALT');

// Add SMTP Setting by GITLAB ENV Specific secret variables.
$config['smtp.settings']['smtp_username'] = getenv('SMTP_USER');
$config['smtp.settings']['smtp_password'] = base64_decode(getenv('SMTP_PASSWORD'));

$settings['trusted_host_patterns'] = [ '.*' ];

// Needed for sample content
$settings['file_public_base_url'] = "http://localhost/sites/default/files";


