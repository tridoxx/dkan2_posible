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
  'host' => getenv('DRUPAL_DATABASE_HOST'),
  'port' => 3306,
  'namespace' => 'Drupal\Core\Database\Driver\mysql',
  'driver' => 'mysql',
];

$settings['hash_salt'] = getenv('DRUPAL_HASH_SALT');

# var_dump($proxy_domain);
$settings['file_public_base_url'] = "http://localhost/sites/default/files";



/**
 * External access proxy settings:
 *
 * If your site must access the Internet via a web proxy then you can enter the
 * proxy settings here. Set the full URL of the proxy, including the port, in
 * variables:
 * - $settings['http_client_config']['proxy']['http']: The proxy URL for HTTP
 *   requests.
 * - $settings['http_client_config']['proxy']['https']: The proxy URL for HTTPS
 *   requests.
 * You can pass in the user name and password for basic authentication in the
 * URLs in these settings.
 *
 * You can also define an array of host names that can be accessed directly,
 * bypassing the proxy, in $settings['http_client_config']['proxy']['no'].
 */
$settings['http_client_config']['proxy']['http'] = getenv('http_proxy');
$settings['http_client_config']['proxy']['https'] = getenv('https_proxy');
$settings['http_client_config']['proxy']['no'] = [getenv('no_proxy')];

// Add SMTP Setting by GITLAB ENV Specific secret variables.
$config['smtp.settings']['smtp_username'] = getenv('SMTP_USER');
$config['smtp.settings']['smtp_password'] = base64_decode(getenv('SMTP_PASSWORD'));

// Add API Key for API_USER as by GITLAB ENV Specific secret variable.
$config['services_api_key_auth.api_key.api_user_key']['key'] = getenv('GEOREPORT_API_USER_KEY');

$settings['trusted_host_patterns'] = [ '.*' ];


