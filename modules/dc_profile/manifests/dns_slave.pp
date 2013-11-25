class dc_profile::dns_slave {

  include dc_dns::dnszone

  Dc_dns::Virtual::Dnszone <| |> {
    isslave => true,
  }

}
