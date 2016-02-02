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

  service { 'ipmievd':
    ensure => running,
  }

}
