class dc_profile::dns_slave {

  include dc_dns::dnszone

  class { 'dns':
    nameservers => hiera(nameservers),
    forwarders  => hiera(forwarders),
    recursors   => hiera(client_networks),
    rndc_key    => hiera(rndc_key),
  }

  Dc_dns::Virtual::Dnszone <| |> {
    isslave => true,
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_dns']

}
