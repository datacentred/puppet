# Class: dc_role::platformservices_keystone
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
class dc_role::platformservices_keystone{

  contain dc_profile::openstack::keystone_mariadb
  contain dc_profile::openstack::keystone

  Class['dc_profile::openstack::keystone_mariadb'] ->
  Class['dc_profile::openstack::keystone']

}
