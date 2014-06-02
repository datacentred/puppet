# Class: dc_profile::openstack::cinder_nagios
#
# Nagios config for Cinder node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder_nagios {

  file { '/etc/nagios/nrpe.d/cinder_scheduler.cfg':
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

  include dc_icinga::hostgroup_cinder

}
