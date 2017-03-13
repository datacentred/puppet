# Class: dc_profile::util::wordpress_memcache
#
# Configure memcache for Wordpress
#
class dc_profile::util::wordpress_memcache {
  include ::memcached

  package { 'php-memcached':
    ensure => 'installed',
  }

  file { '/srv/www/datacentred.co.uk':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { '/srv/www/datacentred.co.uk/wp-content':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { '/srv/www/datacentred.co.uk/wp-content/object-cache.php':
    ensure => 'file',
    owner  => 'www-data',
    group  => 'www-data',
    source => 'puppet:///modules/wordpress/object-cache.php',
    notify => Service['php7.0-fpm']
  }
}
