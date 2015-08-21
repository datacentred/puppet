# Class: dc_logstash::server::config::input_log_courier
#
# Server side configuration for log_courier input
#
class dc_logstash::server::config::input_log_courier {

  include ::dc_logstash::server

  $port = $dc_logstash::server::logcourier_port
  $key = $dc_logstash::server::logcourier_key
  $cert = $dc_logstash::server::logcourier_cert
  $cacert = $dc_logstash::server::logcourier_cacert

  logstash::configfile { 'input_courier':
    content => template('dc_logstash/server/input_courier.erb'),
    order   => '01',
  }
}
