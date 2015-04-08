# == Class: dc_nrpe::checks::foreman_interfaces
#
class dc_nrpe::checks::foreman_interfaces {

  dc_nrpe::check { 'check_foreman_interfaces':
    path    => '/usr/local/bin/check_foreman_interfaces.py',
    content => template('dc_nrpe/check_foreman_interfaces.py.erb'),
    sudo    => true,
  }

}
