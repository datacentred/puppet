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

  dc_docker::run { 'horizon':
    image => 'registry.datacentred.services:5000/horizon:mitaka',
  }

}
