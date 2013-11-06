class dc_profile::dns_master {

  include dns
  include dc_dns::dnszone

  Dc_dns::Virtual::Dnszone <| tag == sal01 |>
  Dc_dns::Virtual::Dnszone <| tag == "10.10.192" |>

}
