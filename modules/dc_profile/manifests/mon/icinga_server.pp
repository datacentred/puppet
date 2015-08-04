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
    servername    => $::fqdn,
    serveraliases => [
      $::hostname,
      "icinga.${::domain}",
    ],
    docroot       => '/usr/share/icinga-web/pub',
    port          => 80,
    aliases       => [
      {
        aliasmatch => '"^/icinga-web/modules/([A-Za-z0-9]+)/resources/styles/([A-Za-z0-9]+\.css)$"',
        path       => '/usr/share/icinga-web/app/modules/$1/pub/styles/$2',
      },
      {
        aliasmatch => '"^/icinga-web/modules/([A-Za-z0-9]+)/resources/images/([A-Za-z_\-0-9]+\.(?:png|gif|jpg))$"',
        path       => '/usr/share/icinga-web/app/modules/$1/pub/images/$2',
      },
      {
        alias => '/icinga-web/js/ext3/',
        path  => '/usr/share/icinga-web/lib/ext3/',
      },
      {
        alias => '/icinga-web/',
        path  => '/usr/share/icinga-web/pub/',
      },
    ],
    directories   => [
      {
        path     => '^/usr/share/icinga-web/app/modules/\w+/pub/styles/',
        provider => 'directorymatch',
        options  => [
          '-Indexes',
          '-MultiViews',
        ],
      },
      {
        path     => '^/usr/share/icinga-web/app/modules/\w+/pub/images/',
        provider => 'directorymatch',
        options  => [
          '-Indexes',
          '-MultiViews',
        ],
      },
      {
        path    => '/usr/share/icinga-web/lib/ext3/',
        options => [
          '-Indexes',
          '-MultiViews',
        ],
      },
      {
        path     => '/usr/share/icinga-web/pub',
        indexes  => 'index.php',
        options  => [
          '-MultiViews',
          '-Indexes',
          '+FollowSymLinks',
        ],
        rewrites => [
          {
            'rewrite_base' => '/icinga-web',
          },
          {
            'rewrite_rule' => '^$ index.php?/ [QSA,L]',
          },
          {
            'rewrite_cond' => [
              '%{REQUEST_FILENAME} !-f',
              '%{REQUEST_FILENAME} !-d',
            ],
          },
          {
            'rewrite_rule' => '".*" index.php?/$0 [QSA,L]',
          },
        ],
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
