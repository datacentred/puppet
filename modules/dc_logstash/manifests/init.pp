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
  class { '::logstash':}

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

  # the package for logstash-contrib has broken dependencies currently
  # so hacky manual method for now
  exec { 'install-contrib':
    creates => '/opt/logstash/lib/logstash/outputs/riemann.rb',
    cwd     => '/opt/logstash',
    command => '/opt/logstash/bin/plugin install contrib',
    notify  => Service['logstash'],
  }

  # Add config files

  class { 'dc_logstash::config::input_syslog':}
  class { 'dc_logstash::config::input_forwarder':}
  class { 'dc_logstash::config::output_elasticsearch':}
  class { 'dc_logstash::config::output_riemann':}
  class { 'dc_logstash::config::filter_grok_apache':}
  class { 'dc_logstash::config::filter_grok_apache_err':}
  class { 'dc_logstash::config::filter_grok_mysql_err':}

  # Add icinga config
  class { 'dc_logstash::icinga': }

}
