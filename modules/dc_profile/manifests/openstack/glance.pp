# == Class: dc_profile::openstack::glance
#
# The OpenStack image service in a Docker container
#
class dc_profile::openstack::glance {

  include ::dc_icinga::hostgroup_glance

  docker::run { 'glance':
    image            => 'registry.datacentred.services:5000/glance:mitaka',
    ports            => [ '9191:9191', '9292:9292' ],
    volumes          => [ '/var/lib/glance' ],
    extra_parameters => [
      '--log-driver=syslog',
      '--log-opt syslog-address=udp://127.0.0.1:514',
      '--log-opt syslog-facility=daemon',
      '--log-opt tag=glance'
    ],
  }

}
