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
    log_on_success          => 'PID HOST USERID EXIT DURATION TRAFFIC',
    log_on_failure          => 'USERID',
    disable                 => 'no',
    only_from               => $allowed_hosts,
  }

  concat { '/etc/nagios/nrpe.d/dc_nrpe_check.cfg':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nagios-nrpe-server'],
    notify  => Service['xinetd'],
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

  # Puppet checks

  package { 'python-yaml':
    ensure => installed,
  }

  contain dc_nrpe::common
  contain dc_nrpe::glance
  contain dc_nrpe::neutron
  contain dc_nrpe::nova_server
  contain dc_nrpe::logstash
  contain dc_nrpe::smartd

}
