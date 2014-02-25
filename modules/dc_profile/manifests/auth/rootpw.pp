# Class: dc_profile::auth::rootpw
#
# Set the root password of the host
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

  $rpass = hiera(rpass)

  user { 'root':
    ensure   => present,
    password => $rpass,
  }

}
