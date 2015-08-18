# == Class: dc_logstash::server
#
# Installs logstash server
#
class dc_logstash::server (
  $grok_patterns_dir = $dc_logstash::params::grok_patterns_dir,
  $logcourier_version = $dc_logstash::params::logcourier_version,
  $logcourier_port = $dc_logstash::params::logcourier_port,
  $logcourier_key = $dc_logstash::params::logcourier_key,
  $logcourier_cert = $dc_logstash::params::logcourier_cert,
  $logcourier_cacert = $dc_logstash::params::logcourier_cacert,
  $beaver_port = $dc_logstash::params::beaver_port,
  $syslog_port = $dc_logstash::params::syslog_port,
  $elasticsearch_host = $dc_logstash::params::elasticsearch_host,
  $elasticsearch_embedded = $dc_logstash::params::elasticsearch_embedded,
  $elasticsearch_protocol = $dc_logstash::params::elasticsearch_protocol,
) inherits dc_logstash::params {

  include ::logstash

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

  file { $grok_patterns_dir:
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
  include ::dc_logstash::server::courier

  # Add config files
  include ::dc_logstash::server::config::input_beaver
  include ::dc_logstash::server::config::input_log_courier
  include ::dc_logstash::server::config::input_syslog
  include ::dc_logstash::server::config::filter_grok_apache
  include ::dc_logstash::server::config::filter_grok_apache_err
  include ::dc_logstash::server::config::filter_grok_libvirt
  include ::dc_logstash::server::config::filter_grok_mongodb
  include ::dc_logstash::server::config::filter_grok_mysql_err
  include ::dc_logstash::server::config::filter_grok_native_syslog
  include ::dc_logstash::server::config::filter_grok_openstack
  include ::dc_logstash::server::config::filter_grok_syslog
  include ::dc_logstash::server::config::output_elasticsearch
  include ::dc_logstash::server::config::output_riemann

}
