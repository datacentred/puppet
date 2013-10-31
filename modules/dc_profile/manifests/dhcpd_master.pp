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
    nameservers  => ["$nameservers"],
    ntpservers   => ["$localtimeservers"],
    interfaces   => ['eth0'],
    #dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    #require      => Bind::Key[ $ddnskeyname ],
    pxeserver    => "$pxeserver",
    pxefilename  => 'pxelinux.0',
  }

  class { dhcp::failover:
    peer_address => $slaveserver_ip,
  }

  realize Dc_dhcpdpools::Virtual::Dhcpdpool['platform-services']
}
