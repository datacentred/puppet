#
class dc_profile::rsyslog_client {

  class { 'dc_rsyslog':
    logstash_server => hiera(logstash_server),
    logstash_port   => 55514,
  }

}
