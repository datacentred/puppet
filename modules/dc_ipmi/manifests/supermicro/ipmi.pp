# Class: dc_ipmi::supermicro::ipmi
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
class dc_ipmi::supermicro::ipmi(
  $username,
  $password,
  $radius_server,
  $radius_secret,
  $radius_port,
  $radius_timeout,
) {

  $ipmi_hostname            = "${::hostname}-ipmi"

  class { 'dc_ipmi':
    ipmi_hostname            => $ipmi_hostname,
    ipmi_username            => $username,
    ipmi_password            => $password,
    ipmi_radius_server       => $radius_server,
    ipmi_radius_secret       => $radius_secret,
    ipmi_radius_portnum      => $radius_port,
    ipmi_radius_timeout      => $radius_timeout,
    ipmi_network_enable_dhcp => true,
    ipmi_network_enable_vlan => false,
  }
}
