# Class: dc_logstash::server
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
class dc_logstash::server (
  $logstash_grok_patterns_dir = $dc_logstash::params::logstash_grok_patterns_dir,
  $logcourier_version         = $dc_logstash::params::logcourier_version,
  $logcourier_port            = $dc_logstash::params::logcourier_port,
  $logstash_cert_alias        = $dc_logstash::params::logstash_cert_alias,
  $logstash_syslog_port       = $dc_logstash::params::logstash_syslog_port,
  $elasticsearch_host         = $dc_logstash::params::elasticsearch_host,
  $elasticsearch_embedded     = $dc_logstash::params::elasticsearch_embedded,
  $elasticsearch_protocol     = $dc_logstash::params::elasticsearch_protocol,
  $riemann_dev_host           = $dc_logstash::params::riemann_dev_host,
) inherits dc_logstash::params {

  # Basic class for installing Logstash
  class { '::logstash':
    init_defaults_file => 'puppet:///modules/dc_logstash/logstash_default',
  }

  # Patch the module's init script in order for us to be able to read Puppet's
  # SSL certs.
  exec { 'logstash patch upstart':
    command => '/bin/sed -ie "s/LS_GROUP=logstash/LS_GROUP=puppet/" /etc/init.d/logstash',
    onlyif  => '/bin/grep "LS_GROUP=logstash" /etc/init.d/logstash',
    require => Package['logstash'],
    notify  => Service['logstash'],
  }

  # Stop logstash web from starting
  file { '/etc/init/logstash-web.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dc_logstash/logstash_web_init',
    require => Package['logstash'],
  }
  ->
  service {'logstash-web':
    ensure => stopped,
    enable => false,
  }

  file { $logstash_grok_patterns_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/dc_logstash/grok',
    require => Class['::logstash'],
  }

  package { 'logstash-contrib':
    ensure => installed,
  }

  # Install the server side log-courier components
  contain ::dc_logstash::server::courier

  # Add config files

  contain ::dc_logstash::server::config::input_courier
  contain ::dc_logstash::server::config::input_syslog
  contain ::dc_logstash::server::config::filter_grok_syslog
  contain ::dc_logstash::server::config::output_elasticsearch
  contain ::dc_logstash::server::config::output_riemann
  contain ::dc_logstash::server::config::output_riemann_dev
  contain ::dc_logstash::server::config::filter_grok_apache
  contain ::dc_logstash::server::config::filter_grok_apache_err
  contain ::dc_logstash::server::config::filter_grok_mysql_err
  contain ::dc_logstash::server::config::filter_grok_openstack
  contain ::dc_logstash::server::config::filter_grok_native_syslog

  # Add icinga config
  unless $::is_vagrant {
    if dc_logstash::params::elasticsearch_embedded {
      contain ::dc_logstash::server::icinga
    }
  }

}
