# Class: dc_logstash::server::config::filter_grok_mysql_err
#
# Grok filter for MySQL error logs
#
class dc_logstash::server::config::filter_grok_mysql_err inherits dc_logstash::server {

  logstash::configfile { 'filter_grok_mysql_err':
    content => template('dc_logstash/server/filter_grok_mysql_err.erb'),
    order   => '10',
  }

}
