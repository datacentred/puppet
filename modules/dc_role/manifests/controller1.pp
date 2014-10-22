# Class: dc_role::controller1
#
# OpenStack nova-*, neutron-server, rabbitmq
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::controller1 inherits dc_role {

  contain dc_profile::openstack::nova_mq
  contain dc_profile::openstack::nova
  contain dc_profile::openstack::neutron_server
  contain dc_profile::openstack::neutron_common
  contain dc_profile::openstack::cinder

  Class['dc_profile::openstack::nova_mq'] ->
  Class['dc_profile::openstack::nova'] ->
  Class['dc_profile::openstack::cinder'] ->
  Class['dc_profile::openstack::neutron_server']

}
