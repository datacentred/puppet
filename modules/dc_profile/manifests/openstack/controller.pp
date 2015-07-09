# == Class: dc_profile::openstack::controller
#
# Top level controller profile
#
class dc_profile::openstack::controller {

  contain dc_profile::openstack::keystone
  contain dc_profile::openstack::cinder
  contain dc_profile::openstack::glance
  contain dc_profile::openstack::nova
  contain dc_profile::openstack::neutron_server
  contain dc_profile::openstack::horizon
  contain dc_profile::openstack::ceilometer
  contain dc_profile::openstack::heat

  Class['dc_profile::openstack::keystone'] ->
  Class['dc_profile::openstack::glance'] ->
  Class['dc_profile::openstack::cinder'] ->
  Class['dc_profile::openstack::nova'] ->
  Class['dc_profile::openstack::neutron_server'] ->
  Class['dc_profile::openstack::ceilometer'] ->
  Class['dc_profile::openstack::horizon'] ->
  Class['dc_profile::openstack::heat']

  if $::osfamily == 'RedHat' {
    service { 'firewalld':
      ensure => 'stopped',
    }
    service { 'NetworkManager':
      ensure => 'stopped',
    }
  }

  include ::sysctls

}
