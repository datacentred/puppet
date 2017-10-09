# == Class: dc_profile::openstack::cinder
#
# The OpenStack block storage service in a Docker container
#
class dc_profile::openstack::cinder {

  include ::dc_icinga::hostgroup_cinder

  $containers = hiera_hash('containers')

  dc_docker::run { 'cinder':
    * => $containers['cinder']
  }

  dc_docker::logrotate { 'cinder': }

}
