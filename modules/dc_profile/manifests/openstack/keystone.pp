# == Class: dc_profile::openstack::keystone
#
# A class to deploy OpenStack Keystone in a container
#
class dc_profile::openstack::keystone {

  include ::dc_icinga::hostgroup_keystone
  include ::sysctls

  docker::run { 'keystone':
    image            => 'registry.datacentred.services:5000/keystone:mitaka',
    ports            => [ '5000:5000', '35357:35357' ],
    extra_parameters => [
      '--log-driver=syslog',
      '--log-opt syslog-address=udp://127.0.0.1:514',
      '--log-opt syslog-facility=daemon',
      '--log-opt tag=keystone'
    ],
  }

}
