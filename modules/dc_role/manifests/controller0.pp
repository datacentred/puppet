# Class: dc_role::controller0
#
# Openstack keystone/glance/horizon/mysql
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::controller0 {

  contain dc_profile::openstack::keystone_mariadb
  contain dc_profile::openstack::glance_api_db
  contain dc_profile::openstack::glance_registry_db
  contain dc_profile::openstack::nova_db
  contain dc_profile::openstack::neutron_db
  contain dc_profile::openstack::cinder_db
  contain dc_profile::openstack::ceilometer_db

  contain dc_profile::openstack::keystone_memcached

  contain dc_profile::openstack::keystone
  contain dc_profile::openstack::glance
  contain dc_profile::openstack::horizon

  Class['dc_profile::openstack::keystone_mariadb'] ->
  Class['dc_profile::openstack::keystone_memcached'] ->
  Class['dc_profile::openstack::keystone']

  Class['dc_profile::openstack::glance_api_db'] ->
  Class['dc_profile::openstack::glance']

  Class['dc_profile::openstack::glance_registry_db'] ->
  Class['dc_profile::openstack::glance']

  service { ['ceilometer-collector', 'ceilometer-api', 'ceilometer-agent-central']:
    ensure    => stopped,
    hasstatus => true,
    enable    => false,
  }

}
