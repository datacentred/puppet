# Class: dc_logstash::config::input_syslog
#
# Server side configuration for syslog input
#
class dc_logstash::config::input_syslog {

  include dc_logstash::params

  logstash::configfile { 'input_syslog':
    content => template('dc_logstash/input_syslog.erb'),
    order   => '01',
  }

}
