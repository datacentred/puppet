# Class: dc_profile::log::riemann
#
# Installs riemann and a basic email output stream
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::riemann{

  class { 'dc_riemann': }

  dc_riemann::email_stream { 'syslog-errors':
    event   => '(or (state "3")(state "2")(state "1")',
    require => Class['dc_riemann'],
  }

}
