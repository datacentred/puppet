# Class: dc_openvas::service
#
# Configures openvas services
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
class dc_openvas::service {

  service { 'openvas-scanner':
    ensure => running,
  }

  service { 'openvas-manager':
    ensure => running,
  }

  service { 'openvas-gsa':
    ensure => running,
  }

}

