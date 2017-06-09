# Class: dc_logstash::server::config::filter_grok_mysql_err
#
# Grok filter for MySQL error logs
#
class dc_logstash::server::config::filter_grok_mysql_err {

  include ::dc_logstash::server

  $grok_patterns_dir = $dc_logstash::server::grok_patterns_dir

  logstash::configfile { 'filter_grok_mysql_err':
    content => template('dc_logstash/server/filter_grok_mysql_err.erb'),
  }

}
