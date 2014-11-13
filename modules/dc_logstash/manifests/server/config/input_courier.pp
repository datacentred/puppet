# Class: dc_logstash::server::config::input_courier
#
# Server side configuration for log_courier input
#
class dc_logstash::server::config::input_courier inherits dc_logstash::server {

  logstash::configfile { 'input_courier':
    content => template('dc_logstash/server/input_courier.erb'),
    order   => '01',
  }
}
