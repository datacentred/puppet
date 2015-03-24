# == Class: dc_nrpe::checks::net_interface
#
class dc_nrpe::checks::net_interfaces (
  $include = '^p\dp\d|^eth\d|^em\d|^bond\d',
  $exclude = '',
  $mtu     = '9000',
  ) {

  dc_nrpe::check { 'check_net_interfaces':
    path   => '/usr/local/bin/check_net_interfaces',
    source => 'puppet:///modules/dc_nrpe/check_net_interfaces',
    args   => "-m \'${mtu}\' -i \'${include}\' -e \'${exclude}\'"
  }

  file { '/usr/local/bin/check_net_interface.py':
    ensure => absent,
  }

}
