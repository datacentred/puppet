# Class: dc_profile::util::website_wordpress
#
# Deploys main production website (www.datacentred.co.uk)
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::website_wordpress {
  include ::wordpress
  include ::mysql::server
  include ::nginx
  include ::dc_backup
  include ::php::fpm
  include ::php::extension::mysql

file { ['/var/www/', '/var/www/datacentred/',]:
  ensure => 'directory',
  }
# There's an error in Ubuntu 14.04 with php-fpm spawning processes to quickly, which causes php5-fpm to become non-functional.
# This following init file fixes this, but this should be removed when the 16.04 upgrade occurs!

file { '/etc/init/php5-fpm.override':
  ensure  => 'present',
  replace => 'no',
  content => 'reload signal USR2',
  mode    => '0644',
  }

php::fpm::pool { 'www':
  listen                    => '/var/run/php5-fpm.sock',
  listen_owner              => 'www-data',
  listen_group              => 'www-data',
  listen_mode               => '0660',
  listen_allowed_clients    => 'any',
  require                   => Package['nginx'],
  }

create_resources(nginx::resource::vhost, hiera_hash(nginx_vhost))
create_resources(nginx::resource::location, hiera_hash(nginx_locations))
create_resources(nginx::resource::upstream, hiera_hash(nginx_upstream))

}
