# == Class: dc_logstash::server
#
# Installs logstash server
#
class dc_logstash::server (
  $grok_patterns_dir = $dc_logstash::params::grok_patterns_dir,
  $beats_plugin_version = $dc_logstash::params::beats_plugin_version,
  $beats_port = $dc_logstash::params::beats_port,
  $syslog_port = $dc_logstash::params::syslog_port,
  $elasticsearch_hosts = $dc_logstash::params::elasticsearch_hosts,
  $riemann_plugin_version = $dc_logstash::params::riemann_plugin_version,
) inherits dc_logstash::params {

  include ::java

  class { '::logstash':
    ensure            => 'present',
  }

  Class['java'] -> Class['logstash']

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
    group   => 'logstash',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/dc_logstash/grok',
    require => Class['::logstash'],
  }

  # Install the server side beats and riemann components
  include ::dc_logstash::server::beats
  include ::dc_logstash::server::riemann

  # Add config files
  include ::dc_logstash::server::config::input_beats
  include ::dc_logstash::server::config::input_syslog
  include ::dc_logstash::server::config::filter_grok_apache
  include ::dc_logstash::server::config::filter_grok_apache_err
  include ::dc_logstash::server::config::filter_grok_haproxy
  include ::dc_logstash::server::config::filter_grok_libvirt
  include ::dc_logstash::server::config::filter_grok_mongodb
  include ::dc_logstash::server::config::filter_grok_mysql_err
  include ::dc_logstash::server::config::filter_grok_native_syslog
  include ::dc_logstash::server::config::filter_grok_openstack
  include ::dc_logstash::server::config::filter_grok_syslog
  include ::dc_logstash::server::config::output_elasticsearch
  include ::dc_logstash::server::config::output_riemann

}
