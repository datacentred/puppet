# Class: dc_wordpress::server
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
class dc_wordpress::server (
  $vhost       = undef,
  $server_name = [],
) {

  class { '::nginx': manage_repo => false }

  nginx::resource::vhost { $vhost:
    www_root         => "/var/www/${vhost}",
    index_files      => ['index.php', 'index.html', 'index.htm'],
    server_name      => $server_name,
    try_files        => ['$uri', '$uri/', '/index.php?q=$uri&$args'],
    vhost_cfg_append => {
      'error_page 500 502 503 504'  => '/50x.html',
      'error_page 404'              => '/404.html',
      'port_in_redirect'            => 'off',
    }
  }

  nginx::resource::location { '= /50x.html':
    ensure   => present,
    www_root => '/usr/share/nginx/html',
    vhost    => $vhost,
  } 

  nginx::resource::location { '~ \.php$':
    ensure              => present,
    vhost               => $vhost,
    www_root            => "/var/www/${vhost}",
    fastcgi             => 'unix:/var/run/php5-fpm.sock',
    fastcgi_split_path  => '^(.+\.php)(/.+)$',
    location_cfg_append => {
      'fastcgi_index' => 'index.php',
      'try_files'     => '$uri =404',
    }
  }
}
