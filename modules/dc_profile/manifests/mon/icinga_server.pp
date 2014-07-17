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
        aliasmatch => '/modules/([A-Za-z0-9]+)/resources/images/([A-Za-z_\-0-9]+\.(?:png|gif|jpg))$',
        path       => '/usr/share/icinga-web/app/modules/$1/pub/images/$2',
      },
      {
        alias      => '/js/ext3/',
        path       => '/usr/share/icinga-web/lib/ext3/',
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
    servername  => "api.icinga.${::domain}",
    proxy_dest  => 'http://localhost:24554',
  }

}
