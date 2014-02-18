# Class: dc_profile::auth::admins
#
# Class to create accounts for system administrators
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::admins {

    group { 'sysadmin':
        ensure => present,
        gid    => 1000,
    } ->
    dc_users { 'admins': }

}
