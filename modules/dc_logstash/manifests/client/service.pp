# == Class: dc_logstash::client::service
#
# Starts the logstash client
#
class dc_logstash::client::service {

  service { 'log-courier':
    ensure => 'running',
    enable => true,
  }

}
