# == Class: dc_nrpe::checks::supermicro_psu_ipmi
#
class dc_nrpe::checks::supermicro_psu_ipmi (
  $raw_power1 = '0x06 0x52 0x07 0x78 0x01 0x78',
  $raw_power2 = '0x06 0x52 0x07 0x7a 0x01 0x78',
) {

  dc_nrpe::check { 'check_supermicro_psu_ipmi':
    path    => '/usr/local/bin/check_supermicro_psu_ipmi.sh',
    content => template('dc_nrpe/check_supermicro_psu_ipmi.erb'),
    sudo    => true,
  }

}
