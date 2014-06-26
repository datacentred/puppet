class network_weathermap(
  $version = '0.97c'
) {

  include wget

  if ! defined(Package['unzip']) {
    package { 'unzip': }
  }

  file { '/var/www/network-weathermap':
    ensure => directory,
  } ->

  file { '/var/www/network-weathermap/versions':
    ensure => directory,
  } ->

  file { "/var/www/network-weathermap/versions/${version}":
    ensure => directory,
  } ->

  wget::fetch { "http://www.network-weathermap.com/files/php-weathermap-${version}.zip":
    destination => "/tmp/php-weathermap-${version}.zip",
    cache_dir   => '/var/cache/wget',
  } ->

  exec { "extract_network_weathermap_${version}":
    command => "/usr/bin/unzip /tmp/php-weathermap-${version}.zip -d /var/www/network-weathermap/versions/${version}",
    creates => "/var/www/network-weathermap/versions/${version}/weathermap",
    require => Package['unzip'],
  } ->

  file { '/var/www/network-weathermap/latest':
    ensure => symlink,
    target => "/var/www/network-weathermap/versions/${version}/weathermap",
  }
}
