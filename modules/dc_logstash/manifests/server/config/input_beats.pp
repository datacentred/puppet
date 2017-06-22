# Class: dc_logstash::server::config::input_beats
#
# Server side configuration for beats input
#
class dc_logstash::server::config::input_beats {

  include ::dc_logstash::server

  $port = $dc_logstash::server::beats_port

  logstash::configfile { 'input_beats':
    content => template('dc_logstash/server/input_beats.erb'),
  }
}
