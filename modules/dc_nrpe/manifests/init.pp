# Class: dc_nrpe
#
# Installs and configures nagios nrpe server
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
# FIXME add sudo support, add ability to add options
class dc_nrpe (
  $allowed_hosts = '127.0.0.1',
  $ensure_nagios = stopped,
  $nrpe_commands = [],
){

  include dc_profile::xinetd

  package { 'nagios-nrpe-server':
    ensure  => installed,
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    path    => '/etc/nagios/nrpe.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_nrpe/nrpe.cfg.erb'),
  }

  service { 'nagios-nrpe-server':
    ensure  => stopped,
    require => Package['nagios-nrpe-server'],
    enable  => false,
  }

  # SM: Annoyingly nagios-nrpe-plugin auto suggests the full
  # nagios stack so avoid starting it up and interfering
  service { 'nagios3':
    ensure => $ensure_nagios,
  }

  file { '/etc/xinetd.d/nrpe':
    ensure  => file,
    require => Package['xinetd'],
    path    => '/etc/xinetd.d/nrpe',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_nrpe/nrpe.xinetd.erb'),
    notify  => Service['xinetd'],
  }
}
