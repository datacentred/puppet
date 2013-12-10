class dc_dhcpdpools::poollist {

include dc_dhcpdpools::virtual

  @dc_dhcpdpools::virtual::dhcpdpool { 'rack_infra':
    network    => '10.10.40.0',
    mask       => '255.255.255.0',
    range      => '10.10.40.16 10.10.40.247',
    gateway    => '10.10.40.1',
    parameters => [ 'default-lease-time 86400', 'max-lease-time 172800',],
    tag        => vlan40
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'platform_services':
    network     => '10.10.192.0',
    mask        => '255.255.255.0',
    range       => '10.10.192.16 10.10.192.247',
    gateway     => '10.10.192.1',
    pxeserver   => '10.1.5.10',
    pxefilename => '/pxelinux.0',
    options     => [ 'domain-search "sal01.datacentred.co.uk"' ],
    parameters  => [ 'default-lease-time 86400', 'max-lease-time 172800',],
    tag         => vlan192
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'ipmi':
    network    => '10.10.128.0',
    mask       => '255.255.255.0',
    range      => '10.10.128.16 10.10.128.247',
    gateway    => '10.10.128.1',
    parameters => [ 'default-lease-time 86400', 'max-lease-time 172800',],
    tag        => vlan128
  }

}
