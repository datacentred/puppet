# Class: dc_logstash::config::input_syslog_forwarder
#
# Server side configuration for syslog input via forwarder
#
class dc_logstash::config::input_syslog_forwarder {

  logstash::configfile { 'input_syslog_forwarder':
    source => 'puppet:///modules/dc_logstash/input_syslog_forwarder',
    order  => '10',
  }

}
