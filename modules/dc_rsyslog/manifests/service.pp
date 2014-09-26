# == Class: dc_rsyslog::service
#
class dc_rsyslog::service {
  service { 'rsyslog':
    ensure => running,
    enable => true,
  }
}
