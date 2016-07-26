# == Class: dc_bmc::debian::service
#
# Ensures ipmievd is running
#
class dc_bmc::debian::service {

  service { 'ipmievd':
    ensure => running,
  }

}
