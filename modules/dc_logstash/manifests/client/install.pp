# == Class: dc_logstash::client::install
#
# Installs the logstash client
#
class dc_logstash::client::install {

  package { 'log-courier':
    ensure => installed,
  }

}
