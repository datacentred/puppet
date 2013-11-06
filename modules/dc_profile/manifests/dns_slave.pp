class dc_profile::dns_slave {

  include dc_dns
  
  Dc_dns::Virtual::Dnszone <| tag == sal01 |> {
    zonetype => 'slave',
    masters  => hiera(dnsmasters)
  }

}
