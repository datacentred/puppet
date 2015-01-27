# Class: dc_riemann::oslog_email_stream
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
class dc_riemann::oslog_email_stream {

  file { "${dc_riemann::riemann_config_dir}/oslog_email_stream.clj":
    ensure  => file,
    owner   => 'riemann',
    group   => 'riemann',
    content => template('dc_riemann/oslog_email_stream.clj.erb'),
    notify  => Service['riemann'],
  }

}

