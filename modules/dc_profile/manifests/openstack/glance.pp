# == Class: dc_profile::openstack::glance
#
# The OpenStack image service in a Docker container
#
class dc_profile::openstack::glance {

  include ::dc_icinga::hostgroup_glance

  dc_docker::run { 'glance':
    image   => 'registry.datacentred.services:5000/glance:mitaka-8f2bc1b',
    volumes => [ '/var/lib/glance' ],
  }

}
