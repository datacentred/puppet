# Class: dc_profile::wordpress::server
#
# Setup the webserver for wordpress.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_profile::wordpress::server {

  class { '::nginx': manage_repo => false }

  nginx::resource::vhost { 'www.datacentred.co.uk':
    www_root         => '/var/www/www.datacentred.co.uk',
    index_files      => ['index.php', 'index.html', 'index.htm'],
    server_name      => [
      'www.datacentred.co.uk', 
      'datacentred.co.uk',
      'wwww0.datacentred.co.uk'],
    try_files        => ['$uri', '$uri/', '/index.php?q=$uri&$args'],
    vhost_cfg_append => {
      'error_page 500 502 503 504' => '/50x.html',
      'error_page 404'              => '/404.html',
      'port_in_redirect'            => 'off',
    }
  }

  nginx::resource::location { '= /50x.html':
    ensure   => present,
    www_root => '/usr/share/nginx/html',
    vhost    => 'www.datacentred.co.uk',
  } 

  nginx::resource::location { '~ \.php$':
    ensure              => present,
    vhost               => 'www.datacentred.co.uk',
    www_root            => '/var/www/www.datacentred.co.uk',
    fastcgi             => 'unix:/var/run/php5-fpm.sock',
    fastcgi_split_path  => '^(.+\.php)(/.+)$',
    location_cfg_append => {
      'fastcgi_index' => 'index.php',
      'try_files'     => '$uri =404',
    }
  }
}