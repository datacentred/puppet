# == Class: dc_profile::openstack::neutron::server
#
class dc_profile::openstack::neutron::server {

  include ::dc_icinga::hostgroup_neutron_server

  $containers = hiera('containers')

  dc_docker::run { 'neutron':
    * => $containers['neutron']
  }

  logrotate::rule { 'neutron':
    path          => '/var/log/neutron/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
  }

}
