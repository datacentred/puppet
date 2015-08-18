# Class: dc_logstash::server::config::input_beaver
#
# Server side configuration for beaver tcp input
#
class dc_logstash::server::config::input_beaver {

  include ::dc_logstash::server

  $beaver_port = $dc_logstash::server::beaver_port

  logstash::configfile { 'input_beavertcp':
    content => template('dc_logstash/server/input_beavertcp.erb'),
    order   => '01',
  }

}
