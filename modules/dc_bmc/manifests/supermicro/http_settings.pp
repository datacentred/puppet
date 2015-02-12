# Class: dc_bmc::supermicro::http_settings
#
# This class configures the bits of IPMI that can't be configured using
# ipmitool such as RADIUS authentication and changing the hostname.
# It ensures that ipmitool is installed and relevant kernel modules are
# loaded.
#
# Finally, depending on the parameters we do the network configuration.
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
class dc_bmc::supermicro::http_settings (
  $ipmi_hostname                = "${::hostname}-bmc",
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

  # We want to load the kernel modules before installing ipmitool
  # so that it can start the ipmi services
  include dc_bmc::modules
  include dc_bmc::install
  Class['dc_bmc::modules'] -> Class ['dc_bmc::install']

  # The ipmitool package needs to be installed before we do anything with IPMI
  Package['ipmitool'] -> Ipmi_radius<||>

  # We want to configure everything else before network configuration, because
  # it can sometimes reset our http session
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
