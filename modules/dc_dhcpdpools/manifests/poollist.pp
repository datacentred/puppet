# This is the class containing the list of unrealized virtual dhcp pools
# don't use this class directly.

class dc_dhcpdpools::poollist {

include dc_dhcpdpools::virtual

# FIXME Guest wireless network
# FIXME Seperate wireless and wired VLAN's for office

  @dc_dhcpdpools::virtual::dhcpdpool { 'office':
    network => '10.1.2.0',
    mask    => '255.255.255.0',
    range   => '10.0.2.11 10.0.2.249',
    gateway => '10.1.2.1',
    tag     => 'vlan2'
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'rack-infr':
    network => '10.1.6.0',
    mask    => '255.255.255.0',
    range   => '10.1.6.11 10.0.1.249',
    gateway => '10.1.6.1',
    tag     => 'vlan6'
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'production-netserv':
    network => '10.1.10.0',
    mask    => '255.255.255.0',
    range   => '10.1.10.11 10.0.1.249',
    gateway => '10.1.10.1',
    tag     => 'vlan10'
  }
}
