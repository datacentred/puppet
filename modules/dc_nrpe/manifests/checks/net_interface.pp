# == Class: dc_nrpe::checks::net_interface
#
class dc_nrpe::checks::net_interface {

  dc_nrpe::check { 'check_net_interface':
    path   => '/usr/local/bin/check_net_interface.py',
    source => 'puppet:///modules/dc_nrpe/check_net_interface.py',
    sudo   => true,
  }

}
