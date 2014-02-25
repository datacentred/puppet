# Class: dc_profile::auth::sudoers
#
# Grant sudo rights to users
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::sudoers {

  contain sudo

  sudo::conf { '%sysadmin':
    priority => 10,
    content  => '%sysadmin ALL=(ALL) NOPASSWD: ALL',
  }

}
