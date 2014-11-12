# Class: dc_logstash::config::filter_grok_mysql_err
#
# Grok filter for MySQL error logs
#
class dc_logstash::config::filter_grok_mysql_err {

  include dc_logstash::params

  logstash::configfile { 'filter_grok_mysql_err':
    content => template('dc_logstash/filter_grok_mysql_err.erb'),
    order   => '10',
  }

}
