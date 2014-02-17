# Class: dc_puppet::master::err::service
#
# Errbot service 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::err::service {

  service { 'err':
    ensure => running,
  }

}
