# Class: dc_logstash::config::input_syslog_forwarder
#
# Server side configuration for syslog input via forwarder
#
class dc_logstash::config::input_syslog_forwarder {

  logstash::configfile { 'input_syslog_forwarder':
    content => template('dc_logstash/input_syslog_forwarder.erb'),
    order   => '10',
  }

}
