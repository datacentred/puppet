# Class: dc_profile::net::lldp
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::lldp {

  include ::lldp

  file { '/etc/default/lldpd':
    content => "DAEMON_ARGS=\"-I eth*,p1*,p2*,em*\"\n",
    notify  => Service['lldpd'],
  }

}
