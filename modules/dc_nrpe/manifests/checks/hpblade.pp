# == Class: dc_nrpe::checks::hpblade
#
class dc_nrpe::checks::hpblade {

  dc_nrpe::check { 'check_hpasm':
    path   => '/usr/local/bin/check_hpasm',
    source => 'puppet:///modules/dc_nrpe/check_hpasm',
    sudo   => true,
  }

}
