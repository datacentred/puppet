# Class: dc_profile::net::dns_master
#
# DNS master node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dns_master {

  include dc_dns::dnszone

  class { 'dns':
    nameservers => hiera(nameservers),
    forwarders  => hiera(forwarders),
    recursors   => hiera(client_networks),
    rndc_key    => hiera(rndc_key),
  }

  Dc_dns::Virtual::Dnszone <| |>

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_dns']

}
