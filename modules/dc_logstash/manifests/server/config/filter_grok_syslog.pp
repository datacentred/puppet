# Class: dc_logstash::server::config::filter_grok_syslog
#
# Server side configuration for syslog input via forwarder
#
class dc_logstash::server::config::filter_grok_syslog {

  logstash::configfile { 'filter_grok_syslog':
    source => 'puppet:///modules/dc_logstash/filter_grok_syslog',
    order  => '10',
  }

}
