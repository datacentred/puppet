# == Class: ::dc_profile::openstack::docker::logging
#
class dc_profile::openstack::docker::logging {

  $_dirs = ['/var/log/cinder',
            '/var/log/glance',
            '/var/log/horizon',
            '/var/log/keystone',
            '/var/log/neutron/',
            '/var/log/nova/']

  file { $_dirs:
    ensure => directory,
    owner  => 'sysadmin',
    group  => 'adm',
  }

}
