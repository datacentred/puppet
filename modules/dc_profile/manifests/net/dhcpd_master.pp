#
class dc_profile::net::dhcpd_master {

  include stdlib
  include dc_dhcpdpools::poollist

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = values(hiera(nameservers))
  $slaveserver_ip   = hiera(dhcpdslaveip)
  $omapi_key        = hiera(omapi_key)
  $omapi_secret     = hiera(omapi_secret)
  $rndc_key         = hiera(rndc_key)


  class { 'dhcp':
    dnsdomain    => [
      'sal01.datacentred.co.uk',
      '0.0.10.in-addr.arpa',
    ],
    nameservers  => [$nameservers],
    ntpservers   => [$localtimeservers],
    interfaces   => ['bond0'],
    omapi_key    => 'omapi_key',
    omapi_secret => $omapi_secret,
    ddns         => true,
  }

  class { 'dhcp::ddns':
    key        => $rndc_key,
    zonemaster => '127.0.0.1'
  }

  class { 'dhcp::failover':
    peer_address => $slaveserver_ip,
    load_split   => '255',
  }

  Dc_dhcpdpools::Virtual::Dhcpdpool <| |>

  Dhcp::Pool { failover => 'dhcp-failover' }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_dhcp']

}
