# Class: dc_profile::log::rsyslog_client
#
# Installs a backend to route syslog calls to logstash
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::rsyslog_client {

  class { 'dc_rsyslog':
    logstash_server => hiera(logstash_server),
    logstash_port   => hiera(logstash_syslog_port),
  }

}
