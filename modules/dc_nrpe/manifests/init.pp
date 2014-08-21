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
){

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

  # Puppet checks

  package { 'python-yaml':
    ensure => installed,
  }

  file { '/usr/lib/nagios/plugins/check_puppetagent':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dc_nrpe/check_puppetagent',
  }

  sudo::conf { 'check_puppetagent':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_puppetagent',
  }

  contain dc_nrpe::cinder
  contain dc_nrpe::glance
  contain dc_nrpe::neutron
  contain dc_nrpe::nova_compute
  contain dc_nrpe::nova_server
  contain dc_nrpe::logstash
  contain dc_nrpe::smartd
  contain dc_nrpe::ceph

}
