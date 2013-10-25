# This is the class containing the list of unrealized virtual dhcpd pools, don't use this class directly.

class dc_dhcpdpools::poollist {

include dc_dhcpdpools::virtual

  @dc_dhcpdpools::virtual::dhcpdpool { 'test':
    network => '10.0.1.0',
    mask    => '255.255.255.0',
    range   => '10.0.1.11 10.0.1.249',
    gateway => '10.0.1.1'
  }
}
