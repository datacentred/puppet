# Class: dc_riemann::syslog_pagerduty_stream
#
# Defines a pagerduty output stream
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
# [Remember: No empty lines between comments and class definition]
class dc_riemann::syslog_pagerduty_stream {

  file { $dc_riemann::riemann_pagerduty_blacklist:
    ensure => file,
    owner  => 'riemann',
    group  => 'riemann',
    source => 'puppet:///modules/dc_riemann/riemann.pagerduty',
    notify => Service['riemann'],
  }

  file { "${dc_riemann::riemann_config_dir}/syslog_pagerduty_stream.clj":
    ensure  => file,
    owner   => 'riemann',
    group   => 'riemann',
    content => template('dc_riemann/syslog_pagerduty_stream.clj.erb'),
    notify  => Service['riemann'],
  }
}

