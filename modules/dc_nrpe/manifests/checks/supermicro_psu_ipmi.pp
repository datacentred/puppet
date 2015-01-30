# == Class: dc_nrpe::checks::supermicro_psu_ipmi
#
class dc_nrpe::checks::supermicro_psu_ipmi {

  dc_nrpe::check { 'check_supermicro_psu_ipmi':
    path => '/usr/lib/nagios/plugins/check_supermicro_psu_ipmi',
    sudo => true,
  }

}
