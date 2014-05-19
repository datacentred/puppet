class network_weathermap(
  $version = '0.97c'
) {

  include wget

  if ! defined(Package['unzip']) {
    package { 'unzip': }
  }

  file { 
    ['/opt/network-weathermap', 
     '/opt/network-weathermap/versions']: 
    ensure => directory,
  } ->

  wget::fetch { "http://www.network-weathermap.com/files/php-weathermap-${version}.zip":
    destination => "/tmp/php-weathermap-${version}.zip",
    cache_dir   => '/var/cache/wget',
  } ->

  exec { "extract_network_weathermap_${version}":
    command => "/usr/bin/unzip /tmp/php-weathermap-${version}.zip -d /opt/network-weathermap/versions/${version}",
    creates => "/opt/network-weathermap/versions/${version}",
    require => Package['unzip'],
  } -> 


  file { '/opt/network-weathermap/latest':
    ensure => symlink,
    target => "/opt/network-weathermap/versions/${version}/weathermap",
  }

}
