# == Class: dc_profile::openstack::cinder
#
# The OpenStack block storage service in a Docker container
#
class dc_profile::openstack::cinder {

  docker::run { 'cinder':
    image            => 'registry.datacentred.services:5000/cinder:mitaka',
    ports            => [ '8776:8776'],
    extra_parameters => [
      '--log-driver=syslog',
      '--log-opt syslog-address=udp://127.0.0.1:514',
      '--log-opt syslog-facility=daemon',
      '--log-opt tag=cinder'
    ],
  }

  include ::dc_icinga::hostgroup_cinder

}
