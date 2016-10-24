#
# Class dc_staging::master::interfaces
#
# Templated rather than using an upstream module as there seems 
# to be a lack of support for alias interfaces 
#
class dc_staging::master::interfaces(
  $trunked_interface          = hiera('dc_staging::master::trunked_interface'),
  $trunked_interface_ip       = hiera('dc_staging::master::trunked_interface'),
  $trunked_interface_netmask  = hiera('dc_staging::master::trunked_interface'),
  $alias_interfaces           = hiera('dc_staging::master::alias_interfaces'),
){

  validate_string($trunked_interface)
  validate_string($trunked_interface_ip)
  validate_string($trunked_interface_netmask)
  validate_hash($alias_interfaces)

  file { '/etc/network/interfaces.d/trunked_interface':
    content => template('dc_staging/trunked_interface.erb'),
  }

  file { '/etc/network/interfaces.d/alias_interfaces':
    content => template('dc_staging/alias_interfaces.erb'),
  }
}
