# Class:
#
# Openstack compute controller
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::nova {

  contain dc_profile::openstack::repos
  contain dc_profile::openstack::nova

  Class['dc_profile::openstack::repos'] ->
  Class['dc_profile::openstack::nova']
  
}
