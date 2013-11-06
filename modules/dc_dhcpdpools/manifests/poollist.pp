class dc_dhcpdpools::poollist {

include dc_dhcpdpools::virtual

# SAL01 networks
# Office
# Platform Services

  @dc_dhcpdpools::virtual::dhcpdpool { 'platform_services':
    network => '10.10.192.0',
    mask    => '255.255.255.0',
    range   => '10.10.192.16 10.10.192.247',
    gateway => '10.10.192.1',
    tag     => vlan192
  }
}
