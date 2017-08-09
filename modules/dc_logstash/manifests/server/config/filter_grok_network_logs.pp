# Class: dc_logstash::server::config::filter_grok_network_logs
#
# Grok filter for network_logs logs
#
class dc_logstash::server::config::filter_grok_network_logs {

  include ::dc_logstash::server

  $grok_patterns_dir = $dc_logstash::server::grok_patterns_dir

  logstash::configfile { 'filter_grok_network_logs':
    source => 'puppet:///modules/dc_logstash/filter_grok_network_logs',
  }

}
