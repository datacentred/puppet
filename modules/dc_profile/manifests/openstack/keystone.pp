# == Class: dc_profile::openstack::keystone
#
# A class to deploy OpenStack Keystone in a container
#
class dc_profile::openstack::keystone {

  include ::dc_icinga::hostgroup_keystone

  dc_docker::run { 'keystone':
    image => 'registry.datacentred.services:5000/keystone:mitaka-8f2bc1b',
  }

}
