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

  $sys_uid_min = '100'
  $sys_uid_max = '999'
  $sys_gid_min = '100'
  $sys_gid_max = '999'

  $login_defs  = '/etc/login.defs'

  file_line { 'sys_uid_min':
    path  => $login_defs,
    line  => "SYS_UID_MIN               ${sys_uid_min}",
    match => '#SYS_UID_MIN',
  }

  file_line { 'sys_uid_max':
    path  => $login_defs,
    line  => "SYS_UID_MAX               ${sys_uid_max}",
    match => '#SYS_UID_MAX',
  }

  file_line { 'sys_gid_min':
    path  => $login_defs,
    line  => "SYS_GID_MIN               ${sys_gid_min}",
    match => '#SYS_GID_MIN',
  }

  file_line { 'sys_dig_max':
    path  => $login_defs,
    line  => "SYS_GID_MAX               ${sys_gid_max}",
    match => '#SYS_GID_MAX',
  }

  group { 'sysadmin':
    ensure => present,
    gid    => 1000,
  }

  dc_users { 'admins': }

}
