# Class: dc_logstash::server::config::input_beats
#
# Server side configuration for beats input
#
class dc_logstash::server::config::input_beats {

  include ::dc_logstash::server

  $port = $dc_logstash::server::beats_port
  $key = $dc_logstash::server::beats_key
  $cert = $dc_logstash::server::beats_cert
  $cacert = $dc_logstash::server::beats_cacert

  logstash::configfile { 'input_beats':
    content => template('dc_logstash/server/input_beats.erb'),
  }
}
