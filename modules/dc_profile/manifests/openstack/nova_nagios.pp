# Class: dc_profile::openstack::nova_nagios
#
# Nagios config for Nova controller node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_nagios {

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

  include dc_icinga::hostgroup_nova_server

}
