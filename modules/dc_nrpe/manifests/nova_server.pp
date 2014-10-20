# Class: dc_nrpe::nova_server
#
# Nova specific nrpe configuration
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
class dc_nrpe::nova_server {

  sudo::conf { 'check_nova_scheduler_netstat':
    priority    => 10,
    content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_nova-scheduler.sh',
  }

  sudo::conf { 'check_nova_conductor_netstat':
    priority    => 10,
    content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_nova-conductor.sh',
  }

  sudo::conf { 'check_nova_consoleauth_netstat':
    priority    => 10,
    content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_nova-consoleauth.sh',
  }

  file { '/etc/nagios/nrpe.d/nova_scheduler_netstat.cfg':
    ensure  => present,
    content => 'command[check_nova_scheduler_netstat]=sudo /usr/lib/nagios/plugins/check_nova-scheduler.sh',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_conductor_netstat.cfg':
    ensure  => present,
    content => 'command[check_nova_conductor_netstat]=sudo /usr/lib/nagios/plugins/check_nova-conductor.sh',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_consoleauth_netstat.cfg':
    ensure  => present,
    content => 'command[check_nova_consoleauth_netstat]=sudo /usr/lib/nagios/plugins/check_nova-consoleauth.sh',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/usr/lib/nagios/plugins/check_nova-scheduler.sh':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_nova-scheduler.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/usr/lib/nagios/plugins/check_nova-conductor.sh':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_nova-conductor.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server'],
  }

  file { '/usr/lib/nagios/plugins/check_nova-consoleauth.sh':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_nova-consoleauth.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_conductor.cfg':
    ensure  => present,
    content => 'command[check_nova_conductor]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-conductor',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_scheduler.cfg':
    ensure  => present,
    content => 'command[check_nova_scheduler]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-scheduler',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_consoleauth.cfg':
    ensure  => present,
    content => 'command[check_nova_consoleauth]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-consoleauth',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
    }

  file { '/etc/nagios/nrpe.d/nova_cert.cfg':
    ensure  => present,
    content => 'command[check_nova_cert]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-cert',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nova_vncproxy.cfg':
    ensure  => present,
    content => 'command[check_nova_vncproxy]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-novncproxy',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
