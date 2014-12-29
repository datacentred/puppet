# == Class: dc_nrpe::checks::sensors
#
class dc_nrpe::checks::sensors {

  dc_nrpe::check { 'check_sensors':
    path => '/usr/lib/nagios/plugins/check_sensors',
    sudo => true,
  }

}
