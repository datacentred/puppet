# Class: dc_profile::openstack::horizon
#
# Class to deploy the OpenStack dashboard in a
# Docker container
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::horizon {

  $containers = hiera('containers')

  dc_docker::run { 'horizon':
    * => $containers['horizon']
  }

}
