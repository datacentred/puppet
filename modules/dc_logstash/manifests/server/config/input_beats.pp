# Class: dc_logstash::server::config::input_beats
#
# Server side configuration for beats input
#
class dc_logstash::server::config::input_beats {

  include ::dc_logstash::server

  logstash::configfile { 'input_beats':
    content => template('dc_logstash/server/input_beats.erb'),
  }
}
