class dc_profile::admins {

include dc_users::userlist

    group { 'sysadmin':
        ensure => present,
        gid    => 1000,
    }

    Dc_users::Virtual::Account <| gid == '1000' |>
}

