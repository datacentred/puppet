# == Class: dc_nrpe::sensors
#
class dc_nrpe::sensors {

  dc_nrpe::check { 'check_sensors':
    path => '/usr/lib/nagios/plugins/check_sensors',
    sudo => true,
  }

}
