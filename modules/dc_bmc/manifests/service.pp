# Class: dc_bmc::service
#
# Configures ipmievd
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_bmc::service {

  file { '/etc/default/ipmievd':
    ensure  => file,
    source  => 'puppet:///modules/dc_bmc/ipmievd.default',
    require => Package['freeipmi-tools'],
  }

  service { 'ipmievd':
    ensure    => running,
    subscribe => File['/etc/default/ipmievd'],
  }

}
