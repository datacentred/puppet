# Class: dc_profile::mon::icinga_server
#
# Icinga server instance
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::icinga_server {

  contain apache
  contain apache::mod::php
  contain apache::mod::rewrite

  contain php
  contain php::apache

  contain dc_icinga::server
  contain dc_icinga::hostgroup_http

  contain dc_nsca::server

  contain pagerduty

  # Requires the nagios user to be installed first
  Class['::dc_icinga::server'] ->
  Class['::dc_nsca::server']

  $nagios_api_username = hiera(nagios_api_username)
  $nagios_api_password = hiera(nagios_api_password)

  file { '/etc/apache2/api-icinga.htpasswd':
    ensure => present,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0600'
  } ->

  httpauth { $nagios_api_username:
    file     => '/etc/apache2/api-icinga.htpasswd',
    password => $nagios_api_password,
  }

  apache::vhost { 'icinga-web':
    servername  => "icinga.${::domain}",
    docroot     => '/usr/share/icinga-web/pub',
    port        => 80,
    aliases     => [
      {
        aliasmatch => '/modules/([A-Za-z0-9]+)/resources/styles/([A-Za-z0-9]+\.css)$',
        path       => '/usr/share/icinga-web/app/modules/$1/pub/styles/$2',
      },
      {
        aliasmatch => '/icinga-web/images/([A-Za-z0-9]+)/([A-Za-z_\-0-9]+\.(?:png|gif|jpg))$',
        path       => '/usr/share/icinga-web/pub/images/$1/$2',
      },
      {
        alias => '/js/ext3/',
        path  => '/usr/share/icinga-web/lib/ext3/',
      },
    ],
    directories => [
      {
        path            => '/usr/share/icinga-web/pub',
        custom_fragment => 'RewriteEngine on
                            RewriteBase /
                            RewriteRule ^$ index.php?/ [QSA,L]
                            RewriteCond %{REQUEST_FILENAME} !-f
                            RewriteCond %{REQUEST_FILENAME} !-d
                            RewriteRule ".*" index.php?/$0 [QSA,L]',
      },
    ],
  }

  apache::vhost { 'icinga-api':
    servername  => "api-icinga.${::domain}",
    docroot     => '/var/www/html',
    port        => 80,
    directories => [
      {
        'path'           => '/schedule_downtime',
        'provider'       => 'location',
        'auth_name'      => 'Icinga API',
        'auth_type'      => 'basic',
        'auth_user_file' => '/etc/apache2/api-icinga.htpasswd',
        'require'        => 'valid-user',
      },
      {
        'path'           => '/cancel_downtime',
        'provider'       => 'location',
        'auth_name'      => 'Icinga API',
        'auth_type'      => 'basic',
        'auth_user_file' => '/etc/apache2/api-icinga.htpasswd',
        'require'        => 'valid-user',
      },
      {
        'path'           => '/state',
        'provider'       => 'location',
        'auth_name'      => 'Icinga API',
        'auth_type'      => 'basic',
        'auth_user_file' => '/etc/apache2/api-icinga.htpasswd',
        'require'        => 'valid-user',
      },
    ],
    proxy_pass  => [
      {
        'path' => '/schedule_downtime',
        'url'  => 'http://localhost:24554/schedule_downtime'
      },
      {
        'path' => '/cancel_downtime',
        'url'  => 'http://localhost:24554/cancel_downtime'
      },
      {
        'path' => '/state',
        'url'  => 'http://localhost:24554/state'
      },
    ],
  }

}
