# Class: dc_profile::dell::openmanage
#
# Class to install Dell's OpenManage System Administrator
# so that status information from drives on dell percs can be read
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::dell::openmanage {

  package { 'srvadmin-all':
    ensure  => installed,
  }

  service { 'dataeng':
    ensure  => true,
    enable  => true,
    require => Package['srvadmin-all'],
  }
}