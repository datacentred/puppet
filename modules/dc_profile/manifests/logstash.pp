# Basic class for installing Logstash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.

class dc_profile::logstash {

  class { '::logstash': 
    provider     => 'custom',
    java_install => true,
    # No packages provided so we just install the JAR, currently 'mirrored' onto mirror.sal01...
    jarfile      => 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar',
  }

  # UDP listener
  # This handles messages from rsyslog sent in formatted natively for Logstash's
  # consumption using JSON.
  logstash::input::udp { 'logstash-udp':
    format => 'json_event',
    port   => 55514,
    type   => 'rsyslog',
  }
 
  # Setup default embedded ElasticSearch instance
  logstash::output::elasticsearch { 'logstash-elasticsearch':
    embedded => true,
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_http']

}

