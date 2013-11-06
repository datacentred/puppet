class dc_profile::dns_master {

  include dc_dns::dnszone

  Dc_dns::Virtual::Dnszone <| |> {
    zonetype => 'master'
  }

}
