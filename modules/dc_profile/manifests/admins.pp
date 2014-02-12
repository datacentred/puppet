# Class to create accounts for system administrators
class dc_profile::admins {

    group { 'sysadmin':
        ensure => present,
        gid    => 1000,
    } ->
    dc_users { 'admins': }

}
