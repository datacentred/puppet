# Class: dc_puppet::master::hipbot::service
#
# Hipbot service 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot::service {

  service { 'hipbot':
    ensure => running,
  }

}
