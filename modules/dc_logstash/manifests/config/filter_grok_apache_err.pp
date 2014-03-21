# Class: dc_logstash::config::filter_grok_apache_err
#
# Grok filter for apache error logs
#
class dc_logstash::config::filter_grok_apache_err {

  $logstash_grok_patterns_dir = hiera(logstash_grok_patterns_dir)

  logstash::configfile { 'filter_grok_apache_err':
    content => template('dc_logstash/filter_grok_apache_err.erb'),
    order   => '51',
  }

}
