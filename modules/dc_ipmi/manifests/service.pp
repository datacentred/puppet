# Class: dc_ipmi::service
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
class dc_ipmi::service {

  file { '/etc/default/ipmievd':
    ensure   => file,
    contents => "ENABLED=true\n",
    requires => Package['freeipmi-utils'],
  }

  service { 'ipmievd':
    ensure   => running,
    requires => File['/etc/default/ipmievd'],
  }

}
