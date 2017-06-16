# == Class: dc_profile::openstack::cinder
#
# The OpenStack block storage service in a Docker container
#
class dc_profile::openstack::cinder {

  include ::dc_icinga::hostgroup_cinder

  $containers = hiera('containers')

  dc_docker::run { 'cinder':
    * => $containers['cinder']
  }

}
