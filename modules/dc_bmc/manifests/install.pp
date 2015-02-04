# Class: dc_bmc::install
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
class dc_bmc::install {

  package { 'ipmitool':
    ensure => installed,
  }

  package { 'freeipmi-tools':
    ensure => installed,
  }

}
