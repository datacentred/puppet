# Class: dc_role::oscontroller
#
# OpenStack Cloud Controller role class
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::oscontroller inherits dc_role {

  contain dc_profile::openstack::keystone
  contain dc_profile::openstack::cinder
  contain dc_profile::openstack::glance
  contain dc_profile::openstack::nova
  contain dc_profile::openstack::neutron_server
  contain dc_profile::openstack::horizon
  contain dc_profile::openstack::ceilometer

  Class['dc_profile::openstack::keystone'] ->
  Class['dc_profile::openstack::glance'] ->
  Class['dc_profile::openstack::cinder'] ->
  Class['dc_profile::openstack::nova'] ->
  Class['dc_profile::openstack::neutron_server'] ->
  Class['dc_profile::openstack::ceilometer'] ->
  Class['dc_profile::openstack::horizon']

}
