# Class: dc_profile::net::dhcpd_slave
#
# DHCP slave node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dhcpd_slave {

  $localtimeservers = hiera(localtimeservers)
  $nameservers      = values(hiera(nameservers))
  $masterserver_ip  = hiera(dhcpdmasterip)
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
    zonemaster => $nameservers[0],
  }

  class { 'dhcp::failover':
    role         => 'secondary',
    peer_address => $masterserver_ip,
  }

  contain dc_dhcpdpools

  Dhcp::Pool {
    failover => 'dhcp-failover'
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_dhcp']

}
