# Class: dc_profile::openstack::neutron::server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron::server {

  include ::dc_icinga::hostgroup_neutron_server

  $containers = hiera('containers')

  dc_docker::run { 'neutron':
    * => $containers['neutron']
  }

}
