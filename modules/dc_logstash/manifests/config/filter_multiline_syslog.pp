# Class: dc_logstash::config::filter_multiline_syslog
#
# Multiline filter for syslog
#
class dc_logstash::config::filter_multiline_syslog {

  logstash::configfile { 'filter_multiline_syslog':
    source => 'puppet:///modules/dc_logstash/filter_multiline_syslog',
    order  => '53',
  }

}
