class dc_profile::dns_slave {

  include dc_dns::dnszone

  class { 'dns':
    forwarders => hiera(forwarders),
    recursors  => hiera(client_networks),
  }

  Dc_dns::Virtual::Dnszone <| |> {
    isslave => true,
  }

}
