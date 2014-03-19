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

# Basic class for installing Logstash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.

  class { '::logstash':
    provider     => 'custom',
    java_install => true,
    # No packages provided so we just install the JAR, currently 'mirrored' onto mirror.sal01...
    jarfile      => 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar',
  }

  # UDP listener
  # Syslog listener
  logstash::input::syslog { 'logstash-syslog':
    type => 'syslog',
    port => hiera(logstash_syslog_port),
  }

  # Logstash forwarder support
  logstash::input::lumberjack { 'logstash-forwarder':
    port            => hiera(logstash_forwarder_port),
    type            => 'lumberjack',
    ssl_key         => '/etc/ssl/private/logstash-forwarder.key',
    ssl_certificate => '/etc/ssl/certs/logstash-forwarder.crt',
  }

  file { '/etc/ssl/private/logstash-forwarder.key':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/dc_logstash/logstash-forwarder.key',
  }

  # Filters and parsers
  file { '/etc/logstash/agent/grok':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/dc_logstash/grok',
    require => Class['::logstash'],
  }

  logstash::filter::grok { 'apache-log':
    type    => 'apache',
    pattern => [ '%{COMBINEDAPACHELOG}' ],
  }

  logstash::filter::grok { 'apache-error-log':
    type         => 'apache_error',
    patterns_dir => [ '/etc/logstash/agent/grok' ],
    pattern      => [ '%{APACHEERRORLOG}' ],
  }

  logstash::filter::grok { 'mysql-error-log':
    type         => 'mysql_error',
    patterns_dir => [ '/etc/logstash/agent/grok' ],
    pattern      => [ '%{MYSQLERROR}' ],
  }

  # Munge incoming syslogs to set host to hostname and not ip
  # Need the ip-address-add to run first

  logstash::filter::mutate { 'ip-address-add':
    type      => 'syslog',
    add_field => { ipaddress => '%{host}', },
    order     => 9,
  }

  logstash::filter::mutate { 'set-hostname':
    type    => 'syslog',
    replace => { host    => '%{logsource}', },
    order   => 10,
  }

  # Setup default embedded ElasticSearch instance
  logstash::output::elasticsearch { 'logstash-elasticsearch':
    embedded => true,
  }

  # Setup syslog output to riemann
  logstash::output::riemann { 'logstash-riemann':
    type              => 'syslog',
    riemann_event     => {
          state       => '%{syslog_severity_code}',
          service     => '%{program}',
          description => '%{message}',
    },
  }

  class { 'dc_logstash::icinga': }

}
