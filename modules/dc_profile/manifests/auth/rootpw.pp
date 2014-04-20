# Class: dc_profile::auth::rootpw
#
# Disable the root password of the host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::rootpw {

  exec { 'usermod_root':
    command => '/usr/sbin/usermod -p \'!\' root'
  }

}
