# Class: dc_apparmor
#
# Configure apparmor
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
class dc_apparmor {

  service { 'apparmor':
    ensure => running
  }

  package { 'apparmor':
    ensure => installed,
  }

}
