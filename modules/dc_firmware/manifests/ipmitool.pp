# Class: dc_firmware::ipmitool
#
# A class to wrap installing ipmitool as a virtual resource
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
class dc_firmware::ipmitool {
  package { 'ipmitool':
    ensure => installed,
  }
}