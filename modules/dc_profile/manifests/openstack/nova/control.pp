# Class: dc_profile::openstack::nova::control
#
# OpenStack Nova control components profile class
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova::control {

  include ::dc_icinga::hostgroup_nova_server

  $containers = hiera('containers')

  dc_docker::run { 'nova':
    * => $containers['nova']
  }

}
