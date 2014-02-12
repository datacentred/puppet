#
class dc_puppet::master::service {
  service { $dc_puppet::params::master_service:
    ensure => running,
  }
}
