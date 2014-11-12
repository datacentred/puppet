# == Class: dc_nrpe::smartd
#
class dc_nrpe::smartd {

  # TODO: This set of checks relies on nagios.  This must be cleaned!!
  dc_nrpe::check { 'check_dev_smart':
    path   => '/usr/lib/nagios/plugins/check_dev_smart',
    source => 'puppet:///modules/dc_nrpe/check_dev_smart',
    sudo   => true,
  }

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
      require => Package['nagios-nrpe-server', 'smartmontools'],
      notify  => Service['nagios-nrpe-server'],
    }
  }


  file { '/usr/lib/nagios/plugins/check_ide_smart':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_ide_smart',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server', 'smartmontools'],
    notify  => Service['nagios-nrpe-server'],
  }
}
