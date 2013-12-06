# Basic class for installing Logstash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.

class dc_profile::logstash {

  class { '::logstash': 
    provider     => 'custom',
    java_install => true,
    # No packages provided so we just install the JAR, currently 'mirrored' onto mirror.sal01...
    jarfile      => 'http://mirror.sal01.datacentred.co.uk/misc/logstash/logstash-1.2.2-flatjar.jar',
  }

  # Setup a syslog collector for JSON-formatted structured messages
  logstash::input::syslog { 'logstash-syslog':
    debug  => true,
    type   => 'syslog',
    port   => 55514,
    format => 'json_event',
  }
 
  # Setup default embedded ElasticSearch instance
  logstash::output::elasticsearch { 'logstash-elasticsearch':
    embedded => true,
  }

}

