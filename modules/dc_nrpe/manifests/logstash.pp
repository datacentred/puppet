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
class dc_nrpe::logstash(
  $logcourier_port,
){

  sudo::conf { 'check_logcourier_netstat':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_logcourier.sh',
  }

  file { '/etc/nagios/nrpe.d/logcourier_netstat.cfg':
    ensure  => present,
    content => 'command[check_logcourier_netstat]=sudo /usr/lib/nagios/plugins/check_logcourier.sh',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { '/usr/lib/nagios/plugins/check_logcourier.sh':
    ensure  => file,
    content => template('dc_nrpe/check_logcourier.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }
}
