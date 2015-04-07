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

  package { 'apparmor':
    ensure => installed,
  } ~>

  # Note: there is a bug in the dpkg puppet provider whereby you need
  #       to use another provider type to override the default status
  #       command as we do here to be forward compatible with 14.10+
  service { 'apparmor':
    ensure   => running,
    provider => 'base',
    start    => 'service apparmor start',
    stop     => 'service apparmor stop',
    status   => 'apparmor_status',
  }

}
