# Class: dc_profile::openstack::proxyip
#
# Takes care of handling the necessary multi-homed
# network configuration on the API proxies
#
# Parameters:
#
# Actions:
#
# Requires: puppet-network
#
# Sample Usage:
#
class dc_profile::openstack::proxyip {

  $int_if   = 'eth0'
  $ext_if   = 'eth1'
  $domain   = 'vagrant.local'
  $ip       = get_ip_addr("${::hostname}.${domain}")
  
  package { 'ifupdown-extra': }
    ensure => 'latest',
  }

  # Externally facing interface has a statically-assigned IP address
  # which we obtain from DNS.  You need to ensure that this interface
  # is already configured in Foreman in order for the necessary RR
  # to exist.
  network_config { $ext_if:
    ensure    => 'present',
    family    => 'inet',
    ipaddress => $ip,
    method    => 'static',
    netmask   => '255.255.255.248',
    onboot    => true,
  }
  
  # Finally, configure the necessary routes
  network_route { '10.10.0.0/16':
    ensure    => 'present',
    gateway   => '10.10.160.254',
    interface => $int_if,
    netmask   => '255.255.255.0',
    network   => 'default',
    require   => Package['ifupdown-extra'],
  }
    
}
