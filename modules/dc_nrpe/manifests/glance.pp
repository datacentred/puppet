# Class: dc_nrpe::glance
#
# Glance specific nrpe configuration
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
class dc_nrpe::glance {

  file { '/etc/nagios/nrpe.d/glance_registry_netstat.cfg':
    ensure  => present,
    content => 'command[check_glance_registry_netstat]=sudo /usr/lib/nagios/plugins/check_glance-registry.sh',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  sudo::conf { 'check_glance_registry_netstat':
    priority    => 10,
    content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_glance-registry.sh',
  }

  file { '/etc/nagios/nrpe.d/glance_api_proc.cfg':
    ensure  => present,
    content => 'command[check_glance_api_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -u glance -a glance-api',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/glance_registry_proc.cfg':
    ensure  => present,
    content => 'command[check_glance_registry_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -u glance -a glance-registry',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/usr/lib/nagios/plugins/check_glance-registry.sh':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_glance-registry.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
