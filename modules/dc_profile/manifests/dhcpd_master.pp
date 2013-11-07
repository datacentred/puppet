class dc_profile::dhcpd_master {

  include stdlib

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = values(hiera(nameservers))
  $pxeserver        = hiera(pxeserver)
  $slaveserver_ip   = hiera(dhcpdslaveip)
  $omapi_key        = hiera(omapi_key)
  $omapi_secret     = hiera(omapi_secret)


  class { 'dhcp':
    dnsdomain => [
      'sal01.datacentred.co.uk',
      '0.0.10.in-addr.arpa',
      ],
    nameservers  => [$nameservers],
    ntpservers   => [$localtimeservers],
    interfaces   => ['bond0'],
    omapi_key    => 'omapi_key',
    omapi_secret => "$omapi_secret"
  }

  class { dhcp::failover:
    peer_address => $slaveserver_ip,
  }

  dhcp::pool { 'platform-services':
    network     => '10.10.192.0',
    mask        => '255.255.255.0',
    range       => '10.10.192.16 10.10.192.247',
    gateway     => '10.10.192.1',
    pxefile     => 'pxelinux.0',
    nextserver  => $ipaddress,
  }

  Dhcp::Pool { failover => "dhcp-failover" }

}
