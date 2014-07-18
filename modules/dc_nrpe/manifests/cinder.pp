# Class: dc_nrpe::cinder
#
# Cinder specific nrpe configuration
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
class dc_nrpe::cinder {

  if defined(Class['dc_icinga::hostgroup_cinder']) {

    sudo::conf { 'check_cinder_scheduler_netstat':
      priority      => 10,
      content => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_cinder_scheduler.sh',
    }

    file { '/etc/nagios/nrpe.d/cinder_scheduler_proc.cfg':
      ensure  => present,
      content => 'command[check_cinder_scheduler_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u cinder -a cinder-scheduler',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/cinder_volume.cfg':
      ensure  => present,
      content => 'command[check_cinder_volume_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u cinder -a cinder-volume',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/cinder_api.cfg':
      ensure  => present,
      content => 'command[check_cinder_api_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u cinder -a cinder-api',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/cinder_scheduler_netstat.cfg':
      ensure  => present,
      content => 'command[check_cinder_scheduler_netstat]=sudo /usr/lib/nagios/plugins/check_cinder-scheduler.sh',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/etc/nagios/nrpe.d/cinder_volume_netstat.cfg':
      ensure  => present,
      content => 'command[check_cinder_volume_netstat]=/usr/lib/nagios/plugins/check_cinder-volume.sh',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/usr/lib/nagios/plugins/check_cinder-volume.sh':
      ensure  => file,
      source  => 'puppet:///modules/dc_nrpe/check_cinder-volume.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/usr/lib/nagios/plugins/check_cinder-scheduler.sh':
      ensure  => file,
      source  => 'puppet:///modules/dc_nrpe/check_cinder-scheduler.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }
}
