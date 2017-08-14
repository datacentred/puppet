# Class: dc_logstash::server::config::filter_grok_telegraf
#
# Telegraf filter configuration
#
class dc_logstash::server::config::filter_grok_telegraf {

  logstash::configfile { 'filter_grok_telegraf':
    source => 'puppet:///modules/dc_logstash/filter_grok_telegraf',
  }

}
