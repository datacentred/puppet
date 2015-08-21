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

  include ::dc_logstash::server

  include ::dc_icinga::hostgroup_http
  include ::dc_icinga::hostgroup_logstashes

}
