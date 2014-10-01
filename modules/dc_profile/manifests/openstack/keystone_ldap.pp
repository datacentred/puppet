# Class: dc_profile::openstack::keystone_ldap
#
# Provision the OpenStack Keystone component
#
# With LDAP as the backend
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::keystone_ldap {
  contain ::keystone::ldap
}
