# Class: dc_riemann::syslog_slack_stream
#
# Defines a slack output stream
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
class dc_riemann::syslog_slack_stream {

  file { "${dc_riemann::riemann_config_dir}/syslog_slack_stream.clj":
    ensure  => file,
    owner   => 'riemann',
    group   => 'riemann',
    content => template('dc_riemann/syslog_slack_stream.clj.erb'),
    notify  => Service['riemann'],
  }

}

