class dc_profile::xinetd {

  package { 'xinetd':
    ensure => installed,
  }

  service { 'xinetd':
    ensure  => running,
    require => Package['xinetd'],
    enable  => true,
  }

}
