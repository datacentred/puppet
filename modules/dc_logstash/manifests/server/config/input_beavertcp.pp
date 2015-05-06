# Class: dc_logstash::server::config::input_beavertcp
#
# Server side configuration for beaver tcp input
#
class dc_logstash::server::config::input_beavertcp inherits dc_logstash::server {

  logstash::configfile { 'input_beavertcp':
    content => template('dc_logstash/server/input_beavertcp.erb'),
    order   => '01',
  }

}
