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

  ensure_packages(['ipmitool'])

  package { 'freeipmi-tools':
    ensure => installed,
  }

}
