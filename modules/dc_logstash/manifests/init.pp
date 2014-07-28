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
class dc_logstash {

  # Basic class for installing Logstash
  class { '::logstash': }

  # Patch the module's init script in order for us to be able to read Puppet's
  # SSL certs.
  exec { 'logstash patch upstart':
    command => '/bin/sed -ie "s/LS_GROUP=logstash/LS_GROUP=puppet/" /etc/init.d/logstash',
    onlyif  => '/bin/grep "LS_GROUP=logstash" /etc/init.d/logstash',
    require => [ Package['logstash'], Package['puppet'] ],
    notify  => Service['logstash'],
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

  # Add config files

  class { 'dc_logstash::config::input_forwarder':}
  class { 'dc_logstash::config::input_syslog':}
  class { 'dc_logstash::config::filter_grok_syslog':}
  class { 'dc_logstash::config::output_elasticsearch':}
  class { 'dc_logstash::config::output_riemann':}
  class { 'dc_logstash::config::output_riemann_dev':}
  class { 'dc_logstash::config::filter_grok_apache':}
  class { 'dc_logstash::config::filter_grok_apache_err':}
  class { 'dc_logstash::config::filter_grok_mysql_err':}
  class { 'dc_logstash::config::filter_grok_openstack':}
  class { 'dc_logstash::config::filter_grok_native_syslog':}

  # Add icinga config
  unless $::is_vagrant {
    class { 'dc_logstash::icinga': }
  }

}
