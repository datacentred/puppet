# Class: dc_role::keystone
#
# Openstack Keystone
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::keystone {

  contain dc_profile::openstack::keystone_mariadb
  contain dc_profile::openstack::keystone

  Class['dc_profile::openstack::keystone_mariadb'] ->
  Class['dc_profile::openstack::keystone']

}
