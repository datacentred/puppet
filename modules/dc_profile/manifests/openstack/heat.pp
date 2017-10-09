# == Class: dc_profile::openstack::heat
#
class dc_profile::openstack::heat {

  $containers = hiera_hash('containers')

  dc_docker::run { 'heat':
    * => $containers['heat']
  }

  dc_docker::logrotate { 'heat': }

}
