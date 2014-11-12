# Class: dc_profile::hardware::ipmi::supermicro
#
# Configure RADIUS authentication and networking on Supermicro IPMI
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_profile::hardware::ipmi::supermicro {

  # Database parameters
  $ipmi_hostname            = "${::hostname}-ipmi"
  $ipmi_username            = hiera(supermicro::ipmi::username)
  $ipmi_password            = hiera(supermicro::ipmi::password)
  $ipmi_radius_server       = '10.10.192.111'
  $ipmi_radius_secret       = hiera(supermicro::ipmi::radius::secret)
  $ipmi_radius_portnum      = '1812'
  $ipmi_radius_timeout      = '3'

  class { 'dc_ipmi':
    ipmi_hostname            => $ipmi_hostname,
    ipmi_username            => $ipmi_username,
    ipmi_password            => $ipmi_password,
    ipmi_radius_server       => $ipmi_radius_server,
    ipmi_radius_secret       => $ipmi_radius_secret,
    ipmi_radius_portnum      => $ipmi_radius_portnum,
    ipmi_radius_timeout      => $ipmi_radius_timeout,
    ipmi_network_enable_dhcp => true,
    ipmi_network_enable_vlan => false,
  }
}
