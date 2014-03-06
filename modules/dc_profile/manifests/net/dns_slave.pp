# Class: dc_profile::net::dns_slave
#
# DNS slave node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dns_slave {

  class { 'dns':
    nameservers => hiera(nameservers),
    forwarders  => hiera(forwarders),
    recursors   => hiera(client_networks),
    rndc_key    => hiera(rndc_key),
  }

  class { 'dc_dns':
    isslave => true,
  }
  contain 'dc_dns'

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_dns']

}
