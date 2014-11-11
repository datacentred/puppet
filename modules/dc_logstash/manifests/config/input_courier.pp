# Class: dc_logstash::config::input_courier
#
# Server side configuration for log_courier input
#
class dc_logstash::config::input_courier {

  include dc_logstash::params

  logstash::configfile { 'input_courier':
    content => template('dc_logstash/input_courier.erb'),
    order   => '01',
  }
}
