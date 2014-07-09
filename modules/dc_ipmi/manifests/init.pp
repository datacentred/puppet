# Class: dc_ipmi
#
# Configure Supermicro IPMI. This module ensures that ipmitool is installed
# and loads the ipmi kernel modules. It also runs a python script which
# configures the hostname of ipmi to "<hostname>-ipmi" and enables RADIUS
# authentication
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
class dc_ipmi (
  $ipmi_hostname                = undef,
  $ipmi_username                = undef,
  $ipmi_password                = undef,
  $ipmi_radius_server           = undef,
  $ipmi_radius_secret           = undef,
  $ipmi_radius_portnum          = undef,
  $ipmi_radius_timeout          = undef,
  $ipmi_network_enable_dhcp     = undef,
  $ipmi_network_ipaddress       = undef,
  $ipmi_network_subnet_mask     = undef,
  $ipmi_network_default_gateway = undef,
  $ipmi_network_primary_dns     = undef,
  $ipmi_network_secondary_dns   = undef,
  $ipmi_network_domain_name     = undef,
  $ipmi_network_enable_vlan     = undef,
  $ipmi_network_vlan_tag        = undef,
  ) {


  kmod::install { 'ipmi_devintf':
    ensure => 'present',
  } ->

  kmod::install { 'ipmi_si':
    ensure => 'present',
  } ->

  package { 'ipmitool':
    ensure => 'installed',
  } ->

  ipmi_radius {$::ipmi_ipaddress:
    ensure    => present,
    username  => $ipmi_username,
    password  => $ipmi_password,
    ipaddress => $ipmi_radius_server,
    portnum   => $ipmi_radius_portnum,
    timeout   => $ipmi_radius_timeout,
    secret    => $ipmi_radius_secret,
    before    => Ipmi_network[$::ipmi_ipaddress],
  }
  # If this is a DHCP network configuration, don't deal with static network cfg
  if ($ipmi_network_enable_dhcp == true)
  {
    if ($ipmi_network_enable_vlan == false)
    {
      ipmi_network { $::ipmi_ipaddress:
        username    => $ipmi_username,
        password    => $ipmi_password,
        dhcp        => $ipmi_network_enable_dhcp,
        enable_vlan => $ipmi_network_enable_vlan,
        hostname    => $ipmi_hostname,
      } 
    }
    else
    {
      ipmi_network { $::ipmi_ipaddress:
        username    => $ipmi_username,
        password    => $ipmi_password,
        dhcp        => $ipmi_network_enable_dhcp,
        enable_vlan => $ipmi_network_enable_vlan,
        vlan_tag    => $ipmi_network_vlan_tag,
        hostname    => $ipmi_hostname,
      } 
    }
  }
  # Else force the user to specify all static network properties
  else
  {
    # Change only the hostname
    if ($ipmi_network_enable_vlan == false)
    {
      ipmi_network { $::ipmi_ipaddress:
        username             => $ipmi_username,
        password             => $ipmi_password,
        dhcp                 => $ipmi_network_enable_dhcp,
        enable_vlan          => $ipmi_network_enable_vlan,
        hostname             => $ipmi_hostname,
        ipaddress            => $ipmi_network_ipaddress,
        subnet_mask          => $ipmi_network_subnet_mask,
        primary_dns_server   => $ipmi_network_primary_dns,
        secondary_dns_server => $ipmi_network_secondary_dns,
        default_tagetway     => $ipmi_network_default_gateway,
        domain_name          => $ipmi_network_domain_name,
      } 
    }
    else
    {
      ipmi_network { $::ipmi_ipaddress:
        username             => $ipmi_username,
        password             => $ipmi_password,
        dhcp                 => $ipmi_network_enable_dhcp,
        enable_vlan          => $ipmi_network_enable_vlan,
        vlan_tag             => $ipmi_network_vlan_tag,
        hostname             => $ipmi_hostname,
        ipaddress            => $ipmi_network_ipaddress,
        subnet_mask          => $ipmi_network_subnet_mask,
        primary_dns_server   => $ipmi_network_primary_dns,
        secondary_dns_server => $ipmi_network_secondary_dns,
        default_tagetway     => $ipmi_network_default_gateway,
        domain_name          => $ipmi_network_domain_name,
      } 
    }
  }

}
