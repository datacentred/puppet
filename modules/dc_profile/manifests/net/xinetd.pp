# Class: dc_profile::net::xinetd
#
# Installs the extended internet daemon
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::xinetd {

  package { 'xinetd':
    ensure => installed,
  }

  service { 'xinetd':
    ensure  => running,
    require => Package['xinetd'],
    enable  => true,
  }

}
