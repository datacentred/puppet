# Class: dc_logstash::server::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::server::config::output_new_es_cluster inherits dc_logstash::server {

  logstash::configfile { 'output_new_es_cluster':
    source => 'puppet:///modules/dc_logstash/output_new_es_cluster',
    order   => '20',
  }

}
