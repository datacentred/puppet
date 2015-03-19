# == Class: dc_sysdig
#
class dc_sysdig {

  package { 'sysdig':
    ensure => installed,
  }

}
