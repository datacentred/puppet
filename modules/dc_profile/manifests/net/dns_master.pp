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

  class { 'dns':
    nameservers => hiera(nameservers),
    forwarders  => hiera(forwarders),
    recursors   => hiera(client_networks),
    rndc_key    => hiera(rndc_key),
  }

  class { 'dc_dns':
    isslave => false,
  }
  contain 'dc_dns'

  include dc_icinga::hostgroups
  realize External_facts::Fact['dc_hostgroup_dns']

  Dns_resource <<||>>

}
