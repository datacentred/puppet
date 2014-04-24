# Class: dc_logstash::config::input_forwarder
#
# Server side configuration for forwarder input
#
class dc_logstash::config::input_forwarder {

  logstash::configfile { 'input_forwarder':
    content => template('dc_logstash/input_forwarder.erb'),
    order   => '11',
  }
}
