# Class: dc_logstash::server::config::filter_grok_apache_err
#
# Grok filter for apache error logs
#
class dc_logstash::server::config::filter_grok_apache_err inherits dc_logstash::server {

  logstash::configfile { 'filter_grok_apache_err':
    content => template('dc_logstash/server/filter_grok_apache_err.erb'),
    order   => '10',
  }

}
