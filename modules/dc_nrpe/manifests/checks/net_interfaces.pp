# == Class: dc_nrpe::checks::net_interface
#
class dc_nrpe::checks::net_interfaces {

  dc_nrpe::check { 'check_net_interfaces':
    path   => '/usr/local/bin/check_net_interfaces',
    source => 'puppet:///modules/dc_nrpe/check_net_interfaces',
    sudo   => true,
  }

}
