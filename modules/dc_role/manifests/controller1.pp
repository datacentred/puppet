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

  # mysql-server is pulled in as a dependancy from python-mysql
  # via python-nova.  It shouldn't be running on the controller1 instance,
  # however - all MySQL databases currently reside elsewhere.
  service { 'mysql':
    ensure => stopped,
  }

}
