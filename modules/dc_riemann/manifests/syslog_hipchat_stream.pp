# Class: dc_riemann::hipchat_stream
#
# Defines a hipchat output stream
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# Event requires a string formatted correctly for riemann, see the template
#
# [Remember: No empty lines between comments and class definition]
define dc_riemann::syslog_hipchat_stream (
  $waittime       = 3600,
  $rollup         = 3,
  $whitelist      = undef,
  $event          = undef,
  $token          = undef,
  $room           = undef,
  $from           = undef,
  $hipchat_notify = 0,
){

  file { "${dc_riemann::riemann_config_dir}/${title}.clj":
    ensure  => file,
    owner   => 'riemann',
    group   => 'riemann',
    content => template('dc_riemann/syslog_hipchat_stream.clj.erb'),
    notify  => Service['riemann'],
  }
}

