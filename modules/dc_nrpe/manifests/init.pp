# Class: dc_nrpe
#
# Installs and configures nagios nrpe server
#
# Parameters:
#
# Actions:
#
# Requires: puppetlabs-xinetd
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
# FIXME add sudo support, add ability to add options
class dc_nrpe (
  $allowed_hosts = '127.0.0.1',
  $ensure_nagios = stopped,
){

  package { 'nagios-nrpe-server':
    ensure  => installed,
  }

  service { 'nagios-nrpe-server':
    ensure  => stopped,
    require => Package['nagios-nrpe-server'],
    enable  => false,
  }

  xinetd::service { 'nrpe':
    server                  => '/usr/sbin/nrpe',
    port                    => '5666',
    flags                   => 'REUSE',
    service_type            => 'UNLISTED',
    socket_type             => 'stream',
    wait                    => 'no',
    user                    => 'nagios',
    group                   => 'nagios',
    server_args             => '-c /etc/nagios/nrpe.cfg --inetd',
    log_on_success_operator => '-=',
    log_on_success          => 'PID, HOST, USERID, EXIT, DURATION, TRAFFIC',
    log_on_failure          => 'USERID',
    disable                 => 'no',
    only_from               => $allowed_hosts,
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    path    => '/etc/nagios/nrpe.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/dc_nrpe/nrpe.cfg',
    notify  => Service['xinetd'],
  }

  file { '/etc/nagios/nrpe.d/dc_common.cfg':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_nrpe/dc_common.cfg.erb'),
    notify  => Service['xinetd'],
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
