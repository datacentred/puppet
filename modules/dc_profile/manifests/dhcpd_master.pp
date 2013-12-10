class dc_profile::dhcpd_master {

  include stdlib
  include dc_dhcpdpools::poollist

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = values(hiera(nameservers))
  $pxeserver        = hiera(pxeserver)
  $slaveserver_ip   = hiera(dhcpdslaveip)
  $omapi_key        = hiera(omapi_key)
  $omapi_secret     = hiera(omapi_secret)
  $fragments        = { 'domain-search' => 'sal01.datacentred.co.uk' }


  class { 'dhcp':
    dnsdomain    => [
      'sal01.datacentred.co.uk',
      '0.0.10.in-addr.arpa',
      ],
    nameservers                                  => [$nameservers],
    ntpservers                                   => [$localtimeservers],
    interfaces                                   => ['bond0'],
    omapi_key                                    => 'omapi_key',
    omapi_secret                                 => "$omapi_secret",
  }

  class { dhcp::failover:
    peer_address => "$slaveserver_ip",
    load_split   => '255',
  }

  Dc_dhcpdpools::Virtual::Dhcpdpool <| |>

  Dhcp::Pool { failover => "dhcp-failover" }

}
