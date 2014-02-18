# Class:
#
# Openstack image service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::glance {

  contain dc_profile::openstack::repos
  contain dc_profile::openstack::glance

  Class['dc_profile::openstack::repos'] ->
  Class['dc_profile::openstack::glance']

}
