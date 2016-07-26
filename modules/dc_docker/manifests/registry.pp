# == Class: ::dc_docker::registry
#
# Runs a Docker Registry container, with a
# Swift storage backend configured based on parameters
#
class dc_docker::registry (
  $conf_file = '/etc/docker/registry_config.yml',
  $authurl = 'https://compute.datacentred.io:5000/v2.0/',
  $username,
  $password,
  $tenant,
  $tenantid,
  $region = 'sal01',
  $container,
  $rootdirectory,
  $httpaddr = ':5000',
){

  include ::docker

  file { $conf_file:
    content => template('dc_docker/registry_config.yml.erb'),
    mode    => '0600',
    require => Class['::docker'],
  }

  docker::image { 'registry':
    ensure    => present,
    image_tag => '2',
  }

  docker::run { 'registry':
    image   => 'registry:2',
    ports   => ['5000:5000'],
    volumes => ["${conf_file}:/etc/docker/registry/config.yml"],
    require => File[$conf_file],
  }

}
