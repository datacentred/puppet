# Class: dc_logstash::server::config::filter_grok_haproxy
#
# Grok filter for haproxy logs
#
class dc_logstash::server::config::filter_grok_haproxy {

  include ::dc_logstash::server

  $grok_patterns_dir = $dc_logstash::server::grok_patterns_dir

  logstash::configfile { 'filter_grok_haproxy':
    source => 'puppet:///modules/dc_logstash/filter_grok_haproxy',
  }

}
