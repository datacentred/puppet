# Class: dc_nrpe::logstash
#
# Logstash specific nrpe configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_nrpe::logstash {

  dc_nrpe::check { 'check_logstash_forwarder_netstat':
    path   => '/usr/local/bin/check_logstash-forwarder',
    source => 'puppet:///modules/dc_nrpe/check_logstash-forwarder',
    sudo   => true,
  }

}
