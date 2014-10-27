# Class: dc_logstash::config::output_elasticsearch
#
# Server side configuration for elasticsearch output
#
class dc_logstash::config::output_elasticsearch (
  $cluster,
  $embedded,
  $protocol,
){



  logstash::configfile { 'output_elasticsearch':
    content => template("dc_logstash/output_elasticsearch.erb"),
    order   => '20',
  }

}
