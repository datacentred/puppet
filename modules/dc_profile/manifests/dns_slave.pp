class dc_profile::dns_slave {

  include dc_dns::dnszone
  
  Dc_dns::Virtual::Dnszone <| |> {
    zonetype => 'slave',
    masters  => hiera(dnsmasters)
  }

}
