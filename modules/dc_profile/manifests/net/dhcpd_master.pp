# Class: dc_profile::net::dhcpd_master
#
# DHCP master node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dhcpd_master {

  $localtimeservers = hiera(timeservers)
  $nameservers      = values(hiera(nameservers))
  $slaveserver_ip   = hiera(dhcpdslaveip)
  $omapi_key        = hiera(omapi_key)
  $omapi_secret     = hiera(omapi_secret)
  $rndc_key         = hiera(rndc_key)

  class { 'dhcp':
    dnsdomain    => [
      $::domain,
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

  contain dc_dhcpdpools

  Dhcp::Pool { failover => 'dhcp-failover' }

  include dc_icinga::hostgroup_dhcp
  include dc_dhcp::primary

}
