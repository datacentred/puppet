# Class: dc_profile::util::cpu_performance
#
# Sets the cpu governor to 'performance' 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::cpu_performance {

  ensure_packages('cpufrequtils')

  file { '/etc/default/cpufrequtils':
    content => 'GOVERNOR="performance"',
  }

  service { 'cpufrequtils':
    ensure  => running,
    require => File['/etc/default/cpufrequtils'],
  }

  service { 'ondemand':
    ensure => stopped,
  }

  File['/etc/default/cpufrequtils'] ~> Service['cpufrequtils']

}
