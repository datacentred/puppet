# Class: dc_puppet::master::service
#
# Puppet master service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::service {

  service { $dc_puppet::params::master_service:
    ensure => running,
  }

}
