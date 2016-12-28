# Class: dc_profile::util::cpu_performance
#
# Sets the CPU governor to 'performance'
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

  runonce { 'cpufrequtils':
    command =>  'service cpufrequtils start',
    require => [ File['/etc/default/cpufrequtils'], Package['cpufrequtils'] ],
  }

  service { 'ondemand':
    ensure => stopped,
  }

}
