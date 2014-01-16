class dc_profile::dns_master {

  include dc_dns::dnszone

  class { 'dns':
    nameservers => hiera(nameservers),
    forwarders  => hiera(forwarders),
    recursors   => hiera(client_networks),
    rndc_key    => hiera(rndc_key),
  }

  Dc_dns::Virtual::Dnszone <| |>

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_dns']

}
