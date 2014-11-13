# == Class: dc_nrpe::smartd
#
class dc_nrpe::smartd {

  package {'smartmontools':
    ensure => installed
  }

  if $::disks
  {
    file { '/etc/nagios/smart_devices':
      ensure  => file,
      content => $::disks,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }

  file { '/usr/local/bin/check_ide_smart':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_ide_smart',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  dc_nrpe::check { 'check_dev_smart':
    path   => '/usr/local/bin/check_dev_smart',
    source => 'puppet:///modules/dc_nrpe/check_dev_smart',
    sudo   => true,
  }

}
