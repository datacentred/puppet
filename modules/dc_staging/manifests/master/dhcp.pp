# == Class: dc_staging::master::dhcp
#
# The module the staging master dhcp
# N.B. not using the dc_dhcp due to custom hacks, this is pretty vanilla 
#
class dc_staging::master::dhcp(
  $trunked_interface                  = hiera('dc_staging::master::trunked_interface')
){

  validate_string($trunked_interface)

  file { '/etc/dhcp/dhcpd.conf':
    content => template('dc_staging/etc/dhcp/dhcpd.conf.erb'),
  }

  file { '/etc/default/isc-dhcp-server':
    content => template('dc_staging/etc/default/isc-dhcp-server.erb'),
  }

  package{'isc-dhcp-server':}

  service{'isc-dhcp-server':}

  Package['isc-dhcp-server'] -> File['/etc/default/isc-dhcp-server','/etc/default/isc-dhcp-server'] ~> Service['isc-dhcp-server']

}
