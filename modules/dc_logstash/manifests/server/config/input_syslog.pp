# Class: dc_logstash::server::config::input_syslog
#
# Server side configuration for syslog input
#
class dc_logstash::server::config::input_syslog {

  include ::dc_logstash::server

  $syslog_port = $dc_logstash::server::syslog_port

  logstash::configfile { 'input_syslog':
    content => template('dc_logstash/server/input_syslog.erb'),
    order   => '01',
  }

}
