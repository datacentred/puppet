# Class: dc_role::osdbmq
#
# Core OpenStack MariaDB / Rabbit MQ
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::osdbmq inherits dc_role {

  contain dc_profile::openstack::galera
  contain dc_profile::openstack::rabbitmq
  contain dc_profile::openstack::memcached

  contain dc_profile::openstack::keystone_db
  contain dc_profile::openstack::cinder_db
  contain dc_profile::openstack::glance_db
  contain dc_profile::openstack::neutron_db
  contain dc_profile::openstack::nova_db
  contain dc_profile::openstack::heat_db

  Class['dc_profile::openstack::galera'] ->
  Class['dc_profile::openstack::keystone_db'] ->
  Class['dc_profile::openstack::cinder_db'] ->
  Class['dc_profile::openstack::glance_db'] ->
  Class['dc_profile::openstack::neutron_db'] ->
  Class['dc_profile::openstack::nova_db'] ->
  Class['dc_profile::openstack::heat_db']

}
