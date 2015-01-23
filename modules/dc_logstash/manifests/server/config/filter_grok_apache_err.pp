# Class: dc_logstash::server::config::filter_grok_apache_err
#
# Grok filter for apache error logs
#
class dc_logstash::server::config::filter_grok_apache_err inherits dc_logstash::server {

  logstash::configfile { 'filter_grok_apache_err':
    source => 'puppet:///modules/dc_logstash/filter_grok_apache_error',
    order  => '10',
  }

}