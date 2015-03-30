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

  user { 'root':
    password => '!',
  }

}
