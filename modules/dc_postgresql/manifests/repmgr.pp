# Class: dc_postgresql::repmgr
#
# Install repmgr
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
class dc_postgresql::repmgr {

  package { 'repmgr':
    ensure => installed,
  }

  package { 'postgresql-9.3-repmgr':
    ensure => installed,
  }

}
