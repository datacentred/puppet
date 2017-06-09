# == Class: dc_profile::openstack::heat
#
class dc_profile::openstack::heat {

  $containers = hiera('containers')

  dc_docker::run { 'heat':
    * => $containers['heat']
  }

  ensure_packages([ 'heat-api','heat-api','heat-common', 'heat-engine'], { ensure => purged })

}
