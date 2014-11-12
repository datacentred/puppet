# Class: dc_logstash::server::config::filter_grok_native_syslog
#
# Server side configuration for native syslog input
#
class dc_logstash::server::config::filter_grok_native_syslog {

  logstash::configfile { 'filter_grok_native_syslog':
    source => 'puppet:///modules/dc_logstash/filter_grok_native_syslog',
    order  => '10',
  }

}
