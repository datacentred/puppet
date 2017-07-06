# Class: dc_logstash::server::config::filter_grok_nginx
#
# Grok filter for nginx logs
#
class dc_logstash::server::config::filter_grok_nginx {

  logstash::configfile { 'filter_grok_nginx':
    source => 'puppet:///modules/dc_logstash/filter_grok_nginx',
  }

}
