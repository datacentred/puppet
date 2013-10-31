class dc_profile::dhcpd_slave {

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = hiera_array(nameservers)
  $pxeserver        = hiera(pxeserver)
  $masterserver_ip   = hiera(dhcpdmasterip)

  class { 'dhcp':
    dnsdomain => [
      'sal01.datacentred.co.uk',
      '0.0.10.in-addr.arpa',
      ],
    nameservers  => [$nameservers],
    ntpservers   => ["$localtimeservers"],
    interfaces   => ['eth0'],
    #dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    #require      => Bind::Key[ $ddnskeyname ],
    pxeserver    => "$pxeserver",
    pxefilename  => 'pxelinux.0',
  }

  class { dhcp::failover:
    role               => "secondary",
    peer_address => $masterserver_ip,
  }

  realize Dc_dhcpdpool::Virtual::dhcpdpool['platform-services']

}
