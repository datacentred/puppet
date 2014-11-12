# Class: dc_logstash::server::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::server::config::output_elasticsearch inherits dc_logstash::server {

  logstash::configfile { 'output_elasticsearch':
    content => template('dc_logstash/server/output_elasticsearch.erb'),
    order   => '20',
  }

}
