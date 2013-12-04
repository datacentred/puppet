# Basic class for installing LogStash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.

class dc_profile::logstash {

  class { '::logstash': 
    provider     => 'custom',
    java_install => true,
    # No packages provided so we just install the JAR, currently 'mirrored' onto mirror.sal01...
    jarfile      => 'http://mirror.sal01.datacentred.co.uk/misc/logstash/logstash-1.2.2-flatjar.jar',
  }

  # Setup the default Syslog collector
  ::logstash::input::syslog { 'logstash-syslog':
    type => 'syslog',
    port => 5544,
  }

  # Grok filter to parse entire syslog into various fields
  ::logstash::filter::grok { 'logstash-grok':
    type      => 'syslog',
    match     => { "message"       => '<%{POSINT:syslog_pri}>%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}' },
    add_field => { "received_at"   => '%{@timestamp}',
                   "received_from" => "%{@source_host}" },
  }

  # Syslog_pri filter which, by default, looks for priority field and parses it accordingly
  ::logstash::filter::syslog_pri { 'logstash-syslog_pri': }

  # Convert @timestamp field of Logstash syslog event with the time of the syslog message
  ::logstash::filter::date { 'logstash-date':
    match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ],
  }

  # Remove redundant fields
  ::logstash::filter::mutate { 'logstash-mutate':
   remove => [ "syslog_hostname", "syslog_message", "syslog_timestamp" ],
  }

  # Setup default embedded ElasticSearch instance
  ::logstash::output::elasticsearch { 'logstash-elasticsearch':
    embedded => true,
  }

}

