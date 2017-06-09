# == Class: dc_profile::openstack::neutron::server
#
class dc_profile::openstack::neutron::server {

  include ::dc_icinga::hostgroup_neutron_server

  $containers = hiera('containers')

  dc_docker::run { 'neutron':
    * => $containers['neutron']
  }


  ensure_packages([ 'neutron-common','neutron-plugin-ml2','neutron-server'], { ensure => absent })

}
