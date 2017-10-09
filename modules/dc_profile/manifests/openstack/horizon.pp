# == Class: dc_profile::openstack::horizon
#
class dc_profile::openstack::horizon {

  $containers = hiera_hash('containers')

  dc_docker::run { 'horizon':
    * => $containers['horizon']
  }

}
