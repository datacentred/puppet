# == Class: dc_profile::openstack::glance
#
# The OpenStack image service in a Docker container
#
class dc_profile::openstack::glance {

  include ::dc_icinga::hostgroup_glance

  $containers = hiera('containers')

  dc_docker::run { 'glance':
    * => $containers['glance']
  }

  ensure_packages([ 'glance-api','glance-common','glance-registry'], { ensure => absent })

}
