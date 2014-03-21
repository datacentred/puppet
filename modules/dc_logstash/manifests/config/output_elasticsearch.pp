# Class: dc_logstash::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::config::output_elasticsearch {

  logstash::configfile { 'output_elasticsearch':
    source => 'puppet:///modules/dc_logstash/output_elasticsearch',
    order  => '20',
  }

}
