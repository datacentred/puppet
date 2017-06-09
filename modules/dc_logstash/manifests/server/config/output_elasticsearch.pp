# Class: dc_logstash::server::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::server::config::output_elasticsearch {

  include ::dc_logstash::server

  $elasticsearch_hosts = $::dc_logstash::server::elasticsearch_hosts

  logstash::configfile { 'output_elasticsearch':
    content => template('dc_logstash/server/output_elasticsearch.erb'),
  }

}
