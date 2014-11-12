# Class: dc_logstash::server::config::output_riemann
#
# Server side configuration for riemann output
#
class dc_logstash::server::config::output_riemann {

  logstash::configfile { 'output_riemann':
    source => 'puppet:///modules/dc_logstash/output_riemann',
    order  => '21',
  }

}
