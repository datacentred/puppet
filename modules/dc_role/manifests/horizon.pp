# Class:
#
# Openstack dashboard role
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::horizon {

  contain dc_profile::openstack::repos
  contain dc_profile::openstack::horizon

  Class['dc_profile::openstack::repos'] ->
  Class['dc_profile::openstack::horizon']

}
