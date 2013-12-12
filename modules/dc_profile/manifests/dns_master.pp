class dc_profile::dns_master {

  include dc_dns::dnszone

  class { 'dns':
    forwarders => hiera(forwarders),
    recursors  => hiera(client_networks),
  }

  Dc_dns::Virtual::Dnszone <| |>

}
