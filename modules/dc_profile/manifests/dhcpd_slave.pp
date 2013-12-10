class dc_profile::dhcpd_slave {

  include stdlib
  include dc_dhcpdpools::poollist

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = values(hiera(nameservers))
  $masterserver_ip  = hiera(dhcpdmasterip)
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
    role         => "secondary",
    peer_address => $masterserver_ip,
  }

  Dc_dhcpdpools::Virtual::Dhcpdpool <| |>

  Dhcp::Pool { failover => "dhcp-failover" }

}
