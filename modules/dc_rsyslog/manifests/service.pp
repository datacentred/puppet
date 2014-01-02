class dc_rsyslog::service {
  service { 'rsyslog':
    ensure => running,
    enable => true,
  }
}
