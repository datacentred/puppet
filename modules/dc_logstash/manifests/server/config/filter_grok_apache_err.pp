# Class: dc_logstash::server::config::filter_grok_apache_err
#
# Grok filter for apache error logs
#
class dc_logstash::server::config::filter_grok_apache_err {

  include ::dc_logstash::server

  $grok_patterns_dir = $dc_logstash::server::grok_patterns_dir

  logstash::configfile { 'filter_grok_apache_err':
    content => template('dc_logstash/server/filter_grok_apache_error.erb'),
  }

}
