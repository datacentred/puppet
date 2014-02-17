# Basic class for installing Logstash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.
class dc_profile::logstash {

  class { 'dc_logstash': }

}

