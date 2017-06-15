# Class: dc_logstash::server::config::filter_grok_apache
#
# Grok filter for apache logs
#
class dc_logstash::server::config::filter_grok_apache {

  logstash::configfile { 'filter_grok_apache':
    source => 'puppet:///modules/dc_logstash/filter_grok_apache',
  }

}
