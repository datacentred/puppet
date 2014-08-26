# Class: dc_nrpe::install
#
# Installs nagios nrpe server package and sets up the service
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
class dc_nrpe::install
{
  include dc_profile::net::xinetd

  package { 'nagios-nrpe-server':
    ensure  => installed,
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    before  => File['/etc/xinetd.d/nrpe'],
    path    => '/etc/nagios/nrpe.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/dc_nrpe/nrpe.cfg',
    notify  => Service['nagios-nrpe-server'],
  }

  service { 'nagios-nrpe-server':
    ensure  => stopped,
    require => Package['nagios-nrpe-server'],
    before  => File['/etc/xinetd.d/nrpe'],
    enable  => false,
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

  file { '/etc/nagios/nrpe.d/dc_common.cfg':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_nrpe/dc_common.cfg.erb'),
    notify  => Service['nagios-nrpe-server'],
  }
}
