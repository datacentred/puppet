# Class: dc_profile::openstack::keystone_dcadmins
#
# Sets up admin accounts from Hiera in Keystone, assigns them the
# admin role, and sets the default tenant to 'admin'.
#
# Parameters: $title - name of account to be created
#             $hash - hash of values keyed on username and including
#                     password
#
# Actions:
#
# Requires: puppet-keystone
#
# Sample Usage:
# dc_profile::openstack::keystone_dcadmins { 'username':
#   hash => hiera(admins),
# }
#
define dc_profile::openstack::keystone_dcadmins (
  $hash = undef,
  $tenant = 'openstack',
) {

  keystone_user { $title:
    ensure   => present,
    enabled  => true,
    password => $hash[$title]['pass'],
    tenant   => $tenant,
  }
  keystone_user_role { "${title}@${tenant}":
    ensure => present,
    roles  => admin,
  }

}
