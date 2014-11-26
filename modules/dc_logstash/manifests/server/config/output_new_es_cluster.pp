# Class: dc_logstash::server::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::server::config::output_new_es_cluster inherits dc_logstash::server {

$output_es_cluster = "output {
  elasticsearch {
    host => logstash
    embedded => false
    protocol => http
  }
}"



  logstash::configfile { 'output_new_es_cluster':
    content => $output_es_cluster,
    order   => '20',
  }

}
