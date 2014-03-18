# Class: dc_profile::net::hosts
#
# Per host static host database management
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::hosts {

  host { $::hostname:
    ensure => absent,
    ip     => '127.0.1.1',
  }

}
