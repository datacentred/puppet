# Class: dc_wordpress::php
#
# Setup the php backend for a wordpress website
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
class dc_wordpress::php {

  include php::fpm
  include php::extension::mysql

  # Fpm pool configuration which replicates the original setup on datacentred
  # The php module had some weird defaults
  php::fpm::pool { 'www':
    listen                 => '/var/run/php5-fpm.sock',
    listen_owner           => 'www-data',
    listen_group           => 'www-data',
    listen_mode            => '0660',
    listen_allowed_clients => 'any',
    pm_max_children        => '5', 
    pm_start_servers       => '2',
    pm_min_spare_servers   => '1',
    pm_max_spare_servers   => '3',
    chdir                  => '/',
    require                => Class ['php::fpm'],
    before                 => Class ['php::extension::mysql'],
  }
}
