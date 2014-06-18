# Class: dc_nrpe::lmsensors
#
# lm-sensors specific nrpe configuration
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
class dc_nrpe::lmsensors {

  sudo::conf { 'check_sensors':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_sensors',
  }

  file { '/etc/nagios/nrpe.d/sensors.cfg':
    ensure  => present,
    content => 'command[check_sensors]=sudo /usr/lib/nagios/plugins/check_sensors',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
