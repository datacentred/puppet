# Class: dc_logstash
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
class dc_logstash (
  $es_embedded,
){

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

  # Add directory and install patterns for filters and parsers
  $logstash_grok_patterns_dir = hiera(logstash_grok_patterns_dir)

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
  contain ::dc_logstash::courier

  # Add config files

  contain ::dc_logstash::config::input_courier
  contain ::dc_logstash::config::input_syslog
  contain ::dc_logstash::config::filter_grok_syslog
  if $::es_embedded == true {
    contain ::dc_logstash::config::output_elasticsearch
  }
  else {
    contain ::dc_logstash::config::output_elasticsearch_external
  }
  contain ::dc_logstash::config::output_riemann
  contain ::dc_logstash::config::output_riemann_dev
  contain ::dc_logstash::config::filter_grok_apache
  contain ::dc_logstash::config::filter_grok_apache_err
  contain ::dc_logstash::config::filter_grok_mysql_err
  contain ::dc_logstash::config::filter_grok_openstack
  contain ::dc_logstash::config::filter_grok_native_syslog

  # Add icinga config
  unless $::is_vagrant {
    contain ::dc_logstash::icinga
  }

}
