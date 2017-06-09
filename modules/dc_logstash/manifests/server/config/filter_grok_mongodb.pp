# Class: dc_logstash::server::config::filter_grok_mongodb
#
# Grok filter for mongodb logs
#
class dc_logstash::server::config::filter_grok_mongodb {

  logstash::configfile { 'filter_grok_mongodb':
    source => 'puppet:///modules/dc_logstash/filter_grok_mongodb',
  }

}
