# Class: dc_profile::log::logstash
#
# Basic class for installing Logstash and subsequent configuration
# for parsing events fed via rsyslog from other hosts.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logstash {

  class { 'dc_logstash': }

  @@dns_resource { "syslog.${::domain}/CNAME":
    rdata => $::fqdn,
  }

}
