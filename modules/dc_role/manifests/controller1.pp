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
class dc_role::controller1 {

  contain dc_profile::openstack::nova_mq
  contain dc_profile::openstack::nova
  contain dc_profile::openstack::neutron_server

  Class['dc_profile::openstack::nova_mq'] ->
  Class['dc_profile::openstack::nova'] ->
  Class['dc_profile::openstack::neutron_server']

}
