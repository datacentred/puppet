# Class: dc_nrpe::checks::logstash
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
class dc_nrpe::checks::logstash {

  dc_nrpe::check { 'check_logcourier_netstat':
    path   => '/usr/local/bin/check_logcourier',
    source => 'puppet:///modules/dc_nrpe/check_logcourier',
    sudo   => true,
  }

}
