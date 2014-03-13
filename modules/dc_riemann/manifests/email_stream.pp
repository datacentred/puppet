# Class: dc_riemann::email_stream
#
# Defines an email output stream
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
define dc_riemann::email_stream (
  $fromaddress = "riemann@${::fqdn}",
  $waittime    = 3600,
  $rollup      = 3,
  $event       = undef,
){
  file { "/etc/${dc_riemann::riemann_config_dir}/${title}.clj":
    ensure  => file,
    owner   => 'riemann',
    group   => 'riemann',
    content => template('email_stream.clj')
  }
}

