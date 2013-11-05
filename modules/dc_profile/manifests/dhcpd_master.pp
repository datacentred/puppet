class dc_profile::dhcpd_master {

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = hiera(nameservers)
  $pxeserver        = hiera(pxeserver)
  $slaveserver_ip   = hiera(dhcpdslaveip)

  class { 'dhcp':
    dnsdomain => [
      'sal01.datacentred.co.uk',
      '0.0.10.in-addr.arpa',
      ],
    nameservers         => ["$nameservers"],
    ntpservers          => ["$localtimeservers"],
    interfaces          => ['bond0'],
    pxeserver           => "$pxeserver",
    pxefilename         => 'pxelinux.0',
  }

    dhcp::pool{ 'ops.dc1.example.net':
      network => '10.0.1.0',
      mask    => '255.255.255.0',
      range   => '10.0.1.100 10.0.1.200',
      gateway => '10.0.1.1',
    }

    realize (Dc_dhcpdpools::Virtual::Dhcpdpool['platform_services'])

}
