# Class: dc_profile::openstack::nova::control
#
# OpenStack Nova control components profile class
#
class dc_profile::openstack::nova::control {

  include ::dc_icinga::hostgroup_nova_server

  $containers = hiera('containers')

  dc_docker::run { 'nova':
    * => $containers['nova']
  }

  dc_docker::logrotate { 'nova': }

}
