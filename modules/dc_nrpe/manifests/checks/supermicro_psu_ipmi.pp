# == Class: dc_nrpe::checks::supermicro_psu_ipmi
#
class dc_nrpe::checks::supermicro_psu_ipmi {

  dc_nrpe::check { 'check_supermicro_psu_ipmi':
    path   => '/usr/local/bin/check_supermicro_psu_ipmi.sh',
    source => 'puppet:///modules/dc_nrpe/check_supermicro_psu_ipmi.sh',
    sudo   => true,
  }

}
