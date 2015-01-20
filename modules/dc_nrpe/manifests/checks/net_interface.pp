# == Class: dc_nrpe::checks::net_interface
#
class dc_nrpe::checks::net_interface (
  $excluded_ints="",
){

  dc_nrpe::check { 'check_net_interface':
    path    => '/usr/local/bin/check_net_interface.py',
    content => template('dc_nrpe/check_net_interface.py.erb'),
    sudo    => true,
  }

}
