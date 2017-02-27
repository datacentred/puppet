# Class: dc_profile::util::wordpress
#
# Configure nginx, MariaDB, and Wordpress for www.datacentred.co.uk
#
class dc_profile::util::wordpress {
  include ::wordpress
  include ::mysql::server
  include ::nginx
  include ::apt
  include ::php

  file { '/srv/www/':
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    require => Package['nginx'],
  }

  create_resources(nginx::resource::vhost, hiera_hash(nginx_vhost))
  create_resources(nginx::resource::location, hiera_hash(nginx_locations))

}
