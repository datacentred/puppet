class dc_profile::dns_master {

  include dc_dns

  Dc_dns::Virtual::Dnszone <| tag == sal01 |>
  Dc_dns::Virtual::Dnszone <| tag == "10.10.192" |>

}
