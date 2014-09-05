# Class: dc_nrpe::smartd
#
# smartd specific nrpe configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_nrpe::smartd {

  package {'smartmontools':
    ensure => installed
  }

  sudo::conf { 'check_dev_smart':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_dev_smart',
  }

  file { '/etc/nagios/nrpe.d/smartd.cfg':
    ensure  => present,
    content => 'command[check_dev_smart]=sudo /usr/lib/nagios/plugins/check_dev_smart',
    require => Package['nagios-nrpe-server', 'smartmontools'],
    notify  => Service['nagios-nrpe-server'],
  }

  if $::disks
  {
    file { '/etc/nagios/smart_devices':
      ensure  => present,
      content => $::disks,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server', 'smartmontools'],
      notify  => Service['nagios-nrpe-server'],
    }
  }

  file { '/usr/lib/nagios/plugins/check_dev_smart':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_dev_smart',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server', 'smartmontools'],
    notify  => Service['nagios-nrpe-server'],
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
