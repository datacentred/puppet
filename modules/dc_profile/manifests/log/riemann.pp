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

  dc_riemann::syslog_email_stream { 'syslog-errors':
    event     => '(or (state "2")(state "1")(state "0"))',
    whitelist => '/etc/riemann.conf.d/riemann.whitelist',
    require   => Class['dc_riemann'],
  }

  $token = hiera(riemann_hipchat_auth_token)
  $room  = 'Monitoring'
  $from  = 'Riemann'

  dc_riemann::syslog_hipchat_stream { 'syslog-hipchat':
    event     => '(or (state "4")(state "3")(state "2")(state "1")(state "0"))',
    whitelist => '/etc/riemann.conf.d/riemann.whitelist',
    token     => $token,
    room      => $room,
    from      => $from,
    require   => Class['dc_riemann'],
  }

}
