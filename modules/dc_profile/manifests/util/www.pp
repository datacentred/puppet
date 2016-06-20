# Class: dc_profile::util::www
#
# Configure nginx, MariaDB, and Wordpress for www.datacentred.co.uk
#
class dc_profile::util::www {
  include ::wordpress
  include ::mysql::server
  include ::nginx
  include ::php::fpm
  include ::php::extension::mysql

  file { ['/srv/www/']:
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    require => Package['nginx'],
  }
  
  # There's an error in Ubuntu 14.04 with php-fpm spawning processes to quickly,
  # which causes php5-fpm to become non-functional.  This following init file
  # fixes this, but this should be removed when the 16.04 upgrade occurs!
  file { '/etc/init/php5-fpm.override':
    ensure  => 'present',
    content => 'reload signal USR2',
    mode    => '0644',
  }
  
  php::fpm::pool { 'www':
    listen                 => '/var/run/php5-fpm.sock',
    listen_owner           => 'www-data',
    listen_group           => 'www-data',
    listen_mode            => '0660',
    listen_allowed_clients => 'any',
  }
  
  create_resources(nginx::resource::vhost, hiera_hash(nginx_vhost))
  create_resources(nginx::resource::location, hiera_hash(nginx_locations))

}
