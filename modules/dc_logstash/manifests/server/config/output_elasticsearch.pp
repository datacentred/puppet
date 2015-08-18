# Class: dc_logstash::server::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::server::config::output_elasticsearch {

  include ::dc_logstash::server

  $elasticsearch_host = $dc_logstash::server::elasticsearch_host
  $elasticsearch_embedded = $dc_logstash::server::elasticsearch_embedded
  $elasticsearch_protocol = $dc_logstash::server::elasticsearch_protocol

  logstash::configfile { 'output_elasticsearch':
    content => template('dc_logstash/server/output_elasticsearch.erb'),
    order   => '20',
  }

}
