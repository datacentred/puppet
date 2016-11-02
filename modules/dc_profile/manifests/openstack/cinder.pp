# == Class: dc_profile::openstack::cinder
#
# The OpenStack block storage service in a Docker container
#
class dc_profile::openstack::cinder {

  include ::dc_icinga::hostgroup_cinder

  dc_docker::run { 'cinder':
    image => 'registry.datacentred.services:5000/cinder:mitaka',
  }

}
