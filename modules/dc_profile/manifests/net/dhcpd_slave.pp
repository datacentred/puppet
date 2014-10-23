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

  $localtimeservers = hiera(timeservers)
  $nameservers      = hiera(dnsmasters)
  $masterserver_ip  = hiera(dhcpdmasterip)
  $omapi_key        = hiera(omapi_key)
  $omapi_secret     = hiera(omapi_secret)
  $rndc_key         = hiera(rndc_key)

  class { 'dhcp':
    dnsdomain    => [
      $::domain,
      '0.0.10.in-addr.arpa',
    ],
    nameservers          => [$nameservers],
    ntpservers           => [$localtimeservers],
    interfaces           => ['bond0'],
    omapi_key            => 'omapi_key',
    omapi_secret         => $omapi_secret,
    ddns                 => true,
    dhcp_conf_fragments  => {
      one_lease_per_client => {
        target  => "${dhcp_dir}/dhcpd.conf",
        content => "one-lease-per-client true;",
        order   => 60,
      }
    }
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

  include dc_icinga::hostgroup_dhcp
  include dc_dhcp::secondary

}
