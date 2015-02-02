# Class: dc_ipmi::install
#
# Ensures that ipmitool and utils are installed
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
class dc_ipmi::install {

  package { 'ipmitool':
    ensure => installed,
  }

  package { 'freeipmi-utils':
    ensure => installed,
  }

}
